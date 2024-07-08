def prod(a, b):
    return 0 if b == 0 else a + prod(a, b + -1)

def square(n):
    return prod(n, n)

print(square(eval(input())))