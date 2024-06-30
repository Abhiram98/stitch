x = 5
y = 10
z = 0

while int(x != 0):
    x = x + -1
    y_copy = y
    inner_loop_done = 0
    
    while int(y_copy != 0) and int(not inner_loop_done):
        y_copy = y_copy + -1
        if int(y_copy == 4):
            z = z + 1
            if int(x == 3):
                z = z + 1
                y = y + -1
                x = x + 1
                inner_loop_done = 1
            else:
                if int(x == 2):
                    z = z + 2
                else:
                    z = z + 3
                y = y + -1
                x = x + 1
                inner_loop_done = 1

    if int(not inner_loop_done):
        y = y_copy
        
print(z)

