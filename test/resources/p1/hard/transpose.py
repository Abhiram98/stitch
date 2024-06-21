matrix2 = [[1, 4, 7], [2, 5, 8], [3, 6, 9]]

matrix2_t2 = [[matrix2[2][0], matrix2[1][0], matrix2[0][0]],[matrix2[2][1], matrix2[1][1], matrix2[0][1]], [matrix2[2][2], matrix2[1][2], matrix2[0][2]]]


tmp0 = matrix2[0][0]
matrix2[0][0] = matrix2[2][0]
tmp2 = matrix2[0][1]
matrix2[0][1] = matrix2[1][0]
tmp3 = matrix2[0][2]
matrix2[0][2] = tmp0
tmp4 = matrix2[1][0]
matrix2[1][0] = matrix2[2][1]
tmp5 = matrix2[1][2]
matrix2[1][2] = tmp2
tmp6 = matrix2[2][0]
tmp7 = matrix2[2][2]
matrix2[2][0] = tmp7
matrix2[2][1] = tmp5
matrix2[2][2] = tmp3

print(matrix2 == matrix2_t2)