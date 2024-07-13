import ast
import json
import click
import subprocess
import pathlib
import os
import shutil

from pybrary_extraction.python2lisp import Py2Lisp
from pybrary_extraction.lisp2py import Abstraction2Py, Rewrite2Py, Lisp2Py
from pybrary_extraction.lisp2py.StitchAbstraction import StitchAbstraction
from pybrary_extraction.ast_utils import find_ast_size_from_files
from pyparsing import OneOrMore, nestedExpr


def try_make_parent_dir(new_file_path):
    try:
        os.makedirs(pathlib.Path(new_file_path).parent)
    except FileExistsError:
        pass


class Leroy:
    LIBRARY_NAME = "leroy_library"

    def __init__(self, py_files_dir, iterations,
                 max_arity, min_nodes_abstraction,
                 donot_rerun, mangle_names):

        self.py_files_dir = py_files_dir
        self.min_nodes_abstraction = min_nodes_abstraction
        self.iterations = iterations
        self.max_arity = max_arity
        self.project_base_dir = pathlib.Path(__file__).parent.parent
        self.temp_dir = self.project_base_dir.joinpath("temp")
        self.temp_filename = "in.json"
        self.stitch_outfile = "out.json"

        # file path -> lisp-encoded ast
        self.file_json_map = None
        self.string_hashmap = None
        self.donot_rerun = donot_rerun
        self.mangle_names = mangle_names
        self.stitch_out = self.read_stitch_out()
        self.rewritten_asts_size = 0

    def run(self):

        self.clear_temp_dir()
        self.file_json_map, string_hashmap = Py2Lisp.fromDirectoryToJson(
            self.py_files_dir, self.mangle_names)
        self.string_hashmap = {v: k for k, v in string_hashmap.items()}  # reverse for convenience
        with open(f"{self.temp_dir}/{self.temp_filename}", "w") as f:
            json.dump(list(self.file_json_map.values()), f, indent=4)

        if not self.donot_rerun and not self.result_is_cached():
            self.run_stitch()
        self.write_files()
        self.report_compression()

    def run_stitch(self):
        subprocess.run(
            [
                "cargo", "run",
                "--manifest-path", f"{self.project_base_dir}/Cargo.toml",
                "--release", '--bin=compress',
                '--', f'{self.temp_dir}/{self.temp_filename}',
                f'--iterations={self.iterations}',
                f'--max-arity={self.max_arity}',
                f'--out={self.temp_dir}/{self.stitch_outfile}',
                "--prune-macro-abstractions",
                "--no-opt-arity-zero",
                f"--min-nodes-invention={self.min_nodes_abstraction}"
            ]
        )

        self.stitch_out = self.read_stitch_out()

    def write_files(self):

        stitch_out = self.stitch_out

        stitch_rewritten = stitch_out['rewritten']
        stitch_abstractions = [StitchAbstraction(i['body'], i['uses'], i['name'], self.string_hashmap)
                               for i in stitch_out["abstractions"]]
        original_lisp = stitch_out['original']

        self.write_abstractions(stitch_abstractions)
        self.write_rewritten_programs(stitch_rewritten, stitch_abstractions)

    def read_stitch_out(self):
        try:
            with open(f"{self.temp_dir}/{self.stitch_outfile}") as f:
                stitch_out = json.load(f)
            return stitch_out
        except FileNotFoundError:
            return

    def write_rewritten_programs(self, stitch_rewritten,
                                 stitch_abstractions: list[StitchAbstraction]):
        for file, rewrite in zip(self.file_json_map.keys(), stitch_rewritten):
            new_file_path = file.replace(self.py_files_dir, str(self.temp_dir))
            try_make_parent_dir(new_file_path)
            print(f"{new_file_path=}")

            try:
                rewrite_obj = Rewrite2Py(
                    rewrite,
                    library_name=Leroy.LIBRARY_NAME,
                    available_abstractions=stitch_abstractions,
                    string_hashmap=self.string_hashmap
                )
                py_code = rewrite_obj.convert()
            except:
                print(f"Failed to rewrite: {rewrite}")
                raise
            self.rewritten_asts_size += sum([1 for _ in ast.walk(rewrite_obj.converted_ast)])
            print(py_code)
            with open(new_file_path, "w") as f:
                f.write(py_code)

    def write_abstractions(self, stitch_abstractions: list[StitchAbstraction]):
        library_functions = []
        for i, abstraction in enumerate(stitch_abstractions):
            abstraction.compute_body_py(self.stitch_out['original'])
            library_functions.append(
                abstraction.abstraction_body_py
            )
        with open(f"{self.temp_dir}/{Leroy.LIBRARY_NAME}.py", "w") as f:
            f.write("\n\n".join(library_functions))

    def clear_temp_dir(self):
        try:
            shutil.rmtree(self.temp_dir)
        except FileNotFoundError:
            pass
        os.makedirs(self.temp_dir)
        if self.stitch_out:
            with open(f"{self.temp_dir}/{self.stitch_outfile}", "w") as f:
                json.dump(self.stitch_out, f, indent=4)

    def result_is_cached(self):
        if self.stitch_out:
            replace_equivalent = \
                ['ProgramStatements' if i == '(ProgramStatements )' else i for i in list(self.file_json_map.values())]
            if set(self.stitch_out['original']) == set(replace_equivalent):
                return True
        return False

    def report_compression(self):

        original_asts_size, orig_line_count, orig_char_count\
            = find_ast_size_from_files(*list(self.file_json_map.keys()), count_asts=True)
        new_files = [file.replace(self.py_files_dir, str(self.temp_dir)) for file in self.file_json_map]
        new_asts_size, new_line_count, new_char_count\
            = find_ast_size_from_files(*new_files, count_asts=False)
        new_asts_size = self.rewritten_asts_size

        print(f"{orig_line_count=}")
        print(f"{new_line_count=}")
        print(f"{orig_char_count=}")
        print(f"{new_char_count=}")
        print(f"{original_asts_size=}")
        print(f"{new_asts_size=}")
        print(f"Compression ratio: f{original_asts_size/new_asts_size}")




@click.command()
@click.option("--py_files_dir", help='directory containing python files to run leroy on.')
@click.option("--iterations", help='Number of iterations to run stitch for. '
                                   'A value of -1 runs until no more abstractions are possible', default=3, type=int)
@click.option("--max-arity", default=3, type=int, help='maximum number of parameters for an abstraction.')
@click.option("--min-nodes-abstraction", help='minimum number of ast nodes in the abstraction',
              default=10, type=int)
@click.option("--donot_rerun", help='Do not rerun leroy. USE for debugging only',
              default=False, type=bool)
@click.option("--mangle_names", help='Whether to mangle names or not. '
                                     'To avoid name clashes with the `ast` library.',
              default=False, type=bool)
def run_leroy(
        py_files_dir, iterations, max_arity, min_nodes_abstraction, donot_rerun,
        mangle_names
):
    l = Leroy(
        py_files_dir, iterations, max_arity, min_nodes_abstraction, donot_rerun, mangle_names)
    l.run()


if __name__ == '__main__':
    run_leroy()
