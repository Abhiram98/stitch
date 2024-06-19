import ast
from typing import Union, Any

from pybrary_extraction.ast_utils import FindReadVariables, line_col


class AddScopeLinks(ast.NodeVisitor):
    def __init__(self):
        self.parent_scope = None

    def visit_FunctionDef(self, node: ast.FunctionDef) -> Any:
        self.parent_scope = node
        self.generic_visit(node)

    def visit_Module(self, node: ast.Module) -> Any:
        self.parent_scope = node
        self.generic_visit(node)

    def visit_ClassDef(self, node: ast.ClassDef) -> Any:
        self.parent_scope = node
        self.generic_visit(node)

    def visit(self, node):
        """Visit a node."""
        method = 'visit_' + node.__class__.__name__
        visitor = getattr(self, method, self.generic_visit)
        node.parent_scope = self.parent_scope
        return visitor(node)


class FindNodesWithinIndices(ast.NodeVisitor):
    def __init__(self, start_line, start_col, end_line, end_col):

        self.start_line = start_line
        self.start_col = start_col
        self.end_line = end_line
        self.end_col = end_col
        self.nodes_within_indices = []

    def visit(self, node):
        """Visit a node."""
        method = 'visit_' + node.__class__.__name__
        visitor = getattr(self, method, self.generic_visit)

        if hasattr(node, 'end_col_offset') and hasattr(node, 'col_offset'):
            if node.lineno >= self.start_line and node.end_lineno <= self.end_line:
                self.nodes_within_indices.append(node)

        return visitor(node)


class ExtractedFragment:
    def __init__(self, parent_scope: Union[ast.FunctionDef, ast.Module],
                 start_line, end_line):
        self.parent_scope = parent_scope

        self.start_line = start_line
        self.end_line = end_line
        self.read_vars_visitor = FindReadVariables()

    def find_used_vars_later(self):
        for node in self.parent_scope.body:
            if node.lineno > self.end_line:
                self.read_vars_visitor.visit(node)
        return set(self.read_vars_visitor.rhs_vars)

    @staticmethod
    def create_from(full_code, extracted_part, start_index):
        end_index = start_index + len(extracted_part)
        start_line, start_col = line_col(full_code, start_index)
        end_line, end_col = line_col(full_code, end_index)

        code_ast = ast.parse(full_code)
        AddScopeLinks().visit(code_ast)
        node_finder = FindNodesWithinIndices(
            start_line, start_col,
            end_line, end_col)
        node_finder.visit(code_ast)
        biggest_node = max(node_finder.nodes_within_indices, key=lambda x: x.end_lineno - x.lineno)
        parent_scope = biggest_node.parent_scope

        return ExtractedFragment(parent_scope, start_line, end_line)

