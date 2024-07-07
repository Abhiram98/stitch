def sum(a, b):
    return a + b

def prod(a, b):
    return 0 if b == 0 else a + prod(a, b + -1)

def sub(a, b):
    return a + -b

x = [sum, prod, sub]
print(x[0](1, 2))
print(x[1](1, 2))
print(x[2](1, 2))