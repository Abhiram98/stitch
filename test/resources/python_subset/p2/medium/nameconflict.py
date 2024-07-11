f = lambda x: x

def use_f():
    return f

def create_f(f):
    return f

print(create_f(2))
print(use_f()(4))