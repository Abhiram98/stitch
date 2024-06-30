import ast
from typing import Union, Any


class FindFuncAndClassDefs(ast.NodeVisitor):
    def __init__(self):
        self.defs = []
        self.is_lhs = False

    def visit_ClassDef(self, node: ast.ClassDef) -> Any:
        self.defs.append(node.name)
        self.generic_visit(node)

    def visit_FunctionDef(self, node: ast.FunctionDef) -> Any:
        self.defs.append(node.name)
        self.generic_visit(node)


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


def line_col(string, index):
    """Returns a 2-tuple which translates string index 'index' into
       line and column counts. 'index' is a normal Python 0-based index;
       line and column are 1-based. So line_col(string, 0) will return (1, 1).
       The newline character is considered to be the last character of a
       line.
       The function does not check whether 'index' is in range; if index greater
       than or equal to the length of 'string', the result will be as though
       'string' had (index + 1 - len(string)) extra characters (none of which are
       newlines) appended to the end
    """
    return string.count('\n', 0, index) + 1, index - string.rfind('\n', 0, index) - 1


class StringReplacer(ast.NodeTransformer):
    def __init__(self, string_hashmap):
        self.string_hashmap = string_hashmap

    def visit_Name(self, node: ast.Name) -> Any:
        if node.id in self.string_hashmap:
            return ast.Constant(value=self.string_hashmap[node.id])
        return node
