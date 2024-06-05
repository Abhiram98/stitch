import ast

from pyparsing import OneOrMore, nestedExpr

from pybrary_extraction.lisp2py.utils import MyList
from pybrary_extraction.python2lisp import Py2Lisp


class Lisp2Py:
    def __init__(self, lisp_str):
        self.lisp_str = lisp_str

    def convert(self):
        py_ast = self.get_py_ast()
        py_ast.type_ignores = []
        ast.fix_missing_locations(py_ast)
        print(ast.dump(py_ast, indent=4))
        return ast.unparse(py_ast)

    def get_py_ast(self):
        print(self.lisp_str)
        lisp_parts = Lisp2Py.parse_lisp(self.lisp_str)

        # construct python ast
        return Lisp2Py.construct(lisp_parts)

    @staticmethod
    def parse_lisp(lisp_str):
        if lisp_str == Py2Lisp.module_keyword:
            return [Py2Lisp.module_keyword]
        else:
            lisp_parts = OneOrMore(nestedExpr()).parseString(lisp_str).as_list()[0]
            return lisp_parts

    @staticmethod
    def augment_pyast_node(node):
        if isinstance(node, ast.If) and getattr(node, 'orelse', None) is None:
            node.orelse = []
        elif isinstance(node, ast.Call):
            if getattr(node, 'args', None) is None:
                node.args = []
            if getattr(node, 'keywords', None) is None:
                node.keywords = []
        elif isinstance(node, ast.FunctionDef):
            if isinstance(node.name, ast.Name):
                node.name = node.name.id
        elif isinstance(node, ast.arguments):
            if getattr(node, 'args', None) is None:
                node.args = node.posonlyargs
                node.posonlyargs = []
            if getattr(node, 'defaults', None) is None:
                node.defaults = []
            if getattr(node, 'kwonlyargs', None) is None:
                node.kwonlyargs = []
        elif isinstance(node, ast.arg):
            if isinstance(node.arg, ast.Name):
                node.arg = node.arg.id

        elif isinstance(node, ast.alias):
            if isinstance(node.name, ast.Name):
                node.name = node.name.id
        return node

    @staticmethod
    def construct(lisp_root):
        if lisp_root == '__list__':
            return MyList()
        elif lisp_root == Py2Lisp.module_keyword:
            return ast.Module(body=[])
        elif isinstance(lisp_root, str):
            return Lisp2Py.get_ast_node_from_string(lisp_root)
        else:
            child_list = []
            for c in lisp_root:
                c_node = Lisp2Py.construct(c)
                child_list.append(c_node)

            # if type(lisp_root)==list:
            #     return child_list
            # else:
            # ast_class = getattr(ast, child_list[0])
            py_ast_node = Lisp2Py.construct_ast_node(child_list)
            return Lisp2Py.augment_pyast_node(py_ast_node)

            # root_constructed = Lisp2Py.construct(lisp_root[0])
            # if isinstance(root_constructed, str):
            #     ast_class = getattr(ast, root_constructed)
            #     return ast_class(*child_list)
            # else:
            #     return root_constructed

    @staticmethod
    def get_ast_node_from_string(lisp_root: str):
        try:
            val = eval(lisp_root)
            if type(val) in [int, float]:
                return ast.Constant(value=val)
            else:
                return ast.Name(id=lisp_root)
        except:
            ast_class = getattr(ast, lisp_root, None)
            if ast_class is None:
                return ast.Name(id=lisp_root)
            else:
                return ast_class()

    @staticmethod
    def construct_ast_node(child_list):
        if isinstance(child_list[0], ast.Module):
            return ast.Module(body=child_list[1:])
        py_ast_node = child_list[0].__class__(*child_list[1:])
        return py_ast_node

    @staticmethod
    def wrap_module(lisp_parts):
        if lisp_parts[0] != Py2Lisp.module_keyword:
            new_lisp_parts = [Py2Lisp.module_keyword, lisp_parts]
            return new_lisp_parts
        return lisp_parts
