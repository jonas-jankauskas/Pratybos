import random as rnd
import itertools as itt

#---------------------------------------------------------------------
#the following parameters must be set-up before launching this script:

#number of rows and columns
try:
    ndim
except NameError:
    ndim = 3

#rank bounds
try:
    rg
except NameError:
    rg = 3

#largest matrix element
try:
    h_max
except NameError:
    h_max = 8

#bound for no. of zeros in row or column
try:
    z_max
except NameError:
    z_max = 2

#number of matrices
try:
    mat_num
except NameError:
    mat_num = 20

#---------------------------------------------------------------------

mat_lst = []
vec_lst = []
answ_lst = []

while len(mat_lst) < mat_num:

    mat = random_matrix(ZZ, ndim, ndim, rank=rg, algorithm='echelonizable', upper_bound=h_max)
    vec = random_vector(ZZ, ndim, x=0, y=h_max)
    
    cnt0mat = max([r.list().count(0) for r in mat.rows()]+[c.list().count(0) for c in mat.columns()])
    cnt1mat = list(mat.columns()[0]).count(1)+list(mat.columns()[0]).count(-1)
    
    inv_mat = mat.inverse()
    answ = inv_mat*vec
    
    cnt0vec = vec.list().count(0)
    cnt0ans = vec.list().count(0)

    if (mat not in mat_lst) and (cnt0mat < z_max) and (cnt1mat > 0) and (inv_mat.height() < h_max) and (answ.norm(infinity) < h_max) and  (cnt0vec == 0) and (cnt0ans < z_max):
        mat_lst.append(mat)
        vec_lst.append(vec)
        answ_lst.append(answ)
        print(mat, '\n')
        print(inv_mat, '\n')
        print(vec)
        print(answ)
        print('-------------\n')
