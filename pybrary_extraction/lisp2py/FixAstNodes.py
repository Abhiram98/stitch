import ast
from typing import Any

from pybrary_extraction import Py2Lisp
import pybrary_extraction.lisp2py.utils as utils


class FixAstNodes(ast.NodeVisitor):

    def generic_visit(self, node):
        return node  # do nothing to prevent recursion.

    def visit_If(self, node: ast.If) -> Any:
        if getattr(node, 'orelse', None) is None:
            node.orelse = []
        return node

    def visit_Call(self, node: ast.Call) -> Any:
        if getattr(node, 'args', None) is None:
            node.args = []
        if getattr(node, 'keywords', None) is None:
            node.keywords = []
        return node

    def visit_FunctionDef(self, node: ast.FunctionDef) -> Any:
        if isinstance(node.name, ast.Name):
            node.name = node.name.id
        if not hasattr(node, 'decorator_list'):
            node.decorator_list = []
        return node

    def visit_arguments(self, node: ast.arguments) -> Any:
        if isinstance(node.kwarg, ast.Name) and node.kwarg.id == Py2Lisp.empty_kwarg_keyword:
            node.kwarg = None
        if isinstance(node.vararg, ast.Name) and node.vararg.id == Py2Lisp.empty_vararg_keyword:
            node.vararg = None

        FixAstNodes.make_none_fields_if_not_exists(
            node,
            'kwarg', 'vararg'
        )
        FixAstNodes.make_empty_list_fields_if_not_exists(
            node,
            'posonlyargs', 'args', 'kwonlyargs', 'kw_defaults', 'defaults', )
        return node

    def visit_arg(self, node: ast.arg) -> Any:
        if isinstance(node.arg, ast.Name):
            node.arg = node.arg.id
        return node

    def visit_Attribute(self, node: ast.Attribute) -> Any:
        if isinstance(node.attr, ast.Name):
            node.attr = node.attr.id
        return node

    def visit_alias(self, node: ast.alias) -> Any:
        if isinstance(node.name, ast.Name):
            node.name = node.name.id
        if isinstance(node.name, ast.operator):
            node.name = 'operator' #fixes bug where `import operator as op` is used.
        if isinstance(node.asname, ast.Name):
            node.asname = node.asname.id
        return node

    def visit_While(self, node: ast.While) -> Any:
        if not hasattr(node, 'orelse'):
            node.orelse = []
        return node

    def visit_For(self, node: ast.For) -> Any:
        if not hasattr(node, 'orelse'):
            node.orelse = []
        return node

    def visit_List(self, node: ast.List) -> Any:
        if not hasattr(node, 'elts'):
            node.elts = []
        return node

    def visit_Dict(self, node: ast.Dict) -> Any:
        if not hasattr(node, 'keys'):
            node.keys = []
        if not hasattr(node, 'values'):
            node.values = []
        return node

    def visit_comprehension(self, node: ast.comprehension) -> Any:
        if not hasattr(node, 'is_async'):
            node.is_async = 0
        return node

    def visit_ImportFrom(self, node: ast.ImportFrom) -> Any:
        if isinstance(getattr(node, 'level'), ast.Constant):
            node.level = node.level.value
        if isinstance(getattr(node, 'module'), ast.Name):
            node.module = node.module.id
        return node

    def visit_FormattedValue(self, node: ast.FormattedValue) -> Any:
        if isinstance(node.conversion, ast.Constant):
            node.conversion = node.conversion.value
        return node

    def visit_ClassDef(self, node: ast.ClassDef) -> Any:
        FixAstNodes.make_empty_list_fields_if_not_exists(
            node,
            'bases','keywords', 'decorator_list')
        if hasattr(node, 'name') and isinstance(node.name, ast.Name):
            node.name = node.name.id
        return node

    def visit_AnnAssign(self, node: ast.AnnAssign) -> Any:
        if not hasattr(node, 'simple'):
            node.simple = node.value
            node.value = None
        return node

    def visit_keyword(self, node: ast.keyword) -> Any:
        if isinstance(node.arg, ast.Name):
            node.arg = node.arg.id
        return node

    def visit_ExceptHandler(self, node: ast.ExceptHandler) -> Any:
        if hasattr(node, 'name') \
            and isinstance(node.name, ast.Name) and node.name.id == Py2Lisp.empty_exception_keyword:
            node.name = None
        return node

    def visit_Try(self, node: ast.Try) -> Any:
        FixAstNodes.make_empty_list_fields_if_not_exists(
            node, 'body', 'handlers', 'orelse', 'finalbody')
        return node


    def visit_StatementList(self, node: utils.StatementList):
        flattened_statements = node.decode()
        return list(
            filter(lambda x: x is not Py2Lisp.empty_statement_keyword, flattened_statements))


    @staticmethod
    def augment_pyast_node(node):
        new_node = FixAstNodes().visit(node)
        return new_node

    @staticmethod
    def make_empty_list_fields_if_not_exists(node, *field_names):
        for name in field_names:
            if not hasattr(node, name):
                setattr(node, name, [])

    @staticmethod
    def make_none_fields_if_not_exists(node, *field_names):
        for name in field_names:
            if not hasattr(node, name):
                setattr(node, name, None)
