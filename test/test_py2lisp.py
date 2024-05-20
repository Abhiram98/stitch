from pybrary_extraction.python2lisp import Py2Lisp
import ast
import json


def test_example_1():
    with open("resources/ex1.py") as f:
        code_str = f.read()

    code_ast = ast.parse(code_str)
    lisp_str = Py2Lisp().visit(code_ast)
    print(lisp_str)
    assert lisp_str == "(ProgramStatements (Assign (__list__ x) 1) (Assign (__list__ y) 1) (Assign (__list__ z) (" \
                       "BinOp x Add y)) (If (Compare x (__list__ Lt) (__list__ 0)) (__list__ (Expr (Call print (" \
                       "__list__ x)))) (__list__ (Expr (Call print (__list__ y))))) (Expr (Call print (__list__ z))))"


def test_example_2():
    code_str = "x=5\nprint(x)"
    code_ast = ast.parse(code_str)
    lisp_str = Py2Lisp().visit(code_ast)
    print(lisp_str)
    assert lisp_str == "(ProgramStatements (Assign (__list__ x) 5) (Expr (Call print (__list__ x))))"

def test_example_3():
    code_str = "x=1\ny=1\nz=x+y\nprint(z)"
    code_ast = ast.parse(code_str)
    lisp_str = Py2Lisp().visit(code_ast)
    print(lisp_str)
    assert lisp_str == "(ProgramStatements (Assign (__list__ x) 1) (Assign (__list__ y) 1) (Assign (__list__ z) (BinOp x Add y)) (Expr (Call print (__list__ z))))"


def test_from_directory_image_processing():
    lisp_outs = Py2Lisp.fromDirectoryToJson("../Python/digital_image_processing")

    print(json.dumps(list(lisp_outs.values()), indent=4))


def test_from_directory_computer_vision():
    lisp_outs = Py2Lisp.fromDirectoryToJson("../Python/greedy_methods")

    print(json.dumps(list(lisp_outs.values()), indent=4))


def test_from_directory_arrays():
    lisp_outs = Py2Lisp.fromDirectoryToJson('../Python/data_structures/arrays')

    print(json.dumps(list(lisp_outs.values()), indent=4))


def test_from_directory_p0():
    lisp_outs = Py2Lisp.fromDirectoryToJson('../lab4-team-tyler-and-luke-1/tests/autograde/p0')

    print(json.dumps(list(lisp_outs.values()), indent=4))


def test_unary_op():
    code_ast = ast.parse("x=-1")
    lisp_str = Py2Lisp().visit(code_ast)

    assert lisp_str == "(ProgramStatements (Assign (__list__ x) (UnaryOp USub 1)))"


def test_assigns():
    code_ast = ast.parse("left_sum = 0\nright_sum = 1")
    lisp_str = Py2Lisp().visit(code_ast)

    assert lisp_str == '(ProgramStatements (Assign (__list__ left_sum) 0) (Assign (__list__ right_sum) 1))'


def test_empty():
    code_ast = ast.parse("")
    lisp_str = Py2Lisp().visit(code_ast)

    assert lisp_str == '(ProgramStatements )'


def test_annotated_func():
    code_ast = ast.parse("def find_median_sorted_arrays(nums1: list[int], nums2: list[int]) -> float:\n  print(1)")
    lisp_str = Py2Lisp().visit(code_ast)

    assert lisp_str == '(ProgramStatements (FunctionDef find_median_sorted_arrays (arguments (__list__ (arg nums1 (Subscript list int)) (arg nums2 (Subscript list int)))) (__list__ (Expr (Call print (__list__ 1)))) (__list__ ) float))'
