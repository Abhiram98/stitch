def compose(f1, g1):
    def _compose(x3):
        return f1(g1(x3))
    return _compose

def f(x1):
    return x1 + 1

def g(x2):
    return x2 + -1



print(compose(f, g)(23))