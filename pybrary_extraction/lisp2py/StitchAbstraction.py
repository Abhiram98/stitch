import ast

import pybrary_extraction.lisp2py as lisp2py
import pybrary_extraction.python2lisp as python2lisp
from pybrary_extraction.ast_utils import FindReadVariables


class StitchParam:
    def __init__(self, param_name, position, is_trailing=False):
        self.param_name = param_name
        self.is_trailing = is_trailing
        self.position = position

    def __hash__(self):
        return hash(self.param_name)


class StitchUse:
    def __init__(self, application, target, string_hashmap):
        # target code-scope where abstraction is applied.
        self.application = application
        self.target = target
        self.string_hashmap = string_hashmap

        Py2Lisp = python2lisp.Py2Lisp
        wrapped_app = f"({Py2Lisp.module_keyword} " \
                      f"({Py2Lisp.statement_keyword} ({application}) {Py2Lisp.empty_statement_keyword}))"

        rewrite_app = lisp2py.Rewrite2Py(wrapped_app, available_abstractions=[], string_hashmap=self.string_hashmap)
        rewrite_app.convert(unparse=False)
        self.application_ast: ast.Module = rewrite_app.converted_ast
        rewrite_target = lisp2py.Rewrite2Py(target, available_abstractions=[], string_hashmap=self.string_hashmap)
        self.target_py = rewrite_target.convert()
        self.target_ast: ast.Module = rewrite_target.converted_ast
        self.parameter_map = {} # map of param_name -> value passes

    def set_params_map_from_stitch_params(self, stitch_params: set[StitchParam]):
        func_call: ast.Call = self.application_ast.body[-1].value
        for param in stitch_params:
            if param.position < len(func_call.args):
                self.parameter_map[param.param_name] = \
                    func_call.args[param.position]

    def get_param_map_filtered_by_names(self):
        new_map = {}
        for param in self.parameter_map:
            if isinstance(self.parameter_map[param], ast.Name):
                new_map[self.parameter_map[param].id] = param
        return new_map

    def get_application_param_from_number(self, param_number)-> ast.Expr:
        func_call: ast.Call = self.application_ast.body[-1].value
        assert isinstance(func_call, ast.Call)
        if param_number >= len(func_call.args):
            raise Exception(f"param_number {param_number}>={len(func_call.args)}")
        return func_call.args[param_number]




class StitchAbstraction:
    def __init__(self, abstraction_body_lisp, uses, abstraction_name, string_hashmap):
        self.abstraction_body_lisp = abstraction_body_lisp
        self.uses = uses
        self.uses_py = []
        self.parameters: set[StitchParam] = set()  # input parameters
        self.live_vars_out = set()  # live variables out the block
        self.returned_vars = set()  # variables returned by the abstraction
        self.abstraction_body_py = None
        self.abstraction_name = abstraction_name
        self.string_hashmap = string_hashmap

        for use in self.uses:
            for application, target in use.items():
                # 'application' is a function call that always looks like
                # fn_0 param1 param2 param3 ...

                self.uses_py.append(
                    StitchUse(
                        application, target, self.string_hashmap
                    )
                )

    def get_and_set_live_out(self, original_lisps):
        py_originals = []
        for lisp in original_lisps:
            py_originals.append(
                lisp2py.Lisp2Py(lisp, string_hashmap=self.string_hashmap).convert())

        live_vars_out = set()
        for use in self.uses_py:
            use.set_params_map_from_stitch_params(self.parameters)
            live_vars_out = self.find_live_vars_from_extracted_fragment(py_originals, use)
            live_vars_out = live_vars_out.union(
                self.find_live_vars_from_trailing_statements(use))
            name_map = use.get_param_map_filtered_by_names()
            if intersecting := live_vars_out.intersection(set(name_map.keys())):
                live_vars_out = live_vars_out.union({name_map[i] for i in intersecting})



        self.live_vars_out = self.live_vars_out.union(live_vars_out)
        return live_vars_out

    def find_live_vars_from_trailing_statements(self, use):
        live_vars_out = set()
        read_vars = FindReadVariables()
        for trailing_param in self.get_trailing_statement_params():
            # run liveness on trailing statements.
            trailing_statements = use.get_application_param_from_number(trailing_param.position)
            if isinstance(trailing_statements, list):
                trailing_statements = ast.Module(body=trailing_statements)
            elif trailing_statements == python2lisp.Py2Lisp.empty_statement_keyword:
                continue
            read_vars.visit(trailing_statements)
            live_vars_out = live_vars_out.union(set(read_vars.rhs_vars))
        return live_vars_out

    def find_live_vars_from_extracted_fragment(self, py_originals, use):
        live_vars_out = set()
        is_abstraction_call = lambda x: isinstance(x, ast.Call) and x.func.id.startswith("fn_")
        new_body = list(filter(lambda x:
                               not isinstance(x, ast.ImportFrom) and not is_abstraction_call(x), use.target_ast.body))
        target = ast.unparse(ast.Module(body=new_body, type_ignores=[]))
        for py_orig in py_originals:
            index = py_orig.find(target)
            if index != -1:
                # Found the code where the method was extracted.
                live_vars = lisp2py.ExtractedFragment \
                    .create_from(py_orig, target, index).find_used_vars_later()
                live_vars_out = live_vars_out.union(live_vars)
        return live_vars_out

    def get_additional_params(self):
        return [i for i in self.parameters if not i.param_name.startswith(lisp2py.Abstraction2Py.PARAM_KEY)]

    def get_trailing_statement_params(self)-> list[StitchParam]:
        return list(filter(lambda x: x.is_trailing, self.parameters))

    def set_trailing_statement_param(self, *params):
        for p in self.parameters:
            if p.param_name in params:
                p.is_trailing = True

    def compute_body_py(self, stitch_originals):
        abstraction_py_obj = lisp2py.Abstraction2Py(self, self.string_hashmap)
        self.abstraction_body_py = \
            abstraction_py_obj.convert(add_return_value=False)
        self.set_trailing_statement_param(*abstraction_py_obj.trailing_statement_params)

        self.get_and_set_live_out(stitch_originals)
        abstraction_py_obj.add_return_value(abstraction_py_obj.abstraction_body_as_fndef)
        self.abstraction_body_py = ast.unparse(abstraction_py_obj.abstraction_body_as_fndef)
        return self.abstraction_body_py
