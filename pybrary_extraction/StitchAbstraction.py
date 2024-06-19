import ast

from pybrary_extraction.lisp2py.Lisp2Py import Lisp2Py
from pybrary_extraction.lisp2py.Rewrite2Py import Rewrite2Py
from pybrary_extraction.lisp2py.ExtractedFragment import ExtractedFragment


class StitchAbstraction:
    def __init__(self, abstraction_body_lisp, uses, abstraction_name):
        self.abstraction_body_lisp = abstraction_body_lisp
        self.uses = uses
        self.uses_py = {}
        self.live_vars_out = set()
        self.returned_vars = set()
        self.abstraction_body_py = None
        self.abstraction_name = abstraction_name
        for use in self.uses:
            for application, target in use.items():
                wrapped_app = f"(ProgramStatements {application})"
                self.uses_py[Rewrite2Py(wrapped_app, available_abstractions=[]).convert()] \
                    = Lisp2Py(target).convert()

    def get_and_set_live_out(self, original_lisps):
        py_originals = []
        for lisp in original_lisps:
            py_originals.append(Lisp2Py(lisp).convert())

        live_vars_out = set()
        for use in self.uses_py:
            target = self.uses_py[use]
            for py_orig in py_originals:
                index = py_orig.find(target)
                if index != -1:
                    live_vars = ExtractedFragment \
                        .create_from(py_orig, target, index).find_used_vars_later()
                    live_vars_out = live_vars_out.union(live_vars)

                    # note down stuff and do something.
        self.live_vars_out = self.live_vars_out.union(live_vars_out)
        return live_vars_out
