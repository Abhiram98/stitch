def add2sub1(b):
    print(3)
    return sub1(add2(b))
def add2(c):
    print(2)
    return c + 2

def sub1(a):
    print(1)
    return a + -1


x = 5
print(x)
while(add2sub1(x) != 10):
    print(x)
    x = add2(x)

print(x)



    

