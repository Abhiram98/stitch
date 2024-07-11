def fib(n):
    # if(n==0):
    #     return 0
    # elif(n==1):
    #     return 1
    # else:
    #     return fib(n+-1) + fib(n+-2)
    return 0 if n == 0 else 1 if n == 1 else fib(n + -1) + fib(n + -2)

print(fib(6))