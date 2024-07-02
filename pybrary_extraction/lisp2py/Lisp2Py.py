import ast

from pyparsing import OneOrMore, nestedExpr

from pybrary_extraction.lisp2py.utils import MyList, MyKeyword, StatementList
from pybrary_extraction.python2lisp import Py2Lisp
from pybrary_extraction.ast_utils import get_all_ast_classes, StringReplacer
from pybrary_extraction.lisp2py.FixAstNodes import FixAstNodes


class Lisp2Py:
    def __init__(self, lisp_str, string_hashmap=None):
        if string_hashmap is None:
            string_hashmap = {}
        self.lisp_str = lisp_str
        self.string_hashmap = string_hashmap

    def convert(self):
        py_ast = self.get_py_ast()
        py_ast = StringReplacer(string_hashmap=self.string_hashmap).visit(py_ast)
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

            py_ast_node = Lisp2Py.construct_ast_node(child_list)
            return FixAstNodes.augment_pyast_node(py_ast_node)

    @staticmethod
    def get_ast_node_from_string(lisp_root: str):
        try:
            val = eval(lisp_root, {})
            if type(val) in [int, float]:
                return ast.Constant(value=val)
            # elif val is None:
            #     return None
            else:
                return ast.Name(id=lisp_root)
        except:
            if lisp_root in get_all_ast_classes():
                ast_class = getattr(ast, lisp_root, None)
                if ast_class is None:
                    return ast.Name(id=lisp_root)
                return Lisp2Py.create_ast_node(ast_class)
            elif lisp_root == Py2Lisp.keyword_for_keyword:
                return MyKeyword(None, None)
            elif lisp_root == Py2Lisp.statement_keyword:
                return StatementList(
                    Py2Lisp.empty_statement_keyword, Py2Lisp.empty_statement_keyword)
            elif lisp_root == Py2Lisp.empty_statement_keyword:
                return Py2Lisp.empty_statement_keyword
            return ast.Name(id=lisp_root)

    @staticmethod
    def construct_ast_node(child_list):
        if isinstance(child_list[0], ast.Module):
            return ast.Module(body=child_list[1])
        if all([isinstance(i, MyKeyword) for i in child_list[1:]]):
            kw_args = {i.kw: i.value for i in child_list[1:]}
            return child_list[0].__class__(**kw_args)
        py_ast_node = child_list[0].__class__(*child_list[1:])
        return py_ast_node

    @staticmethod
    def wrap_module(lisp_parts):
        if lisp_parts[0] != Py2Lisp.module_keyword:
            new_lisp_parts = [Py2Lisp.module_keyword, lisp_parts]
            return new_lisp_parts
        return lisp_parts

    @classmethod
    def create_ast_node(cls, ast_class):
        if ast_class is ast.arguments:
            return ast.arguments(posonlyargs=[], args=[], defaults=[], kwonlyargs=[])
        if ast_class is ast.List:
            return ast.List(elts=[])
        if ast_class is ast.Dict:
            return ast.Dict(keys=[], values=[])
        return ast_class()
