import ast
import copy
import sys

from pybrary_extraction.lisp2py.Lisp2Py import Lisp2Py
from pybrary_extraction.python2lisp import Py2Lisp


class Rewrite2Py:
    '''
    Convert stitch rewritten code_str to python.
    '''

    def __init__(self, lisp_str, abstraction_prefix='fn_'):

        self.lisp_str = lisp_str
        self.abstraction_prefix = abstraction_prefix

    def convert(self):

        lisp_parts = Lisp2Py.parse_lisp(self.lisp_str)
        lisp_parts = Lisp2Py.wrap_module(lisp_parts)
        lisp_parts = self.replace_abstraction_calls(lisp_parts)
        lisp_parts = Rewrite2Py.make_calls_exprs(lisp_parts)
        self.check_for_list_param(lisp_parts)
        py_ast = Lisp2Py.construct(lisp_parts)
        py_ast.type_ignores = []
        ast.fix_missing_locations(py_ast)
        print(ast.dump(py_ast, indent=4))
        return ast.unparse(py_ast)

    def check_for_list_param(self, lisp_parts):
        if len(lisp_parts) > 1 and \
                isinstance(lisp_parts[1], list) and \
                len(lisp_parts[1]) and \
                lisp_parts[1][0] == Py2Lisp.list_keyword:
            raise Exception(f"Shouldn't be {Py2Lisp.list_keyword} here.")

    def replace_abstraction_calls(self, lisp_root):
        if isinstance(lisp_root, str):
            return lisp_root
        elif isinstance(lisp_root, list):
            for node in lisp_root:
                self.replace_abstraction_calls(node)

            if lisp_root[0].startswith(self.abstraction_prefix):
                fn_name = lisp_root[0]
                args = copy.deepcopy(lisp_root[1:])
                # new_lisp_root = ['Call', lisp_root[0], ['__list__', *lisp_root[1:]]]
                lisp_root.insert(0, 'Call')
                lisp_root.insert(2, ['__list__', *args])
                del lisp_root[3:]
            return lisp_root

    @staticmethod
    def make_calls_exprs(lisp_parts):
        final_nodes = [lisp_parts[0]]
        for node in lisp_parts[1:]:
            if node[0] == 'Call':
                final_nodes.append(['Expr', node])
            else:
                final_nodes.append(node)
        return final_nodes



if __name__ == '__main__':
    print(Rewrite2Py(sys.argv[1]).convert())