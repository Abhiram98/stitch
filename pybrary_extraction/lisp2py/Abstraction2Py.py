import ast
import copy
import sys

from pybrary_extraction.lisp2py.Lisp2Py import Lisp2Py
from pybrary_extraction.lisp2py.utils import has_return_stmnt, get_undef_vars
from pybrary_extraction.ast_utils import FindTargetVariables, FindReadVariables, FindFuncAndClassDefs, StringReplacer
from pybrary_extraction.lisp2py.StitchAbstraction import StitchAbstraction, StitchParam
from pybrary_extraction.lisp2py.AstValidityChecker import AstValidityChecker


class Abstraction2Py:
    PARAM_KEY = "_param"

    def __init__(self, abstraction: StitchAbstraction,
                 string_hashmap=None,
                 find_additional_params=True):

        self.abstraction = abstraction
        self.param_count = 0
        self.args_map = {}
        if string_hashmap is None:
            string_hashmap = {}
        self.string_hashmap = string_hashmap
        self.find_additional_params = find_additional_params

        # parameters which include trailing statements.
        # These need to be kicked out the abstraction body and at all call sites.
        self.trailing_statement_params = set()

        self.abstraction_body_as_module = None
        self.abstraction_body_as_fndef = None

    def convert(self,
                fn_name=None,
                add_return_value=True):
        if fn_name is None:
            fn_name = self.abstraction.abstraction_name

        lisp_parts = Lisp2Py.parse_lisp(self.abstraction.abstraction_body_lisp)
        lisp_parts = Lisp2Py.wrap_module(lisp_parts)
        py_ast = Lisp2Py.construct(lisp_parts)
        StringReplacer(self.string_hashmap).visit(py_ast)
        py_ast.type_ignores = []
        ast.fix_missing_locations(py_ast)
        self.find_parameters(py_ast)
        self.check_valid_abstraction(py_ast)
        self.kick_trailing_statement_params(py_ast)
        fn_def = ast.FunctionDef(
            name=fn_name,
            args=ast.arguments(
                posonlyargs=[],
                args=[ast.arg(arg=i.param_name)
                      for i in sorted(self.abstraction.parameters, key=lambda x: x.position)
                      if not i.is_trailing],
                kwonlyargs=[],
                kw_defaults=[],
                defaults=[])
            ,
            body=py_ast.body,
            decorator_list=[]
        )
        if add_return_value:
            self.add_return_value(fn_def)
        ast.fix_missing_locations(fn_def)
        self.abstraction_body_as_fndef = fn_def
        self.abstraction_body_as_module = py_ast
        return ast.unparse(fn_def)

    def find_parameters(self, py_ast):
        self.set_param_names(py_ast)
        if self.find_additional_params:
            self.get_additional_params(py_ast)

        stitch_params = sorted(list(filter(lambda x: x.startswith(Abstraction2Py.PARAM_KEY), self.args_map.values())))
        additional_params = sorted(
            list(filter(lambda x: not x.startswith(Abstraction2Py.PARAM_KEY), self.args_map.values())))
        ordered_params = stitch_params + additional_params
        self.abstraction.parameters.update(
            set([StitchParam(param, i) for i, param in enumerate(ordered_params)])
        )

    def get_additional_params(self, py_ast):
        """find additional parameters used by the abs_fn_def, which are not defined within"""
        py_ast_str = ast.unparse(py_ast)
        undef_vars = sorted(get_undef_vars(py_ast_str))  # sort for determinism
        for var in undef_vars:
            if not var.startswith(Abstraction2Py.PARAM_KEY) and \
                    var not in self.args_map.values():
                self.args_map[var] = var

    def set_param_names(self, py_ast):
        for node in ast.walk(py_ast):
            if isinstance(node, ast.Name) and node.id.startswith("#"):
                node.id = self.get_set_param_name(node.id)

    def get_set_param_name(self, arg_name):
        if arg_name in self.args_map:
            return self.args_map[arg_name]
        else:
            arg_num = int(arg_name.strip('#'))
            param_name = f'{Abstraction2Py.PARAM_KEY}{arg_num}'
            self.param_count += 1
            self.args_map[arg_name] = param_name
            return param_name

    def add_return_value(self, abs_fn_def: ast.FunctionDef):
        # TODO: this is a naive implementation.
        #  A better implementation involves some sort of liveness analysis,
        #  to determine what the target variables are.
        if has_return_stmnt(abs_fn_def):
            return abs_fn_def
        else:
            return_vars = self.get_return_vars(abs_fn_def)
            if len(return_vars):
                return_stmnt = "return {0}".format(",".join(return_vars))
                return_node = ast.parse(return_stmnt).body[0]
                abs_fn_def.body.append(return_node)
            elif isinstance(abs_fn_def.body[-1], ast.Expr) or \
                    isinstance(abs_fn_def.body[-1], ast.expr):
                # TODO: this code should be deprecated.
                # Return the last statement, in case it is an expression.
                last_stmnt = ast.Return(
                    value=copy.deepcopy(Abstraction2Py.strip_expr(abs_fn_def.body[-1])))
                abs_fn_def.body.pop()  # remove last statement
                abs_fn_def.body.append(last_stmnt)

    def get_return_vars(self, abs_fn_def):
        """Variable which are live out of the block, defined in the block,
        or are function/class definitions."""

        target_vars_finder = FindTargetVariables()
        func_class_def_finder = FindFuncAndClassDefs()
        for b in abs_fn_def.body:
            func_class_def_finder.visit(b)
            target_vars_finder.visit(b)
        return_vars = set(self.abstraction.live_vars_out) \
            .intersection(set(target_vars_finder.lhs_vars)) \
            .union(set(func_class_def_finder.defs))
        self.abstraction.returned_vars = sorted(return_vars)  # sort for determinism
        return self.abstraction.returned_vars

    def check_valid_abstraction(self, py_ast):
        # check if there are no hole in between.
        checker = AstValidityChecker(self.args_map.values())
        checker.visit(py_ast)
        self.trailing_statement_params = \
            self.trailing_statement_params.union(checker.trailing_statement_params)
        for param in self.abstraction.parameters:
            if param.param_name in self.trailing_statement_params:
                param.is_trailing = True

    @staticmethod
    def strip_expr(node):
        if isinstance(node, ast.Expr):
            return node.value
        return node

    def kick_trailing_statement_params(self, py_ast: ast.Module):
        # modify abstraction body.
        # Modify parameters list.
        if len(self.trailing_statement_params):
            if isinstance(py_ast.body[-1], ast.Name) and py_ast.body[-1].id in self.trailing_statement_params:
                py_ast.body = py_ast.body[:-1]

            for k in list(self.args_map):
                if self.args_map[k] in self.trailing_statement_params:
                    del self.args_map[k]


if __name__ == '__main__':
    print(
        Abstraction2Py(
            StitchAbstraction(sys.argv[1], [], "abs0", {}),
            find_additional_params=False
        )
        .convert()
    )
