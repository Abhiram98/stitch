import ast
from typing import Any

import pybrary_extraction.lisp2py.StitchAbstraction as stitch_abstraction
import pybrary_extraction.python2lisp as py2lisp

class KickOutTrailingParam(ast.NodeVisitor):

    def __init__(self, available_abstractions: list[stitch_abstraction.StitchAbstraction]):
        self.available_abstractions = available_abstractions

    def get_matching_abstraction(self, abstraction_name: str) -> list[stitch_abstraction.StitchAbstraction]:
        return list(filter(lambda x: x.abstraction_name == abstraction_name, self.available_abstractions))

    def visit_Call(self, node: ast.Call) -> Any:
        self.generic_visit(node)
        if isinstance(node.func, ast.Name):
            matches = self.get_matching_abstraction(node.func.id)
            if len(matches) and matches[0].get_trailing_statement_params():
                assert len(matches[0].get_trailing_statement_params()) == 1
                trailing_param = matches[0].get_trailing_statement_params()[0]
                if trailing_param.position < len(node.args):
                    trailing_statements = node.args.pop(trailing_param.position)
                    if trailing_statements!=py2lisp.Py2Lisp.empty_statement_keyword:
                        assert hasattr(node, 'parent_scope')
                        if not isinstance(trailing_statements, list):
                            trailing_statements = [trailing_statements]
                        node.parent_scope.body += trailing_statements

    def generic_visit(self, node):
        """Called if no explicit visitor function exists for a node."""
        for field, value in ast.iter_fields(node):
            if isinstance(value, list):
                for item in value:
                    if isinstance(item, ast.AST):
                        self.visit(item)
                    elif isinstance(item, list):
                        self.generic_visit_list(item) # so that recursive lists are visited.
            elif isinstance(value, ast.AST):
                self.visit(value)

    def generic_visit_list(self, item):
        for i in item:
            self.visit(i)
