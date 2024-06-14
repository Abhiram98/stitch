import pytest
from pybrary_extraction.leroy import run_leroy, Leroy


def test_simple_duplicate_files():
    run_leroy(
        [
            "--py_files_dir", "resources/simple_project/duplicate_files"
        ],
        standalone_mode=False
    )


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

