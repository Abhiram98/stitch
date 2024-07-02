import ast
import pylint
import tempfile
import json
import re


class MyList(list):
    def __init__(self, *args):
        super().__init__(args)


class MyKeyword:
    def __init__(self, kw, value):
        if isinstance(kw, ast.Name):
            kw = kw.id
        assert isinstance(kw, str) or kw is None
        self.kw = kw
        self.value = value


class StatementList:
    def __init__(self, statement1, statement2):
        self.statement1 = statement1
        self.statement2 = statement2

    def decode(self):
        return StatementList._decode(self)

    @staticmethod
    def _decode(start_statement):
        all_statements_list = [start_statement.statement1]
        if isinstance(start_statement.statement2, StatementList):
            all_statements_list += StatementList._decode(start_statement.statement2)
        if isinstance(start_statement.statement2, list):
            all_statements_list += start_statement.statement2
        return all_statements_list


def has_return_stmnt(py_ast):
    for node in ast.walk(py_ast):
        if isinstance(node, ast.Return):
            return True
    return False


def get_undef_vars(code_str):
    '''Find undefined variables within the code-block'''

    ERR_CODE = 'E0602'

    code_file = tempfile.NamedTemporaryFile("w", prefix='code_')
    code_file.write(code_str)
    code_file.flush()
    pylint_out = tempfile.NamedTemporaryFile("w", prefix='pylint_')
    # pylint_out.close()
    try:
        pylint.run_pylint(["pylint", code_file.name,
                           "--errors-only", "--disable=all",
                           "--enable=E0602", "--output-format=json", f"--output={pylint_out.name}"])
    except SystemExit:
        pass

    with open(pylint_out.name) as f:
        out_data = json.loads(f.read())

    pylint_out.close()
    code_file.close()

    undef_vars = set()
    for d in out_data:
        if (d['message-id'] == ERR_CODE):
            var_name = re.findall('\'([^"]*)\'', d['message'])[0]
            undef_vars.add(var_name)

    return undef_vars
