def prod(a, b):
    return 0 if b == 0 else a + prod(a, b + -1)

def square(n):
    return prod(n, n)
    
i = 0
while square(i) != 25:
    i = i + 1