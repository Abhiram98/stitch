def is_even(n):
    return is_odd(n + -1) if n != 0 else True

is_odd = lambda n: is_even(n + -1) if n != 0 else False


print(is_odd(23))
