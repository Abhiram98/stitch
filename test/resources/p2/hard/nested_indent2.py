def fun1():
    x = 1
    def fun2():
        x = 3
        def fun3():
            x = 5
            print(x)
            return x
        print(x)
        return fun3()
    print(x)
    return fun2()

print(fun1())