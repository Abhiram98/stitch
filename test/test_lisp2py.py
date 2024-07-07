import pytest
from pybrary_extraction.lisp2py import Abstraction2Py, Rewrite2Py, Lisp2Py
from pybrary_extraction.lisp2py.StitchAbstraction import StitchAbstraction


def test_basic():
    lisp_str = "(ProgramStatements (StatementList (Assign (__list__ left_sum) 0) (StatementList (Assign (" \
               "__list__ right_sum) 1) EMPTY_Statement)))"
    py = Lisp2Py(lisp_str).convert()
    print(py)
    assert py == 'left_sum = 0\nright_sum = 1'


def test_unaryop():
    lisp_str = "(ProgramStatements (StatementList (Assign (__list__ x) (UnaryOp USub 1)) EMPTY_Statement))"
    assert Lisp2Py(lisp_str).convert() == 'x = -1'


def test_annotated_funcdef():
    lisp_str = "(ProgramStatements (StatementList (FunctionDef (__kw__ name find_median_sorted_arrays) (" \
               "__kw__ args (arguments (__kw__ args (__list__ (arg nums1 (Subscript body_list int)) (arg nums2 (" \
               "Subscript body_list int)))))) (__kw__ body (StatementList (Expr (Call print (__list__ 1))) " \
               "EMPTY_Statement)) (__kw__ returns float)) EMPTY_Statement))"
    assert Lisp2Py(
        lisp_str).convert() == 'def find_median_sorted_arrays(nums1: body_list[int], nums2: body_list[int]) -> float:\n    print(1)'


def test_annotated_func_with_attribute_usage():
    lisp_str = "(ProgramStatements (StatementList (FunctionDef (__kw__ name __bool__) (__kw__ args (arguments " \
               "(__kw__ args (__list__ (arg self))))) (__kw__ body (StatementList (Expr STRING_775) (" \
               "StatementList (Return (Compare (Attribute self _root) (__list__ IsNot) (__list__ None))) " \
               "EMPTY_Statement)))) EMPTY_Statement))"
    assert Lisp2Py(lisp_str).convert() == \
           'def __bool__(self):\n    STRING_775\n    return self._root is not None'


def test_empty():
    lisp_str = "(ProgramStatements (StatementList EMPTY_Statement EMPTY_Statement))"
    assert Lisp2Py(lisp_str).convert() \
           == ''


def test_exception_handler():
    lisp_str = "(ProgramStatements (StatementList (Try (__list__ (Expr (Call print))) (__list__ (" \
               "ExceptHandler (__kw__ body (__list__ (Expr (Call print (__list__ STRING_0)))))))) " \
               "EMPTY_Statement))"
    py = Lisp2Py(lisp_str).convert()
    print(py)
    assert py == """try:
    print()
except:
    print(STRING_0)"""


def test_abstraction_to_py():
    lisp_str = "(If #0 (__list__ (Return #0)) (__list__ (Return #1)))"
    assert Abstraction2Py(StitchAbstraction(
        lisp_str, [], "abs0", string_hashmap={})).convert('abs0') \
           == 'def abs0(_param0, _param1):\n    if _param0:\n        return _param0\n    else:\n        return _param1'


def test_abstraction_to_py_2():
    lisp_str = "(If #0 (__list__ (Return #0)))"
    assert Abstraction2Py(StitchAbstraction(
        lisp_str, [], "abs0", string_hashmap={})).convert('abs0') \
           == 'def abs0(_param0):\n    if _param0:\n        return _param0'


def test_abstraction_to_py_addition_return():
    lisp_str = "(BinOp #0 Add #1)"
    assert Abstraction2Py(StitchAbstraction(
        lisp_str, [], "abs0", string_hashmap={})).convert('abs0') \
           == 'def abs0(_param0, _param1):\n    return _param0 + _param1'

def test_abstraction_to_py_multiple_params():
    lisp_str = "(StatementList (Assign (__list__ x) #2) (StatementList (Assign (__list__ y) #1) #0))"
    stitch_originals = ['(ProgramStatements (StatementList EMPTY_Statement EMPTY_Statement))', '(ProgramStatements (StatementList (Assign (__list__ x) 1) (StatementList (Assign (__list__ y) (UnaryOp USub 2)) (StatementList (Expr (Call print (__list__ (BinOp x Add y)))) EMPTY_Statement))))', '(ProgramStatements (StatementList (Assign (__list__ x) 2) (StatementList (Assign (__list__ y) (UnaryOp USub x)) (StatementList (Expr (Call print (__list__ x))) (StatementList (Expr (Call print (__list__ y))) EMPTY_Statement)))))', '(ProgramStatements (StatementList (Expr (Call print (__list__ (BinOp (BinOp (BinOp (BinOp 1 Add 2) Add 3) Add 4) Add 5)))) EMPTY_Statement))', '(ProgramStatements (StatementList (Expr (Call print (__list__ 1))) EMPTY_Statement))', '(ProgramStatements (StatementList (Expr (Call print (__list__ (UnaryOp USub 1)))) EMPTY_Statement))', '(ProgramStatements (StatementList (Assign (__list__ x) (Call eval (__list__ (Call input)))) (StatementList (Expr (Call print (__list__ (BinOp x Add 1)))) EMPTY_Statement)))', '(ProgramStatements (StatementList (Expr (Call print (__list__ (BinOp 1 Add (UnaryOp USub 2))))) EMPTY_Statement))', '(ProgramStatements (StatementList (Expr (Call print (__list__ (BinOp 1 Add 2)))) EMPTY_Statement))', '(ProgramStatements (StatementList (Assign (__list__ x) 1) (StatementList (Assign (__list__ y) 2) (StatementList (Expr (Call print (__list__ (BinOp x Add y)))) EMPTY_Statement))))', '(ProgramStatements (StatementList (Expr (Call print (__list__ (BinOp (Call eval (__list__ (Call input))) Add (Call eval (__list__ (Call input))))))) EMPTY_Statement))', '(ProgramStatements (StatementList (Assign (__list__ x) 1) (StatementList (Assign (__list__ y) 2) (StatementList (Assign (__list__ z) 3) (StatementList (Assign (__list__ w) 23) (StatementList (Assign (__list__ v) (UnaryOp USub 2)) (StatementList (Assign (__list__ k) 12) (StatementList (Expr (Call print (__list__ (BinOp (BinOp (BinOp (BinOp (BinOp x Add y) Add z) Add w) Add v) Add k)))) EMPTY_Statement))))))))', '(ProgramStatements (StatementList (Assign (__list__ x) 51474836) (StatementList (Expr (Call print (__list__ (BinOp (BinOp (BinOp (BinOp (BinOp (BinOp (BinOp x Add x) Add x) Add x) Add x) Add x) Add x) Add x)))) EMPTY_Statement)))', '(ProgramStatements (StatementList (Assign (__list__ tmp0) 1) (StatementList (Assign (__list__ tmp1) 2) (StatementList (Assign (__list__ tmp3) (BinOp tmp0 Add tmp1)) (StatementList (Assign (__list__ tmp4) (BinOp tmp1 Add tmp3)) (StatementList (Expr (Call print (__list__ (BinOp tmp3 Add tmp4)))) EMPTY_Statement))))))', '(ProgramStatements (StatementList (Assign (__list__ z) 4) (StatementList (Assign (__list__ w) 0) (StatementList (Assign (__list__ z) 1) (StatementList (Assign (__list__ x) (BinOp w Add z)) (StatementList (Assign (__list__ y) (BinOp x Add 1)) (StatementList (Assign (__list__ w) y) (StatementList (Expr (Call print (__list__ w))) EMPTY_Statement))))))))', '(ProgramStatements (StatementList (Assign (__list__ x) (BinOp 1 Add (Call eval (__list__ (Call input))))) (StatementList (Assign (__list__ y) (BinOp x Add x)) (StatementList (Assign (__list__ z) (BinOp y Add y)) (StatementList (Assign (__list__ w) (BinOp z Add z)) (StatementList (Assign (__list__ a) (BinOp w Add w)) (StatementList (Assign (__list__ b) (BinOp a Add a)) (StatementList (Assign (__list__ c) (BinOp b Add b)) (StatementList (Assign (__list__ d) (BinOp c Add c)) (StatementList (Assign (__list__ e) (BinOp d Add d)) (StatementList (Assign (__list__ f) (BinOp (BinOp (BinOp (BinOp (BinOp (BinOp (BinOp (BinOp x Add y) Add z) Add w) Add a) Add b) Add c) Add d) Add e)) (StatementList (Expr (Call print (__list__ c))) EMPTY_Statement))))))))))))', '(ProgramStatements (StatementList (Assign (__list__ _tmp1) 23) (StatementList (Assign (__list__ tmp2_) (UnaryOp USub 6)) (StatementList (Assign (__list__ tmp_3) 12) (StatementList (Expr (Call print (__list__ (BinOp (BinOp _tmp1 Add tmp2_) Add tmp_3)))) (StatementList (Expr (Call print (__list__ (BinOp tmp2_ Add tmp_3)))) EMPTY_Statement))))))', '(ProgramStatements (StatementList (Assign (__list__ x) 12) (StatementList (Expr (Call print (__list__ (BinOp 3 Add (BinOp 2 Add (UnaryOp USub (BinOp (BinOp (Call eval (__list__ (Call input))) Add (BinOp x Add (UnaryOp USub 2))) Add (UnaryOp USub x)))))))) EMPTY_Statement)))', '(ProgramStatements (StatementList (Assign (__list__ x) (BinOp 20 Add (UnaryOp USub (UnaryOp USub (UnaryOp USub (UnaryOp USub 30)))))) (StatementList (Expr (Call print (__list__ x))) EMPTY_Statement)))', '(ProgramStatements (StatementList (Assign (__list__ x) 2) (StatementList (Expr (Call print (__list__ (BinOp (BinOp (BinOp (BinOp (BinOp (BinOp (BinOp (BinOp (BinOp (BinOp (BinOp (BinOp x Add 1) Add 2) Add 3) Add 4) Add 5) Add 6) Add 7) Add 8) Add 9) Add 10) Add 11) Add 12)))) EMPTY_Statement)))', '(ProgramStatements (StatementList (Assign (__list__ x) (UnaryOp USub (BinOp 1 Add (UnaryOp USub 2)))) (StatementList (Expr (Call print (__list__ x))) EMPTY_Statement)))', '(ProgramStatements (StatementList (Assign (__list__ tmp0) 23) (StatementList (Assign (__list__ tmp0) (BinOp tmp0 Add 1)) (StatementList (Expr (Call print (__list__ tmp0))) EMPTY_Statement))))', '(ProgramStatements (StatementList (Assign (__list__ x) (Call eval (__list__ (Call input)))) (StatementList (Assign (__list__ y) (BinOp (Call eval (__list__ (Call input))) Add x)) (StatementList (Assign (__list__ z) (BinOp (Call eval (__list__ (Call input))) Add y)) (StatementList (Assign (__list__ w) (BinOp (Call eval (__list__ (Call input))) Add z)) (StatementList (Expr (Call print (__list__ (BinOp (BinOp (BinOp (BinOp x Add y) Add z) Add w) Add (Call eval (__list__ (Call input))))))) EMPTY_Statement))))))', '(ProgramStatements (StatementList (Assign (__list__ x) 2) (StatementList (Assign (__list__ y) 3) (StatementList (Expr (Call print (__list__ x))) (StatementList (Expr (Call print (__list__ y))) (StatementList (Assign (__list__ tmp) x) (StatementList (Assign (__list__ x) y) (StatementList (Assign (__list__ y) tmp) (StatementList (Expr (Call print (__list__ x))) (StatementList (Expr (Call print (__list__ y))) EMPTY_Statement))))))))))', '(ProgramStatements (StatementList (Expr 1) (StatementList (Expr 2) EMPTY_Statement)))', '(ProgramStatements (StatementList (Assign (__list__ tmp0) (UnaryOp USub (Call eval (__list__ (Call input))))) (StatementList (Assign (__list__ tmp1) (BinOp tmp0 Add 23)) (StatementList (Assign (__list__ tmp0) (Call eval (__list__ (Call input)))) (StatementList (Assign (__list__ tmp2) (BinOp tmp0 Add tmp1)) (StatementList (Expr (Call print (__list__ tmp2))) EMPTY_Statement))))))', '(ProgramStatements (StatementList (Expr (Call print (__list__ (UnaryOp USub (UnaryOp USub (UnaryOp USub (UnaryOp USub (UnaryOp USub (UnaryOp USub 2))))))))) EMPTY_Statement))', '(ProgramStatements (StatementList (Assign (__list__ x) 100) (StatementList (Expr (Call print (__list__ (UnaryOp USub (UnaryOp USub (UnaryOp USub (UnaryOp USub (UnaryOp USub x)))))))) EMPTY_Statement)))', '(ProgramStatements (StatementList (Expr (BinOp (Call eval (__list__ (Call input))) Add (Call eval (__list__ (Call input))))) (StatementList (Expr (Call eval (__list__ (Call input)))) EMPTY_Statement)))']
    uses = [{'fn_1 (StatementList (Assign (__list__ z) (BinOp y Add y)) (StatementList (Assign (__list__ w) (BinOp z Add z)) (StatementList (Assign (__list__ a) (BinOp w Add w)) (StatementList (Assign (__list__ b) (BinOp a Add a)) (StatementList (Assign (__list__ c) (BinOp b Add b)) (StatementList (Assign (__list__ d) (BinOp c Add c)) (StatementList (Assign (__list__ e) (BinOp d Add d)) (fn_0 c (BinOp (BinOp (BinOp (BinOp (BinOp (BinOp (BinOp (BinOp x Add y) Add z) Add w) Add a) Add b) Add c) Add d) Add e) f)))))))) (BinOp x Add x) (BinOp 1 Add (Call eval (__list__ (Call input))))': '(StatementList (Assign (__list__ x) (BinOp 1 Add (Call eval (__list__ (Call input))))) (StatementList (Assign (__list__ y) (BinOp x Add x)) (StatementList (Assign (__list__ z) (BinOp y Add y)) (StatementList (Assign (__list__ w) (BinOp z Add z)) (StatementList (Assign (__list__ a) (BinOp w Add w)) (StatementList (Assign (__list__ b) (BinOp a Add a)) (StatementList (Assign (__list__ c) (BinOp b Add b)) (StatementList (Assign (__list__ d) (BinOp c Add c)) (StatementList (Assign (__list__ e) (BinOp d Add d)) (fn_0 c (BinOp (BinOp (BinOp (BinOp (BinOp (BinOp (BinOp (BinOp x Add y) Add z) Add w) Add a) Add b) Add c) Add d) Add e) f))))))))))'}, {'fn_1 (fn_0 w y w) (BinOp x Add 1) (BinOp w Add z)': '(StatementList (Assign (__list__ x) (BinOp w Add z)) (StatementList (Assign (__list__ y) (BinOp x Add 1)) (fn_0 w y w)))'}, {'fn_1 (StatementList (Assign (__list__ z) (BinOp (Call eval (__list__ (Call input))) Add y)) (fn_0 (BinOp (BinOp (BinOp (BinOp x Add y) Add z) Add w) Add (Call eval (__list__ (Call input)))) (BinOp (Call eval (__list__ (Call input))) Add z) w)) (BinOp (Call eval (__list__ (Call input))) Add x) (Call eval (__list__ (Call input)))': '(StatementList (Assign (__list__ x) (Call eval (__list__ (Call input)))) (StatementList (Assign (__list__ y) (BinOp (Call eval (__list__ (Call input))) Add x)) (StatementList (Assign (__list__ z) (BinOp (Call eval (__list__ (Call input))) Add y)) (fn_0 (BinOp (BinOp (BinOp (BinOp x Add y) Add z) Add w) Add (Call eval (__list__ (Call input)))) (BinOp (Call eval (__list__ (Call input))) Add z) w))))'}, {'fn_1 (StatementList (Assign (__list__ z) 3) (StatementList (Assign (__list__ w) 23) (StatementList (Assign (__list__ v) (UnaryOp USub 2)) (fn_0 (BinOp (BinOp (BinOp (BinOp (BinOp x Add y) Add z) Add w) Add v) Add k) 12 k)))) 2 1': '(StatementList (Assign (__list__ x) 1) (StatementList (Assign (__list__ y) 2) (StatementList (Assign (__list__ z) 3) (StatementList (Assign (__list__ w) 23) (StatementList (Assign (__list__ v) (UnaryOp USub 2)) (fn_0 (BinOp (BinOp (BinOp (BinOp (BinOp x Add y) Add z) Add w) Add v) Add k) 12 k))))))'}, {'fn_1 (StatementList (Expr (Call print (__list__ x))) (StatementList (Expr (Call print (__list__ y))) EMPTY_Statement)) (UnaryOp USub x) 2': '(StatementList (Assign (__list__ x) 2) (StatementList (Assign (__list__ y) (UnaryOp USub x)) (StatementList (Expr (Call print (__list__ x))) (StatementList (Expr (Call print (__list__ y))) EMPTY_Statement))))'}, {'fn_1 (StatementList (Expr (Call print (__list__ x))) (StatementList (Expr (Call print (__list__ y))) (StatementList (Assign (__list__ tmp) x) (StatementList (Assign (__list__ x) y) (StatementList (Assign (__list__ y) tmp) (StatementList (Expr (Call print (__list__ x))) (StatementList (Expr (Call print (__list__ y))) EMPTY_Statement))))))) 3 2': '(StatementList (Assign (__list__ x) 2) (StatementList (Assign (__list__ y) 3) (StatementList (Expr (Call print (__list__ x))) (StatementList (Expr (Call print (__list__ y))) (StatementList (Assign (__list__ tmp) x) (StatementList (Assign (__list__ x) y) (StatementList (Assign (__list__ y) tmp) (StatementList (Expr (Call print (__list__ x))) (StatementList (Expr (Call print (__list__ y))) EMPTY_Statement)))))))))'}, {'fn_1 (StatementList (Expr (Call print (__list__ x))) (StatementList (Expr (Call print (__list__ y))) EMPTY_Statement)) tmp y': '(StatementList (Assign (__list__ x) y) (StatementList (Assign (__list__ y) tmp) (StatementList (Expr (Call print (__list__ x))) (StatementList (Expr (Call print (__list__ y))) EMPTY_Statement))))'}]
    abstraction = StitchAbstraction(lisp_str, uses, "fn_0", {})
    py = abstraction.compute_body_py(stitch_originals)
    print(py)
    assert py == """def fn_0(_param1, _param2):
    x = _param2
    y = _param1
    return (x, y)"""


def test_abstraction_to_py_return_param():
    lisp_str = '(StatementList (Assign (__list__ #2) #1) (StatementList (Expr (Call print (__list__ #0))) EMPTY_Statement))'
    stitch_originals = ['(ProgramStatements (StatementList EMPTY_Statement EMPTY_Statement))', '(ProgramStatements (StatementList (Assign (__list__ x) 1) (StatementList (Assign (__list__ y) (UnaryOp USub 2)) (StatementList (Expr (Call print (__list__ (BinOp x Add y)))) EMPTY_Statement))))', '(ProgramStatements (StatementList (Assign (__list__ x) 2) (StatementList (Assign (__list__ y) (UnaryOp USub x)) (StatementList (Expr (Call print (__list__ x))) (StatementList (Expr (Call print (__list__ y))) EMPTY_Statement)))))', '(ProgramStatements (StatementList (Expr (Call print (__list__ (BinOp (BinOp (BinOp (BinOp 1 Add 2) Add 3) Add 4) Add 5)))) EMPTY_Statement))', '(ProgramStatements (StatementList (Expr (Call print (__list__ 1))) EMPTY_Statement))', '(ProgramStatements (StatementList (Expr (Call print (__list__ (UnaryOp USub 1)))) EMPTY_Statement))', '(ProgramStatements (StatementList (Assign (__list__ x) (Call eval (__list__ (Call input)))) (StatementList (Expr (Call print (__list__ (BinOp x Add 1)))) EMPTY_Statement)))', '(ProgramStatements (StatementList (Expr (Call print (__list__ (BinOp 1 Add (UnaryOp USub 2))))) EMPTY_Statement))', '(ProgramStatements (StatementList (Expr (Call print (__list__ (BinOp 1 Add 2)))) EMPTY_Statement))', '(ProgramStatements (StatementList (Assign (__list__ x) 1) (StatementList (Assign (__list__ y) 2) (StatementList (Expr (Call print (__list__ (BinOp x Add y)))) EMPTY_Statement))))', '(ProgramStatements (StatementList (Expr (Call print (__list__ (BinOp (Call eval (__list__ (Call input))) Add (Call eval (__list__ (Call input))))))) EMPTY_Statement))', '(ProgramStatements (StatementList (Assign (__list__ x) 1) (StatementList (Assign (__list__ y) 2) (StatementList (Assign (__list__ z) 3) (StatementList (Assign (__list__ w) 23) (StatementList (Assign (__list__ v) (UnaryOp USub 2)) (StatementList (Assign (__list__ k) 12) (StatementList (Expr (Call print (__list__ (BinOp (BinOp (BinOp (BinOp (BinOp x Add y) Add z) Add w) Add v) Add k)))) EMPTY_Statement))))))))', '(ProgramStatements (StatementList (Assign (__list__ x) 51474836) (StatementList (Expr (Call print (__list__ (BinOp (BinOp (BinOp (BinOp (BinOp (BinOp (BinOp x Add x) Add x) Add x) Add x) Add x) Add x) Add x)))) EMPTY_Statement)))', '(ProgramStatements (StatementList (Assign (__list__ tmp0) 1) (StatementList (Assign (__list__ tmp1) 2) (StatementList (Assign (__list__ tmp3) (BinOp tmp0 Add tmp1)) (StatementList (Assign (__list__ tmp4) (BinOp tmp1 Add tmp3)) (StatementList (Expr (Call print (__list__ (BinOp tmp3 Add tmp4)))) EMPTY_Statement))))))', '(ProgramStatements (StatementList (Assign (__list__ z) 4) (StatementList (Assign (__list__ w) 0) (StatementList (Assign (__list__ z) 1) (StatementList (Assign (__list__ x) (BinOp w Add z)) (StatementList (Assign (__list__ y) (BinOp x Add 1)) (StatementList (Assign (__list__ w) y) (StatementList (Expr (Call print (__list__ w))) EMPTY_Statement))))))))', '(ProgramStatements (StatementList (Assign (__list__ x) (BinOp 1 Add (Call eval (__list__ (Call input))))) (StatementList (Assign (__list__ y) (BinOp x Add x)) (StatementList (Assign (__list__ z) (BinOp y Add y)) (StatementList (Assign (__list__ w) (BinOp z Add z)) (StatementList (Assign (__list__ a) (BinOp w Add w)) (StatementList (Assign (__list__ b) (BinOp a Add a)) (StatementList (Assign (__list__ c) (BinOp b Add b)) (StatementList (Assign (__list__ d) (BinOp c Add c)) (StatementList (Assign (__list__ e) (BinOp d Add d)) (StatementList (Assign (__list__ f) (BinOp (BinOp (BinOp (BinOp (BinOp (BinOp (BinOp (BinOp x Add y) Add z) Add w) Add a) Add b) Add c) Add d) Add e)) (StatementList (Expr (Call print (__list__ c))) EMPTY_Statement))))))))))))', '(ProgramStatements (StatementList (Assign (__list__ _tmp1) 23) (StatementList (Assign (__list__ tmp2_) (UnaryOp USub 6)) (StatementList (Assign (__list__ tmp_3) 12) (StatementList (Expr (Call print (__list__ (BinOp (BinOp _tmp1 Add tmp2_) Add tmp_3)))) (StatementList (Expr (Call print (__list__ (BinOp tmp2_ Add tmp_3)))) EMPTY_Statement))))))', '(ProgramStatements (StatementList (Assign (__list__ x) 12) (StatementList (Expr (Call print (__list__ (BinOp 3 Add (BinOp 2 Add (UnaryOp USub (BinOp (BinOp (Call eval (__list__ (Call input))) Add (BinOp x Add (UnaryOp USub 2))) Add (UnaryOp USub x)))))))) EMPTY_Statement)))', '(ProgramStatements (StatementList (Assign (__list__ x) (BinOp 20 Add (UnaryOp USub (UnaryOp USub (UnaryOp USub (UnaryOp USub 30)))))) (StatementList (Expr (Call print (__list__ x))) EMPTY_Statement)))', '(ProgramStatements (StatementList (Assign (__list__ x) 2) (StatementList (Expr (Call print (__list__ (BinOp (BinOp (BinOp (BinOp (BinOp (BinOp (BinOp (BinOp (BinOp (BinOp (BinOp (BinOp x Add 1) Add 2) Add 3) Add 4) Add 5) Add 6) Add 7) Add 8) Add 9) Add 10) Add 11) Add 12)))) EMPTY_Statement)))', '(ProgramStatements (StatementList (Assign (__list__ x) (UnaryOp USub (BinOp 1 Add (UnaryOp USub 2)))) (StatementList (Expr (Call print (__list__ x))) EMPTY_Statement)))', '(ProgramStatements (StatementList (Assign (__list__ tmp0) 23) (StatementList (Assign (__list__ tmp0) (BinOp tmp0 Add 1)) (StatementList (Expr (Call print (__list__ tmp0))) EMPTY_Statement))))', '(ProgramStatements (StatementList (Assign (__list__ x) (Call eval (__list__ (Call input)))) (StatementList (Assign (__list__ y) (BinOp (Call eval (__list__ (Call input))) Add x)) (StatementList (Assign (__list__ z) (BinOp (Call eval (__list__ (Call input))) Add y)) (StatementList (Assign (__list__ w) (BinOp (Call eval (__list__ (Call input))) Add z)) (StatementList (Expr (Call print (__list__ (BinOp (BinOp (BinOp (BinOp x Add y) Add z) Add w) Add (Call eval (__list__ (Call input))))))) EMPTY_Statement))))))', '(ProgramStatements (StatementList (Assign (__list__ x) 2) (StatementList (Assign (__list__ y) 3) (StatementList (Expr (Call print (__list__ x))) (StatementList (Expr (Call print (__list__ y))) (StatementList (Assign (__list__ tmp) x) (StatementList (Assign (__list__ x) y) (StatementList (Assign (__list__ y) tmp) (StatementList (Expr (Call print (__list__ x))) (StatementList (Expr (Call print (__list__ y))) EMPTY_Statement))))))))))', '(ProgramStatements (StatementList (Expr 1) (StatementList (Expr 2) EMPTY_Statement)))', '(ProgramStatements (StatementList (Assign (__list__ tmp0) (UnaryOp USub (Call eval (__list__ (Call input))))) (StatementList (Assign (__list__ tmp1) (BinOp tmp0 Add 23)) (StatementList (Assign (__list__ tmp0) (Call eval (__list__ (Call input)))) (StatementList (Assign (__list__ tmp2) (BinOp tmp0 Add tmp1)) (StatementList (Expr (Call print (__list__ tmp2))) EMPTY_Statement))))))', '(ProgramStatements (StatementList (Expr (Call print (__list__ (UnaryOp USub (UnaryOp USub (UnaryOp USub (UnaryOp USub (UnaryOp USub (UnaryOp USub 2))))))))) EMPTY_Statement))', '(ProgramStatements (StatementList (Assign (__list__ x) 100) (StatementList (Expr (Call print (__list__ (UnaryOp USub (UnaryOp USub (UnaryOp USub (UnaryOp USub (UnaryOp USub x)))))))) EMPTY_Statement)))', '(ProgramStatements (StatementList (Expr (BinOp (Call eval (__list__ (Call input))) Add (Call eval (__list__ (Call input))))) (StatementList (Expr (Call eval (__list__ (Call input)))) EMPTY_Statement)))']
    uses = [{'fn_0 c (BinOp (BinOp (BinOp (BinOp (BinOp (BinOp (BinOp (BinOp x Add y) Add z) Add w) Add a) Add b) Add c) Add d) Add e) f': '(StatementList (Assign (__list__ f) (BinOp (BinOp (BinOp (BinOp (BinOp (BinOp (BinOp (BinOp x Add y) Add z) Add w) Add a) Add b) Add c) Add d) Add e)) (StatementList (Expr (Call print (__list__ c))) EMPTY_Statement))'}, {'fn_0 (BinOp (BinOp (BinOp (BinOp (BinOp x Add y) Add z) Add w) Add v) Add k) 12 k': '(StatementList (Assign (__list__ k) 12) (StatementList (Expr (Call print (__list__ (BinOp (BinOp (BinOp (BinOp (BinOp x Add y) Add z) Add w) Add v) Add k)))) EMPTY_Statement))'}, {'fn_0 tmp0 (BinOp tmp0 Add 1) tmp0': '(StatementList (Assign (__list__ tmp0) (BinOp tmp0 Add 1)) (StatementList (Expr (Call print (__list__ tmp0))) EMPTY_Statement))'}, {'fn_0 tmp2 (BinOp tmp0 Add tmp1) tmp2': '(StatementList (Assign (__list__ tmp2) (BinOp tmp0 Add tmp1)) (StatementList (Expr (Call print (__list__ tmp2))) EMPTY_Statement))'}, {'fn_0 (BinOp tmp3 Add tmp4) (BinOp tmp1 Add tmp3) tmp4': '(StatementList (Assign (__list__ tmp4) (BinOp tmp1 Add tmp3)) (StatementList (Expr (Call print (__list__ (BinOp tmp3 Add tmp4)))) EMPTY_Statement))'}, {'fn_0 (BinOp (BinOp (BinOp (BinOp x Add y) Add z) Add w) Add (Call eval (__list__ (Call input)))) (BinOp (Call eval (__list__ (Call input))) Add z) w': '(StatementList (Assign (__list__ w) (BinOp (Call eval (__list__ (Call input))) Add z)) (StatementList (Expr (Call print (__list__ (BinOp (BinOp (BinOp (BinOp x Add y) Add z) Add w) Add (Call eval (__list__ (Call input))))))) EMPTY_Statement))'}, {'fn_0 w y w': '(StatementList (Assign (__list__ w) y) (StatementList (Expr (Call print (__list__ w))) EMPTY_Statement))'}, {'fn_0 x (BinOp 20 Add (UnaryOp USub (UnaryOp USub (UnaryOp USub (UnaryOp USub 30))))) x': '(StatementList (Assign (__list__ x) (BinOp 20 Add (UnaryOp USub (UnaryOp USub (UnaryOp USub (UnaryOp USub 30)))))) (StatementList (Expr (Call print (__list__ x))) EMPTY_Statement))'}, {'fn_0 (BinOp x Add 1) (Call eval (__list__ (Call input))) x': '(StatementList (Assign (__list__ x) (Call eval (__list__ (Call input)))) (StatementList (Expr (Call print (__list__ (BinOp x Add 1)))) EMPTY_Statement))'}, {'fn_0 x (UnaryOp USub (BinOp 1 Add (UnaryOp USub 2))) x': '(StatementList (Assign (__list__ x) (UnaryOp USub (BinOp 1 Add (UnaryOp USub 2)))) (StatementList (Expr (Call print (__list__ x))) EMPTY_Statement))'}, {'fn_0 (UnaryOp USub (UnaryOp USub (UnaryOp USub (UnaryOp USub (UnaryOp USub x))))) 100 x': '(StatementList (Assign (__list__ x) 100) (StatementList (Expr (Call print (__list__ (UnaryOp USub (UnaryOp USub (UnaryOp USub (UnaryOp USub (UnaryOp USub x)))))))) EMPTY_Statement))'}, {'fn_0 (BinOp 3 Add (BinOp 2 Add (UnaryOp USub (BinOp (BinOp (Call eval (__list__ (Call input))) Add (BinOp x Add (UnaryOp USub 2))) Add (UnaryOp USub x))))) 12 x': '(StatementList (Assign (__list__ x) 12) (StatementList (Expr (Call print (__list__ (BinOp 3 Add (BinOp 2 Add (UnaryOp USub (BinOp (BinOp (Call eval (__list__ (Call input))) Add (BinOp x Add (UnaryOp USub 2))) Add (UnaryOp USub x)))))))) EMPTY_Statement))'}, {'fn_0 (BinOp (BinOp (BinOp (BinOp (BinOp (BinOp (BinOp (BinOp (BinOp (BinOp (BinOp (BinOp x Add 1) Add 2) Add 3) Add 4) Add 5) Add 6) Add 7) Add 8) Add 9) Add 10) Add 11) Add 12) 2 x': '(StatementList (Assign (__list__ x) 2) (StatementList (Expr (Call print (__list__ (BinOp (BinOp (BinOp (BinOp (BinOp (BinOp (BinOp (BinOp (BinOp (BinOp (BinOp (BinOp x Add 1) Add 2) Add 3) Add 4) Add 5) Add 6) Add 7) Add 8) Add 9) Add 10) Add 11) Add 12)))) EMPTY_Statement))'}, {'fn_0 (BinOp (BinOp (BinOp (BinOp (BinOp (BinOp (BinOp x Add x) Add x) Add x) Add x) Add x) Add x) Add x) 51474836 x': '(StatementList (Assign (__list__ x) 51474836) (StatementList (Expr (Call print (__list__ (BinOp (BinOp (BinOp (BinOp (BinOp (BinOp (BinOp x Add x) Add x) Add x) Add x) Add x) Add x) Add x)))) EMPTY_Statement))'}, {'fn_0 (BinOp x Add y) (UnaryOp USub 2) y': '(StatementList (Assign (__list__ y) (UnaryOp USub 2)) (StatementList (Expr (Call print (__list__ (BinOp x Add y)))) EMPTY_Statement))'}, {'fn_0 (BinOp x Add y) 2 y': '(StatementList (Assign (__list__ y) 2) (StatementList (Expr (Call print (__list__ (BinOp x Add y)))) EMPTY_Statement))'}]
    abstraction = StitchAbstraction(lisp_str, uses, "fn_0", {})
    py = abstraction.compute_body_py(stitch_originals)
    print(py)

def test_abstraction_to_py_3():
    #TODO: Modify test case
    try:
        lisp_str = "(ProgramStatements (__list__ (UnaryOp Not (Compare #0 (__list__ Eq) (__list__ (UnaryOp Not a)))) " \
                   "(UnaryOp Not b)))"
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
    lisp_str = "(ProgramStatements (StatementList (Assign (__list__ x) 5) (StatementList (Expr (Call custom_function (" \
               "__list__ y))) EMPTY_Statement)))"
    py = Abstraction2Py(
        StitchAbstraction(lisp_str, [], "abs0", {})).convert()
    print(py)
    assert py == \
           'def fn_0(custom_function, y):\n    x = 5\n    custom_function(y)'


def test_abstraction_to_py_fn_as_kw():
    lisp_str = "(ProgramStatements (FunctionDef #2 (__kw__ args (arguments (__kw__ args (#1 (arg #0)))))))"
    try:
        py = Abstraction2Py(
            StitchAbstraction(lisp_str, [], "abs0", {})).convert()
        print(py)
    except:
        print("Failure expected")
        # This test is expected to fail because there are a
        # mix of __kw__ args and positional arguments
        pass


def test_abstraction_to_py_with_valid_hole():
    lisp_str = '(ProgramStatements ' \
               '(StatementList (Assign (__list__ x) 1) ' \
               '(StatementList (Assign (__list__ y) (UnaryOp USub 2))' \
               '#1' \
               ')))'
    py = Abstraction2Py(
        StitchAbstraction(lisp_str, [], "abs0", {}),
        find_additional_params=False
    ).convert()
    print(py)
    assert py \
           == """def fn_0():
    x = 1
    y = -2"""


def test_abstraction_to_py_with_valid_hole_2():
    lisp_str = '(StatementList (Assign (__list__ x) 1) ' \
               '(StatementList (Assign (__list__ y) (UnaryOp USub 2))' \
               '#1' \
               '))'
    py = Abstraction2Py(
        StitchAbstraction(lisp_str, [], "fn_0", {}),
        find_additional_params=False
    ).convert()
    print(py)
    assert py \
           == """def fn_0():
    x = 1
    y = -2"""


def test_abstraction_to_py_with_valid_hole_with_uses():
    lisp_str = '(StatementList (Assign (__list__ x) 1) ' \
               '(StatementList (Assign (__list__ y) (UnaryOp USub 2))' \
               '#0' \
               '))'
    use1 = {"fn_0 (StatementList (Expr (Call print (__list__ x))) EMPTY_Statement)":
                '(StatementList (Assign (__list__ x) 1) ' \
                '(StatementList (Assign (__list__ y) (UnaryOp USub 2))' \
                '(StatementList (Expr (Call print (__list__ x))) EMPTY_Statement)' \
                '))'}
    stitch_originals = ['(ProgramStatements (StatementList (Assign (__list__ x) 1) ' \
                        '(StatementList (Assign (__list__ y) (UnaryOp USub 2))' \
                        '(StatementList (Expr (Call print (__list__ x))) EMPTY_Statement)' \
                        ')))']
    py = StitchAbstraction(lisp_str, [use1], "fn_0", {}).compute_body_py(stitch_originals)
    print(py)
    assert py \
           == """def fn_0():
    x = 1
    y = -2
    return x"""


def test_abstraction_to_py_with_valid_hole_with_uses_multiple_return():
    abstraction_body_lisp = '(StatementList (Assign (__list__ x) 1) ' \
                            '(StatementList (Assign (__list__ y) (UnaryOp USub 2))' \
                            '#0' \
                            '))'
    use1 = {"fn_0 (StatementList (Expr (Call print (__list__ x y))) EMPTY_Statement)":
                '(StatementList (Assign (__list__ x) 1) ' \
                '(StatementList (Assign (__list__ y) (UnaryOp USub 2))' \
                '(StatementList (Expr (Call print (__list__ x y))) EMPTY_Statement)' \
                '))'}
    stitch_originals = ['(ProgramStatements (StatementList (Assign (__list__ x) 1) ' \
                        '(StatementList (Assign (__list__ y) (UnaryOp USub 2))' \
                        '(StatementList (Expr (Call print (__list__ x y))) EMPTY_Statement)' \
                        ')))']
    abstraction = StitchAbstraction(abstraction_body_lisp, [use1], "fn_0", {})
    py = abstraction.compute_body_py(stitch_originals)
    print(py)
    assert py \
           == """def fn_0():
    x = 1
    y = -2
    return (x, y)"""

    rewrite = "(ProgramStatements " \
              "(fn_0 (StatementList (Expr (Call print (__list__ x y))) EMPTY_Statement)))"
    rewritten_py = Rewrite2Py(
        rewrite,
        library_name="leroy_library",
        available_abstractions=[abstraction],
        string_hashmap={}
    ).convert()
    assert rewritten_py == "from leroy_library import fn_0\n(x, y) = fn_0()\nprint(x, y)"
    "(fn_0 (StatementList (Expr (Call print (__list__ x y))) EMPTY_Statement))"

    rewrite_2 = "(ProgramStatements (StatementList (FunctionDef (__kw__ name main) (__kw__ args arguments) (__kw__ body (fn_0 (StatementList (Expr (Call print (__list__ x y))) EMPTY_Statement)))) EMPTY_Statement))"
    rewritten_py_2 = Rewrite2Py(
        rewrite_2,
        library_name="leroy_library",
        available_abstractions=[abstraction],
        string_hashmap={}
    ).convert()
    assert rewritten_py_2 == "from leroy_library import fn_0\n(x, y) = fn_0()\nprint(x, y)"

def test_abstraction_to_py_with_invalid_hole():
    lisp_str = '(ProgramStatements ' \
               '(StatementList (Assign (__list__ x) 1) ' \
               '(StatementList (Assign (__list__ y) (UnaryOp USub 2))' \
               '(StatementList #1)' \
               ')))'
    try:
        py = Abstraction2Py(
            StitchAbstraction(lisp_str, [], "abs0", {}),
            find_additional_params=False
        ).convert()
    except:
        print("error expected")
        return
    raise Exception("Should have failed.")


def test_abstraction_to_py_with_invalid_hole_in_the_middle():
    lisp_str = '(ProgramStatements ' \
               '(StatementList (Assign (__list__ x) 1) ' \
               '(StatementList #1' \
               '(StatementList (Assign (__list__ y) (UnaryOp USub 2)) EMPTY_Statement)' \
               ')))'
    # try:
    py = Abstraction2Py(
        StitchAbstraction(lisp_str, [], "abs0", {})).convert()
    # except:
    #     print("error expected")
    #     return
    raise Exception("Should have failed.")


def test_abstraction_to_py_with_invalid_hole_2():
    lisp_str = "(StatementList " \
               "(FunctionDef (__kw__ name main) (__kw__ args arguments) " \
               "(__kw__ body " \
               "(StatementList (Assign (__list__ x) 1) " \
               "(StatementList #2 (StatementList (Expr (Call print (__list__ #1))) #0))))) " \
               "EMPTY_Statement)"
    try:
        py = Abstraction2Py(
            StitchAbstraction(lisp_str, [], "abs0", {})).convert()
    except:
        print("error expected")
        return
    raise Exception("Should have failed.")


def test_rewrite_to_py():
    lisp_str = "(fn_0 1 2)"
    assert Rewrite2Py(lisp_str, available_abstractions=[]).convert() \
           == 'from leroy_library import fn_0\nfn_0(1, 2)'


def test_rewrite_to_py_function_def():
    lisp_str = "(ProgramStatements (StatementList (FunctionDef (__kw__ name main) (__kw__ args arguments) (__kw__ " \
               "body (StatementList (Expr (Call print (__list__ STRING_0))) EMPTY_Statement))) EMPTY_Statement))"
    assert Rewrite2Py(lisp_str, available_abstractions=[]).convert() \
           == """def main():
    print(STRING_0)"""

    print("done")


#

def test_rewrite_to_py_function_def_two_lines():
    lisp_str = "(ProgramStatements (StatementList (FunctionDef (__kw__ name main) (__kw__ args arguments) (__kw__ " \
               "body (StatementList (Expr (Call print (__list__ STRING_0))) (StatementList (Expr (Call print (" \
               "__list__ STRING_1))) EMPTY_Statement)))) EMPTY_Statement))"
    assert Rewrite2Py(lisp_str, available_abstractions=[]).convert() \
           == """def main():
    print(STRING_0)
    print(STRING_1)"""

    print("done")


def test_rewrite_to_py_fndef_with_kwargs():
    lisp_str = "(ProgramStatements (StatementList (FunctionDef (__kw__ name solve_all) (__kw__ args (" \
               "arguments (__kw__ args (__list__ (arg grids) (arg name) (arg showif))) (__kw__ defaults (" \
               "__list__ STRING_0 0.0)))) (__kw__ body (StatementList (Expr (Call print (__list__ STRING_1))) " \
               "EMPTY_Statement))) EMPTY_Statement))"
    py = Rewrite2Py(lisp_str, available_abstractions=[]).convert()
    print(py)
    assert py == """def solve_all(grids, name=STRING_0, showif=0.0):
    print(STRING_1)"""


def test_rewrite_to_py_2():
    lisp_str = "(fn_0 1 (fn_2 5 6)))"
    assert Rewrite2Py(lisp_str, available_abstractions=[]).convert() \
           == 'from leroy_library import fn_0\nfrom leroy_library import fn_2\nfn_0(1, fn_2(5, 6))'


def test_rewrite_to_py_3():
    lisp_str = '(ProgramStatements ' \
               '(StatementList (Assign (__list__ x) 1) ' \
               '(StatementList (Assign (__list__ y) (UnaryOp USub 2))' \
               '(StatementList (fn_0 (fn_1 x y)) EMPTY_Statement)' \
               ')))'
    py = Rewrite2Py(lisp_str, available_abstractions=[]).convert()
    print(py)
    assert py \
           == 'from leroy_library import fn_0\nfrom leroy_library import fn_1\nx = 1\ny = -2\nfn_0(fn_1(x, y))'


def test_rewrite_to_py_4():
    # TODO: this test is failing. Figure out why is was created in the first place.
    #  This is not a valid rewrite.
    lisp_str = '(ProgramStatements (If (Compare #2 (__list__ #1) (__list__ #0))))'
    assert Rewrite2Py(lisp_str, available_abstractions=[]).convert() \
           == 'z = #1\nw = #0'


def test_rewrite_to_py_5():
    lisp_str = "(ProgramStatements (StatementList (FunctionDef (__kw__ name main) (__kw__ args arguments) (__kw__ " \
               "body (fn_0 (Expr (Call print (__list__ x))) STRING_1 x))) EMPTY_Statement))"
    py = Rewrite2Py(lisp_str, available_abstractions=[]).convert()
    print(py)


def test_rewrite_to_py_import():
    # TODO: this test is failing. Figure out why is was created in the first place.
    #  This is not a valid rewrite.
    lisp_str = '(ProgramStatements (fn_0 (Attribute doctest testmod) (Import (__list__ (alias doctest)))))'
    assert Rewrite2Py(lisp_str, available_abstractions=[]).convert() \
           == 'z = #1\nw = #0'


def test_rewrite_to_py_arguments():
    lisp_str = "(ProgramStatements (arguments __list__ (__list__ (arg  #0)) EMPTY_vararg __list__ __list__ " \
               "EMPTY_kwarg __list__))"
    py = Rewrite2Py(lisp_str, available_abstractions=[]).convert()
    print(py)
