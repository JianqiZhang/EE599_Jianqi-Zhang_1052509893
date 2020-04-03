import numpy as np

matrix_A = np.loadtxt('Matrix_A.txt')
matrix_B = np.loadtxt('Matrix_B.txt')
print (matrix_A)

print(matrix_B)
result = np.dot(matrix_A, matrix_B)
np.set_printoptions(suppress=True)

print (result)