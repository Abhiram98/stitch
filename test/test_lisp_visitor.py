from pybrary_extraction.ast_utils import LispVisitor


def test_visit_functiondef():
    class MyVisitor(LispVisitor):
        def visit_FunctionDef(self, lisp_root):
            print("Inside functiondef")

    lisp_root = ['f1', ['FunctionDef', 'param1', 'param2']]
    MyVisitor().visit(lisp_root)


def test_replacing_visitor():
    class ReplacingVisitor(LispVisitor):
        def visit_FunctionDef(self, lisp_root):
            print("Inside functiondef")
            new_root = self.generic_visit(lisp_root)
            new_root[0] = 'NewFunctionDef'
            return new_root

    lisp_root = ['f1', ['FunctionDef', 'param1', 'param2']]
    new_lisp_root = ReplacingVisitor().visit(lisp_root)
    print(lisp_root)
    print(new_lisp_root)
    assert new_lisp_root[1][0] == 'NewFunctionDef'
    assert lisp_root[1][0] == 'FunctionDef'
