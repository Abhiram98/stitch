import pytest
import pathlib

from pybrary_extraction.leroy import run_leroy, Leroy


def test_simple_duplicate_files():
    run_leroy(
        [
            "--py_files_dir", "resources/simple_project/duplicate_files"
        ],
        standalone_mode=False
    )
    leroy_library_path = pathlib.Path("../temp/f1.py")
    f1_path = pathlib.Path("../temp/f1.py")
    f2_path = pathlib.Path("../temp/f2.py")
    assert (f1_path.exists())
    assert (f2_path.exists())
    assert (leroy_library_path.exists())

    with open(f1_path) as f:
        content = f.read()
        assert(content=="from leroy_library import fn_0\nmain = fn_0()")

    with open(f2_path) as f:
        content = f.read()
        assert (content == "from leroy_library import fn_0\nmain = fn_0()")

    with open(leroy_library_path) as f:
        content = f.read()
        assert(content == "def fn_0():\n    def main():\n        print(\"do something\")\n        print(\"do "
                           "something2\")    return main")


def test_Leroy_data_structures_arrays():
    run_leroy(
        [
            "--py_files_dir", "../Python/data_structures/arrays"
        ],
        standalone_mode=False
    )


def test_Leroy_data_structures():
    run_leroy(
        [
            "--py_files_dir", "../Python/data_structures"
        ],
        standalone_mode=False
    )




def test_Leroy_data_greedy():
    run_leroy(
        [
            "--py_files_dir", "../Python/greedy_methods",
            '--min-nodes-abstraction', '10',
            '--iterations', '5'
        ],
        standalone_mode=False
    )


def test_Leroy_data_computer_vision():
    run_leroy(
        [
            "--py_files_dir", "../Python/computer_vision",
            '--min-nodes-abstraction', '10',
            '--iterations', '5'
        ],
        standalone_mode=False
    )



def test_Leroy_p0():
    run_leroy(
        [
            "--py_files_dir", "../lab4-team-tyler-and-luke-1/tests/autograde/p0"
        ],
        standalone_mode=False
    )


def test_Leroy_p1():
    run_leroy(
        [
            "--py_files_dir", "../lab4-team-tyler-and-luke-1/tests/autograde/p1",
            '--min-nodes-abstraction', '10',
            '--iterations', '5'
        ],
        standalone_mode=False
    )


def test_Leroy_write_abstractions():

    j = Leroy("../Python/data_structures", 5, 3, 10)
    j.write_abstractions([i['body'] for i in j.stitch_out["abstractions"]])

