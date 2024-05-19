import copy
import json
import ast
from pyparsing import OneOrMore, nestedExpr
import sys

from pybrary_extraction.python2lisp import Py2Lisp


class MyList(list):
    def __init__(self, *args):
        super().__init__(args)


def has_return_stmnt(py_ast):
    for node in ast.walk(py_ast):
        if isinstance(node, ast.Return):
            return True
    return False



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




class Abstraction2Py:

    def __init__(self, abtraction):
        self.abstraction = abtraction
        self.param_count = 0
        self.args_map = {}

    def convert(self, fn_name='fn_0'):
        py_ast = Lisp2Py(self.abstraction).get_py_ast()
        py_ast.type_ignores = []
        ast.fix_missing_locations(py_ast)
        self.set_param_names(py_ast)
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

    def add_return_value(self, py_ast):
        # TODO: this is a naive implementation.
        #  A better implementation involves some sort of liveness analysis,
        #  to determine what the target variables are.
        if has_return_stmnt(py_ast):
            return py_ast
        else:
            last_stmnt = ast.Return(value=copy.deepcopy(py_ast.body[-1]))
            py_ast.body.pop() # remove last statement
            py_ast.body.append(last_stmnt)
            # Return the last statement


class Rewrite2Py:
    '''
    Convert stitch rewritten code to python.
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
