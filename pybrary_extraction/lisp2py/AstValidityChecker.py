import ast
from typing import Any

import pybrary_extraction.python2lisp as p2l


class InvalidStatement(Exception):
    pass

class InvalidHole(Exception):
    pass


class AstValidityChecker(ast.NodeVisitor):
    def __init__(self, param_names):
        self.param_names = param_names
        self.trailing_statement_params = set()

    def check_list(self, body_list):
        for ele in body_list:
            if (isinstance(ele, ast.Name) and
                    (ele.id in self.param_names or ele.id in p2l.Py2Lisp.empty_statement_keyword)):
                raise InvalidStatement(ele.id)

    def visit_Module(self, node: ast.Module) -> Any:
        self.generic_visit(node)
        # exempt the last node to allow statements in the middle of blocks to be extracted
        self.check_list(node.body[:-1])
        last_stmnt = node.body[-1]
        try:
            self.check_list([last_stmnt])
        except InvalidStatement:
            assert isinstance(last_stmnt, ast.Name)
            self.trailing_statement_params.add(last_stmnt.id)
            # remove that from the abstraction body
            node.body = node.body[:-1]

    def visit_If(self, node: ast.If) -> Any:
        self.generic_visit(node)
        self.check_list(node.body)
        self.check_list(node.orelse)

    def visit_ClassDef(self, node: ast.ClassDef) -> Any:
        self.generic_visit(node)
        self.check_list(node.body)

    def visit_FunctionDef(self, node: ast.FunctionDef) -> Any:
        self.generic_visit(node)
        self.check_list(node.body)
        if isinstance(node.args, ast.Name) and node.args.id in self.param_names:
            raise InvalidHole(f"{node.args.id} is an invalid hole.")


    def visit_For(self, node: ast.For) -> Any:
        self.generic_visit(node)
        self.check_list(node.body)
        self.check_list(node.orelse)

    def visit_While(self, node: ast.While) -> Any:
        self.generic_visit(node)
        self.check_list(node.body)
        self.check_list(node.orelse)