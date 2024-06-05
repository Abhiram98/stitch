import ast


class MyList(list):
    def __init__(self, *args):
        super().__init__(args)


def has_return_stmnt(py_ast):
    for node in ast.walk(py_ast):
        if isinstance(node, ast.Return):
            return True
    return False
