def fun_w_args(a, b):
    return a + b

print(fun_w_args(2, 3))


# ------

# def int_comp_eq(a,b):
#     return int(a==b)

# def int_comp_noteq(a,b):
#     return int(a!=b)

# inject_int=lambda x: int(x)
# inject_big = lambda x: x
# inject_bool = lambda x: bool(x)
# project_int = lambda x: x
# project_big = lambda x: x
# project_bool = lambda x: x
# is_true = lambda x: x 
# is_int = lambda x: type(x) == int
# is_bool = lambda x: type(x) == bool
# is_big = lambda x: (is_int(x) or is_bool(x)) == False
# create_list = lambda x: [1] * x
# create_dict = lambda : dict()


# def error_pyobj(msg):
#     raise Exception("type error")
    

# def set_subscript(l, i, v):
#     l[i] = v
#     return l
    

# def get_subscript(l, i):
#     return l[i]
    

# def __func1(_a,_b,free_vars_1):
# 	temp_2 = inject_int(0)
# 	temp_3 = inject_int(0)
# 	temp_4 = free_vars_1[temp_2]
# 	temp_5 = temp_4[temp_3]
# 	_temp_0 = temp_5 + _b
# 	return _temp_0

# temp_6 = [_a]
# temp_7 = create_closure(__func1,temp_6)
# _fun_w_args = inject_big(temp_7)
# temp_8 = get_fun_ptr(_fun_w_args)
# temp_9 = inject_int(2)
# temp_10 = inject_int(3)
# temp_11 = get_free_vars(_fun_w_args)
# _temp_1 = temp_8(temp_9,temp_10,temp_11)
# print(_temp_1)