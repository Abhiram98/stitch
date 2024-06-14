from pybrary_extraction.ast_utils import FindTargetVariables, FindReadVariables
import ast

def test_lhs_vars():
    finder = FindTargetVariables()
    code_ast = ast.parse("x=1\nz+=1\nc:int=1")
    finder.visit(code_ast)
    assert("x" in finder.lhs_vars)
    assert ("z" in finder.lhs_vars)
    assert ("c" in finder.lhs_vars)

def test_lhs_vars_function():
    finder = FindTargetVariables()
    code_ast = ast.parse("def f():\n  print(\"hi\")")
    finder.visit(code_ast)
    assert("f" in finder.lhs_vars)


def test_lhs_vars_class():
    finder = FindTargetVariables()
    code_ast = ast.parse("class Y():\n  print(\"hi\")")
    finder.visit(code_ast)
    assert("Y" in finder.lhs_vars)

def test_lhs_vars_attribute_call():
    finder = FindTargetVariables()
    code_ast = ast.parse("x.foo(bar)")
    finder.visit(code_ast)
    print(finder.lhs_vars)
    assert("x" in finder.lhs_vars)


def test_rhs_vars():
    finder = FindReadVariables()
    code_ast = ast.parse("x=1\ny=x+5\nz=x+y")
    finder.visit(code_ast)
    assert("x" in finder.rhs_vars)
    assert("y" in finder.rhs_vars)
