from pybrary_extraction.python2lisp import Py2Lisp
import ast
import json
import pathlib

resources_path = pathlib.Path(__file__).parent.joinpath("resources")


def test_example_1():
    with open(resources_path.joinpath("ex1.py")) as f:
        code_str = f.read()

    code_ast = ast.parse(code_str)
    lisp_str = Py2Lisp().visit(code_ast)
    print(lisp_str)
    assert lisp_str == "(ProgramStatements (StatementList (Assign (__list__ x) 1) (StatementList (Assign (__list__ y) " \
                       "1) (StatementList (Assign (__list__ z) (BinOp x Add y)) (StatementList (If (Compare x (" \
                       "__list__ Lt) (__list__ 0)) (StatementList (Expr (Call print (__list__ x))) EMPTY_Statement) (" \
                       "StatementList (Expr (Call print (__list__ y))) EMPTY_Statement)) (StatementList (Expr (Call " \
                       "print (__list__ z))) EMPTY_Statement))))))"


def test_example_2():
    code_str = "x=5\nprint(x)"
    code_ast = ast.parse(code_str)
    lisp_str = Py2Lisp().visit(code_ast)
    print(lisp_str)
    assert lisp_str == "(ProgramStatements (StatementList (Assign (__list__ x) 5) (StatementList (Expr (Call print (" \
                       "__list__ x))) EMPTY_Statement)))"


def test_example_3():
    code_str = "x=1\ny=1\nz=x+y\nprint(z)"
    code_ast = ast.parse(code_str)
    lisp_str = Py2Lisp().visit(code_ast)
    print(lisp_str)
    assert lisp_str == "(ProgramStatements (StatementList (Assign (__list__ x) 1) (StatementList (Assign (__list__ y) " \
                       "1) (StatementList (Assign (__list__ z) (BinOp x Add y)) (StatementList (Expr (Call print (" \
                       "__list__ z))) EMPTY_Statement)))))"

def test_print_multiple():
    code_str = "print(x,y)"
    code_ast = ast.parse(code_str)
    lisp_str = Py2Lisp().visit(code_ast)
    print(lisp_str)
    assert lisp_str=="(ProgramStatements (StatementList (Expr (Call print (__list__ x y))) EMPTY_Statement))"


def test_from_directory_image_processing():
    lisp_outs, _ = Py2Lisp.fromDirectoryToJson("../Python/digital_image_processing")

    print(json.dumps(list(lisp_outs.values()), indent=4))


def test_from_directory_computer_vision():
    lisp_outs, _ = Py2Lisp.fromDirectoryToJson("../Python/greedy_methods")

    print(json.dumps(list(lisp_outs.values()), indent=4))


def test_from_directory_arrays():
    lisp_outs, _ = Py2Lisp.fromDirectoryToJson('../Python/data_structures/arrays')

    print(json.dumps(list(lisp_outs.values()), indent=4))


def test_from_directory_p0():
    lisp_outs, _ = Py2Lisp.fromDirectoryToJson('../lab4-team-tyler-and-luke-1/tests/autograde/p0')

    print(json.dumps(list(lisp_outs.values()), indent=4))


def test_unary_op():
    code_ast = ast.parse("x=-1")
    lisp_str = Py2Lisp().visit(code_ast)
    print(lisp_str)
    assert lisp_str == "(ProgramStatements (StatementList (Assign (__list__ x) (UnaryOp USub 1)) EMPTY_Statement))"


def test_assigns():
    code_ast = ast.parse("left_sum = 0\nright_sum = 1")
    lisp_str = Py2Lisp().visit(code_ast)

    assert lisp_str == "(ProgramStatements (StatementList (Assign (__list__ left_sum) 0) (StatementList (Assign (" \
                       "__list__ right_sum) 1) EMPTY_Statement)))"


def test_empty():
    code_ast = ast.parse("")
    lisp_str = Py2Lisp().visit(code_ast)
    print(lisp_str)
    assert lisp_str == '(ProgramStatements (StatementList EMPTY_Statement EMPTY_Statement))'


def test_simple_function():
    py_ast = ast.parse("""def main():
    print(STRING_0)""")
    lisp_str = Py2Lisp().visit(py_ast)
    print(lisp_str)
    assert lisp_str == '(ProgramStatements (StatementList (FunctionDef (__kw__ name main) (__kw__ args arguments) (' \
                       '__kw__ body (StatementList (Expr (Call print (__list__ STRING_0))) EMPTY_Statement))) ' \
                       'EMPTY_Statement))'

def test_function_two_liner():
    py_ast = ast.parse("""def main():
    print(STRING_0)
    print(STRING_1)""")
    lisp_str = Py2Lisp().visit(py_ast)
    print(lisp_str)
    assert lisp_str == "(ProgramStatements (StatementList (FunctionDef (__kw__ name main) (__kw__ args arguments) (" \
                       "__kw__ body (StatementList (Expr (Call print (__list__ STRING_0))) (StatementList (Expr (Call " \
                       "print (__list__ STRING_1))) EMPTY_Statement)))) EMPTY_Statement))"

def test_annotated_func():
    code_ast = ast.parse("def find_median_sorted_arrays(nums1: body_list[int], nums2: body_list[int]) -> float:\n  print(1)")
    lisp_str = Py2Lisp().visit(code_ast)
    print(lisp_str)
    assert lisp_str == "(ProgramStatements (StatementList (FunctionDef (__kw__ name find_median_sorted_arrays) (" \
                       "__kw__ args (arguments (__kw__ args (__list__ (arg nums1 (Subscript body_list int)) (arg nums2 (" \
                       "Subscript body_list int)))))) (__kw__ body (StatementList (Expr (Call print (__list__ 1))) " \
                       "EMPTY_Statement)) (__kw__ returns float)) EMPTY_Statement))"


def test_annotated_func_with_attr_usage():
    code_ast = ast.parse('def __bool__(self):\n    STRING_775\n    return self._root is not None')
    lisp_str = Py2Lisp().visit(code_ast)
    print(lisp_str)
    assert lisp_str == "(ProgramStatements (StatementList (FunctionDef (__kw__ name __bool__) (__kw__ args (arguments " \
                       "(__kw__ args (__list__ (arg self))))) (__kw__ body (StatementList (Expr STRING_775) (" \
                       "StatementList (Return (Compare (Attribute self _root) (__list__ IsNot) (__list__ None))) " \
                       "EMPTY_Statement)))) EMPTY_Statement))"


def test_func_with_kwargs():
    code_ast = ast.parse("def solve_all(grids, name=\"\", showif=0.0):\n     print('Hello world')")
    lisp_str = Py2Lisp().visit(code_ast)
    print(lisp_str)
    assert lisp_str == "(ProgramStatements (StatementList (FunctionDef (__kw__ name solve_all) (__kw__ args (" \
                       "arguments (__kw__ args (__list__ (arg grids) (arg name) (arg showif))) (__kw__ defaults (" \
                       "__list__ STRING_0 0.0)))) (__kw__ body (StatementList (Expr (Call print (__list__ STRING_1))) " \
                       "EMPTY_Statement))) EMPTY_Statement))"


def test_exception_handler():
    code_ast = ast.parse("try:\n    print()\nexcept:\n   print('fail')")
    lisp_str = Py2Lisp().visit(code_ast)
    print(lisp_str)
    assert lisp_str == "(ProgramStatements (StatementList (Try (__list__ (Expr (Call print))) (__list__ (" \
                       "ExceptHandler (__kw__ body (__list__ (Expr (Call print (__list__ STRING_0)))))))) " \
                       "EMPTY_Statement))"
