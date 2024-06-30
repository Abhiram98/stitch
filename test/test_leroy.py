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
    leroy_library_path = pathlib.Path("../temp/leroy_library.py")
    f1_path = pathlib.Path("../temp/f1.py")
    f2_path = pathlib.Path("../temp/f2.py")
    assert (f1_path.exists())
    assert (f2_path.exists())
    assert (leroy_library_path.exists())

    with open(f1_path) as f:
        content = f.read()
        assert (content == "from leroy_library import fn_0\nmain = fn_0()")

    with open(f2_path) as f:
        content = f.read()
        assert (content == "from leroy_library import fn_0\nmain = fn_0()")

    with open(leroy_library_path) as f:
        content = f.read()
        assert (content == "def fn_0():\n\n    "
                           "def main():\n        print('do something')\n        print('do something2')\n    return main")


def test_simple_duplicate_almost():
    run_leroy(
        [
            "--py_files_dir", "resources/simple_project/duplicate_almost"
        ],
        standalone_mode=False
    )
    leroy_library_path = pathlib.Path("../temp/leroy_library.py")
    f1_path = pathlib.Path("../temp/f1.py")
    f2_path = pathlib.Path("../temp/f2.py")
    assert (f1_path.exists())
    assert (f2_path.exists())
    assert (leroy_library_path.exists())

    with open(f1_path) as f:
        content = f.read()
        assert (content == "from leroy_library import fn_0\nmain = fn_0('Hello world')")

    with open(f2_path) as f:
        content = f.read()
        assert (content == "from leroy_library import fn_0\nmain = fn_0('test test')")

    with open(leroy_library_path) as f:
        content = f.read()
        assert (content == "def fn_0(_param0):\n\n    "
                           "def main():\n        print('do something')\n        print(_param0)\n    return main")


def test_simple_duplicate_additional_lines():
    run_leroy(
        [
            "--py_files_dir", "resources/simple_project/duplicate_with_additional_lines"
        ],
        standalone_mode=False
    )
    leroy_library_path = pathlib.Path("../temp/leroy_library.py")
    f1_path = pathlib.Path("../temp/f1.py")
    f2_path = pathlib.Path("../temp/f2.py")
    assert (f1_path.exists())
    assert (f2_path.exists())
    assert (leroy_library_path.exists())

    with open(f1_path) as f:
        content = f.read()
        assert (content == "from leroy_library import fn_0\nmain = fn_0('Hello world')")

    with open(f2_path) as f:
        content = f.read()
        assert (content == "from leroy_library import fn_0\nmain = fn_0('test test')")

    with open(leroy_library_path) as f:
        content = f.read()
        assert (content == "def fn_0(_param0):\n\n    "
                           "def main():\n        print('do something')\n        print(_param0)\n    return main")


def test_Leroy_data_structures_arrays():
    run_leroy(
        [
            "--py_files_dir", "resources/data_structures/arrays",
            "--donot_rerun", "True"
        ],
        standalone_mode=False
    )


def test_Leroy_data_structures():
    run_leroy(
        [
            "--py_files_dir", "resources/data_structures"
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
            "--py_files_dir", "resources/p0"
        ],
        standalone_mode=False
    )


    leroy_library_path = pathlib.Path("../temp/leroy_library.py")
    assert (leroy_library_path.exists())

    succ_add_path = pathlib.Path("../temp/hard/succ_add.py")
    assert (succ_add_path.exists())

    # test that fn_1 is being called properly
    with open(succ_add_path) as f:
        content = f.read()
        assert (content.find("f = fn_1(w, z, y, x) + a + b + c + d + e") != -1)

    with open(leroy_library_path) as f:
        content = f.read()
        assert (content.find(
            'def fn_1(_param0, _param1, _param2, x):\n    return x + _param2 + _param1 + _param0') != -1)



def test_Leroy_p0a():
    run_leroy(
        [
            "--py_files_dir", "resources/p0a"
        ],
        standalone_mode=False
    )
    # TODO: Nothing was abstracted. This is fishy.



def test_Leroy_p1():
    run_leroy(
        [
            "--py_files_dir", "resources/p1"
        ],
        standalone_mode=False
    )
    # TODO: Nothing was abstracted. This is fishy.


def test_Leroy_write_abstractions():
    j = Leroy("../Python/data_structures", 5, 3, 10)
    j.write_abstractions([i['body'] for i in j.stitch_out["abstractions"]])
