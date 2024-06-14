import ast
from typing import Union, Any

class FindTargetVariables(ast.NodeVisitor):
    def __init__(self, include_func_calls=False):
        self.lhs_vars = []
        self.is_lhs = False
        self.INCLUDE_FUNC_CALLS = include_func_calls

    def visit_Assign(self, node: ast.Assign) -> Any:
        for target_node in node.targets:
            self.is_lhs = True
            self.visit(target_node)
        self.is_lhs = False
        self.visit(node.value)

    def visit_AnnAssign(self, node: ast.AnnAssign) -> Any:
        self.is_lhs = True
        self.visit(node.target)

        self.is_lhs = False
        self.visit(node.value)

    def visit_AugAssign(self, node: ast.AugAssign) -> Any:
        self.is_lhs = True
        self.visit(node.target)

        self.is_lhs = False
        self.visit(node.value)


    def visit_Name(self, node: ast.Name) -> Any:
        self.generic_visit(node)
        if self.is_lhs:
            self.lhs_vars.append(node.id)

    def visit_FunctionDef(self, node: ast.FunctionDef) -> Any:
        self.generic_visit(node)
        self.lhs_vars.append(node.name)

    def visit_ClassDef(self, node: ast.ClassDef) -> Any:
        self.generic_visit(node)
        self.lhs_vars.append(node.name)

    # TODO: these cases maybe needed to deal with
    #  method calls and attribute calls
    def visit_Call(self, node: ast.Call) -> Any:
        # if not self.INCLUDE_FUNC_CALLS:
        self.generic_visit(node)
        # else:
        #     self.is_lhs = True
        #     for arg in node.args:
        #         self.visit(arg)


    def visit_Attribute(self, node: ast.Attribute) -> Any:
        self.generic_visit(node)
        pass


class FindReadVariables(ast.NodeVisitor):
    def __init__(self):
        self.rhs_vars = []
        self.is_rhs = True

    def visit_Assign(self, node: ast.Assign) -> Any:
        self.is_rhs = True
        self.visit(node.value)

    def visit_AnnAssign(self, node: ast.AnnAssign) -> Any:
        self.is_rhs = True
        self.visit(node.value)

    def visit_AugAssign(self, node: ast.AugAssign) -> Any:
        self.is_rhs = True
        self.visit(node.target)
        self.visit(node.value)

    def visit_Name(self, node: ast.Name) -> Any:
        self.generic_visit(node)
        if self.is_rhs:
            self.rhs_vars.append(node.id)



def get_all_ast_classes():
    invalid = ['main', 'parse', 'unparse']
    return [i for i in dir(ast) if i not in invalid and not i.startswith("_")]