import ast
from typing import Any
import os
import sys


class Py2Lisp(ast.NodeVisitor):
    list_keyword = "__list__"
    module_keyword = 'ProgramStatements'
    empty_vararg_keyword = 'EMPTY_vararg'
    empty_kwarg_keyword = 'EMPTY_kwarg'

    def __init__(self, string_hash_map=None):
        super().__init__()
        self.string_count = 0
        if string_hash_map is None:
            self.string_hash_map = {}
        else:
            self.string_hash_map = string_hash_map
            self.string_count += len(string_hash_map)

    @staticmethod
    def fromDirectoryToJson(directory_path):
        py_files = []
        for folder, subfolders, files in os.walk(directory_path):
            for file in files:
                if file.endswith('.py'):
                    py_files.append(os.path.join(folder, file))

        out_json = {}

        string_hash_map = {}
        for file in py_files:
            with open(file) as f:
                code_str = f.read()
            code_ast = ast.parse(code_str)
            p2lisp = Py2Lisp(string_hash_map=string_hash_map)
            lisp_str = p2lisp.visit(code_ast)
            out_json[file] = lisp_str

            print(f"{p2lisp.string_hash_map=}")

        return out_json, string_hash_map

    @staticmethod
    def fromFilePath(filePath):
        with open(filePath) as f:
            code_str = f.read()
        code_ast = ast.parse(code_str)
        lisp_str = Py2Lisp().visit(code_ast)
        return lisp_str

    def generic_visit(self, node: ast.AST) -> Any:
        return self.visit_and_get_lisp_str(node)

    def visit_and_get_lisp_str(self, node, force_encode_args=None):
        if force_encode_args is None:
            force_encode_args = []
        params = []
        for field, value in ast.iter_fields(node):
            if isinstance(value, list):
                list_params = []
                for item in value:
                    if isinstance(item, ast.AST):
                        val = self.visit(item)
                        if val is not None:
                            list_params.append(val)
                if field in force_encode_args or list_params:
                    params.append(f"({Py2Lisp.list_keyword} " + " ".join(list_params) + ")")

            elif isinstance(value, ast.AST):
                val = self.visit(value)
                if val is not None:
                    params.append(val)
            elif value is not None:
                params.append(str(value))
            # elif (value is None) and (field in force_encode_args):
            #     params.append("None")
        params_str = " ".join(params)
        if len(params):
            lisp_string = f"({node.__class__.__name__} {params_str})"
        else:
            lisp_string = node.__class__.__name__
        return lisp_string

    def visit_Module(self, node: ast.Module) -> Any:
        params = []
        for b in node.body:
            params.append(self.visit(b))
        module_in_lisp = f"{' '.join(params)}"
        lisp_str = f"(ProgramStatements {module_in_lisp})"
        return lisp_str

    def visit_Load(self, node: ast.Load) -> Any:
        return

    def visit_Store(self, node: ast.Store) -> Any:
        return

    def visit_Constant(self, node: ast.Constant) -> Any:
        if isinstance(node.value, str):
            if node.value not in self.string_hash_map:
                self.string_hash_map[node.value] = f"STRING_{self.string_count}"
                self.string_count += 1
            return self.string_hash_map[node.value]
        return str(node.value)

    def visit_Name(self, node: ast.Name) -> Any:
        return str(node.id)

    def visit_FunctionDef(self, node: ast.FunctionDef) -> Any:
        return self.visit_and_get_lisp_str(node, force_encode_args=[
            'name',
            'args',
            'body',
            'decorator_list',
            'returns',
            'type_comment',
        ])

    def visit_ClassDef(self, node: ast.ClassDef) -> Any:
        return self.visit_and_get_lisp_str(
            node,
            force_encode_args=[
                'name', 'bases', 'keywords', 'body', 'decorator_list'
            ]
        )

    def visit_arguments(self, node: ast.arguments) -> Any:
        if node.vararg is None:
            node.vararg = Py2Lisp.empty_vararg_keyword
        if node.kwarg is None:
            node.kwarg = Py2Lisp.empty_kwarg_keyword

        return self.visit_and_get_lisp_str(node,
                                           force_encode_args=['posonlyargs', 'args', 'vararg',
                                                              'kwonlyargs', 'kw_defaults', 'kwarg',
                                                              'defaults']
                                           )

    def visit_comprehension(self, node: ast.comprehension) -> Any:
        return self.visit_and_get_lisp_str(
            node, force_encode_args=['ifs']
        )

    def visit_Assign(self, node: ast.Assign) -> Any:
        return self.visit_and_get_lisp_str(node, force_encode_args=['targets', 'value'])

    def visit_AnnAssign(self, node: ast.AnnAssign) -> Any:
        return self.visit_and_get_lisp_str(node, force_encode_args=['target', 'annotation', 'value', 'simple'])


if __name__ == '__main__':
    # print(f"{sys.argv=}")
    print(Py2Lisp.fromFilePath(sys.argv[1]))
