import pytest
from pybrary_extraction.lisp2py import Abstraction2Py, Rewrite2Py, Lisp2Py
from pybrary_extraction.StitchAbstraction import StitchAbstraction


def test_basic():
    lisp_str = "(ProgramStatements (Assign (__list__ left_sum) 0) (Assign (__list__ right_sum) 1))"
    assert Lisp2Py(lisp_str).convert() == 'left_sum = 0\nright_sum = 1'


def test_unaryop():
    lisp_str = "(ProgramStatements (Assign (__list__ x) (UnaryOp USub 1)))"
    assert Lisp2Py(lisp_str).convert() == 'x = -1'


def test_annotated_funcdef():
    lisp_str = '(ProgramStatements (FunctionDef find_median_sorted_arrays (arguments (__list__ (arg nums1 (Subscript list int)) (arg nums2 (Subscript list int)))) (__list__ (Expr (Call print (__list__ 1)))) (__list__ ) float))'
    assert Lisp2Py(
        lisp_str).convert() == 'def find_median_sorted_arrays(nums1: list[int], nums2: list[int]) -> float:\n    print(1)'


def test_empty():
    lisp_str = "(ProgramStatements )"
    assert Lisp2Py(lisp_str).convert() \
           == ''


def test_abstraction_to_py():
    lisp_str = "(If #0 (__list__ (Return #0)) (__list__ (Return #1)))"
    assert Abstraction2Py(StitchAbstraction(lisp_str, [], "abs0")).convert('abs0') \
           == 'def abs0(_param0, _param1):\n    if _param0:\n        return _param0\n    else:\n        return _param1'


def test_abstraction_to_py_2():
    lisp_str = "(If #0 (__list__ (Return #0)))"
    assert Abstraction2Py(StitchAbstraction(lisp_str, [], "abs0")).convert('abs0') \
           == 'def abs0(_param0):\n    if _param0:\n        return _param0'


def test_abstraction_to_py_addition_return():
    lisp_str = "(BinOp #0 Add #1)"
    assert Abstraction2Py(StitchAbstraction(lisp_str, [], "abs0")).convert('abs0') \
           == 'def abs0(_param0, _param1):\n    return _param0 + _param1'


def test_abstraction_to_py_3():
    try:
        lisp_str = "(ProgramStatements (__list__ (UnaryOp Not (Compare #0 (__list__ Eq) (__list__ (UnaryOp Not a)))) (UnaryOp Not b)))"
        Rewrite2Py(lisp_str, available_abstractions=[]).convert()
    except Exception as e:
        print("That's normal")
        print(e)
        return
    raise Exception("Should've error out.")


def test_abstraction_to_py_simple_expressions():
    # TODO: modify this test to return x
    #  pass uses param to StitchAbstraction obj
    #  pass lisp_originals to get_and_set_live_out.
    lisp_str = "(ProgramStatements (Assign (__list__ x) 5) (Expr (Call print (__list__ y))))"
    abstraction = StitchAbstraction(lisp_str, [], "fn_0")
    abstraction.get_and_set_live_out()
    assert Abstraction2Py(abstraction).convert() == 'def fn_0(y):\n    return \n    x = ' \
                                                                                '5\n    print(y)'


def test_abstraction_to_py_func_as_param():
    lisp_str = "(ProgramStatements (Assign (__list__ x) 5) (Expr (Call custom_function (__list__ y))))"
    assert Abstraction2Py(
        StitchAbstraction(lisp_str, [], "abs0")).convert() == \
           'def fn_0(custom_function, y):\n    return \n    x = 5\n    custom_function(y)'


def test_rewrite_to_py():
    lisp_str = "(fn_0 1 2)"
    assert Rewrite2Py(lisp_str, available_abstractions=[]).convert() \
           == 'from leroy_library import fn_0\nfn_0(1, 2)'


def test_rewrite_to_py_function_def():
    lisp_str = "(FunctionDef main arguments (__list__ (Expr (Call print (__list__ STRING_0)))) __list__)"
    assert Rewrite2Py(lisp_str, available_abstractions=[]).convert() \
           == """def main():
    print(STRING_0)"""

    print("done")


#

def test_rewrite_to_py_function_def_two_lines():
    lisp_str = "(FunctionDef main arguments (__list__ (Expr (Call print (__list__ STRING_0))) (Expr (Call print (__list__ STRING_1)))))"
    assert Rewrite2Py(lisp_str, available_abstractions=[]).convert() \
           == """def main():
    print(STRING_0)
    print(STRING_1)"""

    print("done")


def test_rewrite_to_py_2():
    lisp_str = "(fn_0 1 (fn_2 5 6)))"
    assert Rewrite2Py(lisp_str, available_abstractions=[]).convert() \
           == 'from leroy_library import fn_0\nfrom leroy_library import fn_2\nfn_0(1, fn_2(5, 6))'


def test_rewrite_to_py_3():
    lisp_str = '(ProgramStatements (Assign (__list__ x) 1) (Assign (__list__ y) (UnaryOp USub 2)) (fn_0 (fn_1 x y)))'
    assert Rewrite2Py(lisp_str, available_abstractions=[]).convert() \
           == 'from leroy_library import fn_0\nfrom leroy_library import fn_1\nx = 1\ny = -2\nfn_0(fn_1(x, y))'


def test_rewrite_to_py_4():
    # TODO: this test is failing. Figure out why is was created in the first place.
    #  This is not a valid rewrite.
    lisp_str = '(ProgramStatements (If (Compare #2 (__list__ #1) (__list__ #0))))'
    assert Rewrite2Py(lisp_str, available_abstractions=[]).convert() \
           == 'z = #1\nw = #0'


def test_rewrite_to_py_5():
    lisp_str = "(ProgramStatements (FunctionDef find_median_sorted_arrays (arguments (__list__ (arg nums1 (Subscript list int)) (arg nums2 (Subscript list int)))) (__list__ (Expr STRING_1) (If (BoolOp And (__list__ (UnaryOp Not nums1) (UnaryOp Not nums2))) (__list__ (Raise (fn_0 STRING_2 ValueError)))) (fn_2 (fn_0 (BinOp nums1 Add nums2) sorted) merged) (fn_2 (fn_0 merged len) total) (If (fn_1 1 (BinOp total Mod 2)) (__list__ (Return (fn_0 (Subscript merged (BinOp total FloorDiv 2)) float)))) (fn_2 (Subscript merged (BinOp (BinOp total FloorDiv 2) Sub 1)) middle1) (fn_2 (Subscript merged (BinOp total FloorDiv 2)) middle2) (Return (BinOp (BinOp (fn_0 middle1 float) Add (fn_0 middle2 float)) Div 2.0))) float) (If (fn_1 STRING_3 __name__) (__list__ (Import (__list__ (alias doctest))) (Expr (Call (Attribute doctest testmod))))))"


def test_rewrite_to_py_import():
    # TODO: this test is failing. Figure out why is was created in the first place.
    #  This is not a valid rewrite.
    lisp_str = '(ProgramStatements (fn_0 (Attribute doctest testmod) (Import (__list__ (alias doctest)))))'
    assert Rewrite2Py(lisp_str, available_abstractions=[]).convert() \
           == 'z = #1\nw = #0'
