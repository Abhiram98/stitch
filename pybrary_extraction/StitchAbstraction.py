import ast

from pybrary_extraction.lisp2py import Lisp2Py, Rewrite2Py
from pybrary_extraction.lisp2py.ExtractedFragment import ExtractedFragment

class StitchAbstraction:
    def __init__(self, abstraction_body, uses):
        self.abstraction_body = abstraction_body
        self.uses = uses
        self.uses_py = {}
        self.live_vars_out = set()
        for use in self.uses:
            for application, target in use.items():
                wrapped_app = f"(ProgramStatements {application})"
                self.uses_py[Rewrite2Py(wrapped_app).convert()] = Lisp2Py(target).convert()

    def get_live_out(self, original_lisps):
        py_originals = []
        for lisp in original_lisps:
            py_originals.append(Lisp2Py(lisp).convert())

        live_vars_out = set()
        for use in self.uses_py:
            target = self.uses_py[use]
            for py_orig in py_originals:
                index = py_orig.find(target)
                if index!=-1:
                    live_vars = ExtractedFragment\
                        .create_from(py_orig, target, index).find_used_vars_later()
                    live_vars_out = live_vars_out.union(live_vars)

                    # note down stuff and do something.
        return live_vars_out