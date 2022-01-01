reset()
a, b, c = sample([-3, -2, -1, 1, 2, 3], 3)
A = matrix(QQ, 1, 1, [[a]])
B = matrix(QQ, 2, 2, [[b, 1], [0, b]])
C = matrix(2, 2, [[a, b],[-b, a]])
D = diagonal_matrix(QQ, [a, b, c])
E = diagonal_matrix(QQ, [a, a, c])
F = block_matrix(QQ, 2, 2, [[A, 0], [0, B]])
G = block_matrix(QQ, 2, 2, [[A, 0], [0, C]])

T  = random_matrix(ZZ, 3, 3, rank=3, algorithm='echelonizable', upper_bound=2)

mats = [T*D*T.inverse(), T*E*T.inverse(), T*F*T.inverse(), T*G*T.inverse()]
