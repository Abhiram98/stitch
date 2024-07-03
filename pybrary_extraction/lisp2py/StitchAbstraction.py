import ast

import pybrary_extraction.lisp2py as lisp2py
import pybrary_extraction.python2lisp as python2lisp


class StitchAbstraction:
    def __init__(self, abstraction_body_lisp, uses, abstraction_name, string_hashmap):
        self.abstraction_body_lisp = abstraction_body_lisp
        self.uses = uses
        self.uses_py = {}
        self.parameters = set()  # input parameters
        self.live_vars_out = set()  # live variables out the block
        self.returned_vars = set()  # variables returned by the abstraction
        self.abstraction_body_py = None
        self.abstraction_name = abstraction_name
        self.string_hashmap = string_hashmap
        Py2Lisp = python2lisp.Py2Lisp

        for use in self.uses:
            for application, target in use.items():
                # 'application' is a function call that always looks like
                # fn_0 param1 param2 param3 ...

                wrapped_app = f"({Py2Lisp.module_keyword} " \
                              f"({Py2Lisp.statement_keyword} ({application}) {Py2Lisp.empty_statement_keyword}))"
                self.uses_py[
                    lisp2py.Rewrite2Py(
                        wrapped_app,
                        available_abstractions=[],
                        string_hashmap=self.string_hashmap).convert()] \
                    = lisp2py.Rewrite2Py(target,
                                         available_abstractions=[],
                                         string_hashmap=self.string_hashmap).convert()

    def get_and_set_live_out(self, original_lisps):
        py_originals = []
        for lisp in original_lisps:
            py_originals.append(
                lisp2py.Lisp2Py(lisp, string_hashmap=self.string_hashmap).convert())

        live_vars_out = set()
        for use in self.uses_py:
            target = self.uses_py[use]
            for py_orig in py_originals:
                index = py_orig.find(target)
                if index != -1:
                    live_vars = lisp2py.ExtractedFragment \
                        .create_from(py_orig, target, index).find_used_vars_later()
                    live_vars_out = live_vars_out.union(live_vars)

                    # note down stuff and do something.
        self.live_vars_out = self.live_vars_out.union(live_vars_out)
        return live_vars_out

    def get_additional_params(self):
        return [i for i in self.parameters if not i.startswith(lisp2py.Abstraction2Py.PARAM_KEY)]
