import pytest
from pybrary_extraction.lisp2python import Lisp2Py, Abstraction2Py, Rewrite2Py


def test_basic():
    lisp_str = "(ProgramStatements (Assign (__list__ left_sum) 0) (Assign (__list__ right_sum) 1))"
    assert Lisp2Py(lisp_str).convert() == 'left_sum = 0\nright_sum = 1'


def test_unaryop():
    lisp_str = "(ProgramStatements (Assign (__list__ x) (UnaryOp USub 1)))"
    assert Lisp2Py(lisp_str).convert() == 'x = -1'


def test_annotated_funcdef():
    lisp_str = '(ProgramStatements (FunctionDef find_median_sorted_arrays (arguments (__list__ (arg nums1 (Subscript list int)) (arg nums2 (Subscript list int)))) (__list__ (Expr (Call print (__list__ 1)))) (__list__ ) float))'
    assert Lisp2Py(lisp_str).convert() == 'def find_median_sorted_arrays(nums1: list[int], nums2: list[int]) -> float:\n    print(1)'

def test_empty():
    lisp_str = "(ProgramStatements )"
    assert Lisp2Py(lisp_str).convert() \
           == ''


def test_abstraction_to_py():
    lisp_str = "(If #0 (__list__ (Return #0)) (__list__ (Return #1)))"
    assert Abstraction2Py(lisp_str).convert('abs0') \
           == 'def abs0(_param0, _param1):\n    if _param0:\n        return _param0\n    else:\n        return _param1'


def test_abstraction_to_py_2():
    lisp_str = "(If #0 (__list__ (Return #0)))"
    assert Abstraction2Py(lisp_str).convert('abs0') \
           == 'def abs0(_param0):\n    if _param0:\n        return _param0'

def test_abstraction_to_py_addition_return():
    lisp_str = "(BinOp #0 Add #1)"
    assert Abstraction2Py(lisp_str).convert('abs0') \
           == 'def abs0(_param0, _param1):\n    return _param0 + _param1'


def test_abstraction_to_py_3():
    try:
        lisp_str = "(ProgramStatements (__list__ (UnaryOp Not (Compare #0 (__list__ Eq) (__list__ (UnaryOp Not a)))) (UnaryOp Not b)))"
        Rewrite2Py(lisp_str).convert()
    except Exception as e:
        print("That's normal")
        print(e)
        return
    raise Exception("Should've error out.")

    # assert Rewrite2Py(lisp_str).convert() \
    #        == 'def abs0(_param0):\n    if _param0:\n        return _param0'


def test_rewrite_to_py():
    lisp_str = "(fn_0 1 2)"
    assert Rewrite2Py(lisp_str).convert() \
           == 'fn_0(1, 2)'


def test_rewrite_to_py_2():
    lisp_str = "(fn_0 1 (fn_2 5 6)))"
    assert Rewrite2Py(lisp_str).convert() \
           == 'fn_0(1, fn_2(5, 6))'


def test_rewrite_to_py_3():
    lisp_str = '(ProgramStatements (Assign (__list__ x) 1) (Assign (__list__ y) (UnaryOp USub 2)) (fn_0 (fn_1 x y)))'
    assert Rewrite2Py(lisp_str).convert() \
           == 'x = 1\ny = -2\nfn_0(fn_1(x, y))'


def test_rewrite_to_py_4():
    lisp_str = '(ProgramStatements (If (Compare #2 (__list__ #1) (__list__ #0))))'
    assert Rewrite2Py(lisp_str).convert() \
           == 'z = #1\nw = #0'

def test_rewrite_to_py_5():
    lisp_str = "(ProgramStatements (FunctionDef find_median_sorted_arrays (arguments (__list__ (arg nums1 (Subscript list int)) (arg nums2 (Subscript list int)))) (__list__ (Expr STRING_1) (If (BoolOp And (__list__ (UnaryOp Not nums1) (UnaryOp Not nums2))) (__list__ (Raise (fn_0 STRING_2 ValueError)))) (fn_2 (fn_0 (BinOp nums1 Add nums2) sorted) merged) (fn_2 (fn_0 merged len) total) (If (fn_1 1 (BinOp total Mod 2)) (__list__ (Return (fn_0 (Subscript merged (BinOp total FloorDiv 2)) float)))) (fn_2 (Subscript merged (BinOp (BinOp total FloorDiv 2) Sub 1)) middle1) (fn_2 (Subscript merged (BinOp total FloorDiv 2)) middle2) (Return (BinOp (BinOp (fn_0 middle1 float) Add (fn_0 middle2 float)) Div 2.0))) float) (If (fn_1 STRING_3 __name__) (__list__ (Import (__list__ (alias doctest))) (Expr (Call (Attribute doctest testmod))))))"


def test_rewrite_to_py_import():
    lisp_str = '(ProgramStatements (fn_0 (Attribute doctest testmod) (Import (__list__ (alias doctest)))))'
    assert Rewrite2Py(lisp_str).convert() \
           == 'z = #1\nw = #0'