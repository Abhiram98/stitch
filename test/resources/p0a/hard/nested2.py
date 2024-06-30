x = 1
y = 2
z = 0
loop_condition = 1

while int(x != 5):
    if (int(x == 1) or int(x == 4)):
        if int(y == 2):
            z = z + 1
        else:
            if int(y == 1):
                z = z + 2
            else:
                z = z + 3
    else:
        if (int(x == 2) or int(x == 5)):
            if int(y == 2):
                z = z + 2
            else:
                if int(y == 1):
                    z = z + 3
                else:
                    z = z + 1
        else:
            if int(y == 2):
                z = z + 3
            else:
                if int(y == 1):
                    z = z + 1
                else:
                    z = z + 2
            
    x = x + 1
    y = y + -1
    
print(z)

