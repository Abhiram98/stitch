def lessthan(a, b):
    return True if a == 0 else False if b == 0 else lessthan(a + -1, b + -1)


def sort(l, len):
    j = 0
    while j != len + -1:
        if lessthan(l[j], l[j + 1]):
            tmp = l[j]
            l[j] = l[j + 1]
            l[j + 1] = tmp
            j = -1
        else:
            x = 0
        j = j + 1
    return l


x = [10, 11, 8, 9, 5, 4]
len = 6
print(sort(x, len))