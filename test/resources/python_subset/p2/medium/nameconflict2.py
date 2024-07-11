x1 = 7

def y1():
    f1 = 7

def f2():
    # print(101)
    x2 = 2
    # print(102)
    return lambda y2: x2 + y2

print(f2()(3))