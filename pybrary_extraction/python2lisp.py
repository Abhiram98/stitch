import ast
from typing import Any
import os
import sys


class Py2Lisp(ast.NodeVisitor):
    list_keyword = "__list__"
    module_keyword = 'ProgramStatements'
    statement_keyword = 'StatementList'
    empty_statement_keyword = 'EMPTY_Statement'
    empty_vararg_keyword = 'EMPTY_vararg'
    empty_kwarg_keyword = 'EMPTY_kwarg'
    keyword_for_keyword = "__kw__"

    def __init__(self, string_hash_map=None,
                 mangle_names=False):
        super().__init__()
        self.string_count = 0
        if string_hash_map is None:
            self.string_hash_map = {}
        else:
            self.string_hash_map = string_hash_map
            self.string_count += len(string_hash_map)
        self.mangle_names = mangle_names

    @staticmethod
    def fromDirectoryToJson(
            directory_path, mangle_names=False):
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
            p2lisp = Py2Lisp(string_hash_map=string_hash_map, mangle_names=mangle_names)
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

    @staticmethod
    def generated_constructed_list(program_elements):
        if len(program_elements) == 0:
            return f"({Py2Lisp.statement_keyword} {Py2Lisp.empty_statement_keyword} {Py2Lisp.empty_statement_keyword})"
        lisp_str = Py2Lisp.empty_statement_keyword
        for ele in program_elements[::-1]:
            lisp_str = f"({Py2Lisp.statement_keyword} {ele} {lisp_str})"
        return lisp_str

    def visit_and_get_lisp_str(self, node,
                               force_encode_args=None,
                               encode_as_kw=False,
                               encode_fields_as_constructed_list=None):
        if force_encode_args is None:
            force_encode_args = []
        if encode_fields_as_constructed_list is None:
            encode_fields_as_constructed_list = []
        params = []
        encoded_field_names = []
        for field, value in ast.iter_fields(node):
            if isinstance(value, list):
                list_params = []
                for item in value:
                    if isinstance(item, ast.AST):
                        val = self.visit(item)
                        if val is not None:
                            list_params.append(val)
                if field in force_encode_args or list_params:
                    if field in encode_fields_as_constructed_list:
                        params.append(
                            Py2Lisp.generated_constructed_list(list_params))
                    else:
                        params.append(f"({Py2Lisp.list_keyword} " + " ".join(list_params) + ")")
                    encoded_field_names.append(field)

            elif isinstance(value, ast.AST):
                val = self.visit(value)
                if val is not None:
                    params.append(val)
                    encoded_field_names.append(field)
            elif value is not None:
                params.append(str(value))
                encoded_field_names.append(field)

        if encode_as_kw:
            params_str = " ".join(
                [f"({Py2Lisp.keyword_for_keyword} {fn} {p})" for fn, p in zip(encoded_field_names, params)])
        else:
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
        module_in_lisp = Py2Lisp.generated_constructed_list(params)
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
        if self.mangle_names:
            return f"_{str(node.id)}"  # name mangling
        return str(node.id)

    def visit_FunctionDef(self, node: ast.FunctionDef) -> Any:
        return self.visit_and_get_lisp_str(
            node, encode_as_kw=True,
            encode_fields_as_constructed_list=['body']
        )

    def visit_ClassDef(self, node: ast.ClassDef) -> Any:
        return self.visit_and_get_lisp_str(
            node,
            encode_as_kw=True,
            encode_fields_as_constructed_list=['body']
        )

    def visit_arguments(self, node: ast.arguments) -> Any:
        # if node.vararg is None:
        #     node.vararg = Py2Lisp.empty_vararg_keyword
        # if node.kwarg is None:
        #     node.kwarg = Py2Lisp.empty_kwarg_keyword

        return self.visit_and_get_lisp_str(node,
                                           encode_as_kw=True
                                           # force_encode_args=['posonlyargs', 'args', 'vararg',
                                           #                    'kwonlyargs', 'kw_defaults', 'kwarg',
                                           #                    'defaults']
                                           )

    def visit_comprehension(self, node: ast.comprehension) -> Any:
        return self.visit_and_get_lisp_str(
            node, force_encode_args=['ifs']
        )

    def visit_Assign(self, node: ast.Assign) -> Any:
        return self.visit_and_get_lisp_str(node, force_encode_args=['targets', 'value'])

    def visit_AnnAssign(self, node: ast.AnnAssign) -> Any:
        return self.visit_and_get_lisp_str(node,
                                           encode_as_kw=True,
                                           # force_encode_args=['target', 'annotation', 'value', 'simple']
                                           )

    def visit_ExceptHandler(self, node: ast.ExceptHandler) -> Any:
        return self.visit_and_get_lisp_str(node, encode_as_kw=True)

    def visit_For(self, node: ast.For) -> Any:
        return self.visit_and_get_lisp_str(node,
                                           encode_fields_as_constructed_list=['body', 'orelse'])

    def visit_While(self, node: ast.While) -> Any:
        return self.visit_and_get_lisp_str(node,
                                           encode_fields_as_constructed_list=['body', 'orelse'])

    def visit_If(self, node: ast.If) -> Any:
        return self.visit_and_get_lisp_str(node,
                                           encode_fields_as_constructed_list=['body', 'orelse'])


if __name__ == '__main__':
    # print(f"{sys.argv=}")
    print(Py2Lisp.fromFilePath(sys.argv[1]))
