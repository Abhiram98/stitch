import ast
import copy

from pybrary_extraction.lisp2py.Lisp2Py import Lisp2Py
from pybrary_extraction.lisp2py.utils import has_return_stmnt, get_undef_vars
from pybrary_extraction.ast_utils import FindTargetVariables, FindReadVariables, FindFuncAndClassDefs


class Abstraction2Py:

    def __init__(self, abstraction, live_out=None):
        if live_out is None:
            live_out = []
        self.abstraction = abstraction
        self.param_count = 0
        self.args_map = {}
        self.live_out = live_out

    def convert(self, fn_name='fn_0'):
        py_ast = Lisp2Py(self.abstraction).get_py_ast()
        py_ast.type_ignores = []
        ast.fix_missing_locations(py_ast)
        self.find_parameters(py_ast)
        fn_def = ast.FunctionDef(
            name=fn_name,
            args=ast.arguments(
                posonlyargs=[],
                args=[ast.arg(arg=i) for i in self.args_map.values()],
                kwonlyargs=[],
                kw_defaults=[],
                defaults=[])
            ,
            body=[py_ast],
            decorator_list=[]
        )
        self.add_return_value(fn_def)
        ast.fix_missing_locations(fn_def)
        return ast.unparse(fn_def)

    def find_parameters(self, py_ast):
        self.set_param_names(py_ast)
        self.get_additional_params(py_ast)

    def get_additional_params(self, py_ast):
        """find additional parameters used by the abs_fn_def, which are not defined within"""
        py_ast_str = ast.unparse(py_ast)
        undef_vars = sorted(get_undef_vars(py_ast_str))  # sort for determinism
        for var in undef_vars:
            if var not in self.args_map.values():
                self.args_map[var] = var

    def set_param_names(self, py_ast):
        for node in ast.walk(py_ast):
            if isinstance(node, ast.Name) and node.id.startswith("#"):
                node.id = self.get_param_name(node.id)

    def get_param_name(self, arg_name):
        if arg_name in self.args_map:
            return self.args_map[arg_name]
        else:
            arg_num = int(arg_name.strip('#'))
            param_name = f'_param{arg_num}'
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

            return_stmnt = "return {0}".format(",".join(return_vars))
            return_node = ast.parse(return_stmnt).body[0]
            abs_fn_def.body.append(return_node)
            # last_stmnt = ast.Return(value=copy.deepcopy(abs_fn_def.body[-1]))
            # abs_fn_def.body.pop()  # remove last statement
            # abs_fn_def.body.append(last_stmnt)
            # # Return the last statement

    def get_return_vars(self, abs_fn_def):
        """Variable which are live out of the block, defined in the block,
        or are function/class definitions."""

        target_vars_finder = FindTargetVariables()
        func_class_def_finder = FindFuncAndClassDefs()
        for b in abs_fn_def.body:
            func_class_def_finder.visit(b)
            target_vars_finder.visit(b)
        return_vars = set(self.live_out) \
            .intersection(set(target_vars_finder.lhs_vars)) \
            .union(set(func_class_def_finder.defs))
        return return_vars
