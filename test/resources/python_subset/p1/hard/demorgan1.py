a = True
b = False
x = not (a or b) == (not a) and (not b)
print(x)