import ast
import copy
import sys
from typing import Any

from pybrary_extraction.lisp2py.StitchAbstraction import StitchAbstraction
from pybrary_extraction.python2lisp import Py2Lisp
from pybrary_extraction.lisp2py.Lisp2Py import Lisp2Py
# from pybrary_extraction.python2lisp import Py2Lisp
from pybrary_extraction.ast_utils import StringReplacer
from pybrary_extraction.lisp2py.KickTrailingParamsVisitor import KickOutTrailingParam
from pybrary_extraction.lisp2py.ExtractedFragment import AddScopeLinks

class AbstractionCall:
    def __init__(self, func_name, params=None):
        self.func_name = func_name
        self.params = params

        self.items = ['Call', func_name]
        if params:
            self.items += params

    def __getitem__(self, item):
        return self.items[item]


class Rewrite2Py:
    """
    Convert stitch rewritten code_str to python.
    """

    def __init__(self, lisp_str,
                 available_abstractions: list,
                 abstraction_prefix='fn_',
                 library_name='leroy_library',
                 string_hashmap=None):

        self.lisp_str = lisp_str
        self.available_abstractions = available_abstractions
        self.abstraction_prefix = abstraction_prefix
        self.abstractions_used = set()
        self.library_name = library_name
        if string_hashmap is None:
            string_hashmap = {}
        self.string_hashmap = string_hashmap
        self.converted_ast = None

    def convert(self):

        lisp_parts = Lisp2Py.parse_lisp(self.lisp_str)
        lisp_parts = Lisp2Py.wrap_statements_list(lisp_parts)
        lisp_parts = Lisp2Py.wrap_module(lisp_parts)
        lisp_parts = self.create_abstraction_calls(lisp_parts)
        lisp_parts = self.make_calls_exprs(lisp_parts)
        self.check_for_list_param(lisp_parts)
        py_ast = Lisp2Py.construct(lisp_parts)
        if len(self.available_abstractions):
            AddScopeLinks().visit(py_ast)
            KickOutTrailingParam(self.available_abstractions).visit(py_ast)
        StringReplacer(self.string_hashmap).visit(py_ast)
        py_ast = self.add_library_import_statements(py_ast)
        py_ast.type_ignores = []
        ast.fix_missing_locations(py_ast)
        print(ast.dump(py_ast, indent=4))
        self.converted_ast = py_ast
        return ast.unparse(py_ast)

    def check_for_list_param(self, lisp_parts):
        if len(lisp_parts) > 1 and \
                isinstance(lisp_parts[1], list) and \
                len(lisp_parts[1]) and \
                lisp_parts[1][0] == Py2Lisp.list_keyword:
            raise Exception(f"Shouldn't be {Py2Lisp.list_keyword} here.")

    def create_abstraction_calls(self, lisp_root):
        """Wrap abstraction calls with 'Call' nodes and pass additional
        parameters if necessary."""
        if isinstance(lisp_root, str):
            if lisp_root.startswith(self.abstraction_prefix):
                self.abstractions_used.add(lisp_root)
                return AbstractionCall(lisp_root)
            return lisp_root
        elif isinstance(lisp_root, list):
            new_lisp = []
            for node in lisp_root:
                new_lisp.append(self.create_abstraction_calls(node))

            # if lisp_root[0].startswith(self.abstraction_prefix):
            if isinstance(new_lisp[0], AbstractionCall):
                fn_name = new_lisp[0].func_name
                args = copy.deepcopy(new_lisp[1:])
                matches = self.get_matching_abstraction(fn_name)
                if len(matches) > 0:
                    additional_params = matches[0].get_additional_params()
                    if len(additional_params) > 0:
                        args += additional_params

                new_lisp_root = ['Call', fn_name, ['__list__', *args]]

                self.abstractions_used.add(fn_name)
                return new_lisp_root
            return new_lisp

    def make_calls_exprs(self, lisp_root):
        """Wrap function calls with 'Expr' nodes in case they are outer level statements."""
        if isinstance(lisp_root, str):
            return lisp_root
        elif isinstance(lisp_root, list):
            # recursion
            final_list = []
            for node in lisp_root:
                final_list.append(
                    self.make_calls_exprs(node)
                )
            if lisp_root[0]==Py2Lisp.statement_keyword\
                and (isinstance(lisp_root[1], list) or isinstance(lisp_root[1], AbstractionCall)) \
                and lisp_root[1][0]=='Call':
                # an unwrapped call node.

                call_node = lisp_root[1]
                abstraction_name = call_node[1]
                matches = self.get_matching_abstraction(abstraction_name)
                new_nodes = None
                if len(matches) > 0 and matches[0].returned_vars:
                    if len(matches[0].returned_vars)==1:
                        new_nodes= ['Assign', ['__list__', *matches[0].returned_vars], call_node]
                    else:
                        new_nodes = ['Assign',
                                     ['__list__', ['Tuple', ['__list__', *matches[0].returned_vars]]],
                                     call_node
                                     ]
                else:
                    # '(ProgramStatements (Assign (__list__ x) (Call fn_0)))'
                    new_nodes = ['Expr', call_node]
                final_list[1] = new_nodes
            # wrap here.
            return final_list

        return lisp_root

    def get_matching_abstraction(self, abstraction_name: str) -> list[StitchAbstraction]:
        return list(filter(lambda x: x.abstraction_name == abstraction_name, self.available_abstractions))

    def add_library_import_statements(self, py_ast):
        import_statements = []
        for abstraction_name in sorted(list(self.abstractions_used)):
            import_statements.append(ast.parse(
                f"from {self.library_name} import {abstraction_name}"
            ).body[0]
                                     )

        py_ast.body = import_statements + py_ast.body
        return py_ast

if __name__ == '__main__':
    print(Rewrite2Py(sys.argv[1], available_abstractions=[]).convert())
