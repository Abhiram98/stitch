import ast

import pybrary_extraction.lisp2py as lisp2py


class StitchAbstraction:
    def __init__(self, abstraction_body_lisp, uses, abstraction_name):
        self.abstraction_body_lisp = abstraction_body_lisp
        self.uses = uses
        self.uses_py = {}
        self.parameters = set()  # input parameters
        self.live_vars_out = set()  # live variables out the block
        self.returned_vars = set()  # variables returned by the abstraction
        self.abstraction_body_py = None
        self.abstraction_name = abstraction_name
        for use in self.uses:
            for application, target in use.items():
                wrapped_app = f"(ProgramStatements {application})"
                self.uses_py[lisp2py.Rewrite2Py(wrapped_app, available_abstractions=[]).convert()] \
                    = lisp2py.Lisp2Py(target).convert()

    def get_and_set_live_out(self, original_lisps):
        py_originals = []
        for lisp in original_lisps:
            py_originals.append(lisp2py.Lisp2Py(lisp).convert())

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
