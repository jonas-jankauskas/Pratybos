
import random as rnd
import itertools as itt

#---------------------------------------------------------------------
#the following parameters must be set-up before launching this script:

#number of rows and columns
try:
    num_rows
except NameError:
    num_rows = 4
try:
    num_cols
except NameError:
    num_cols = 4

#rank bounds
try:
    rg_min
except NameError:
    rg_min = 2

try:
    rg_max
except NameError:
    rg_max = 2

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
    mat_num = 1
#---------------------------------------------------------------------
#report colinear rows and columns
def colinear(u, v):
    A = matrix(ZZ, [u, v])
    if A.rank() == 2:
        return 0
    else:
        return 1
                
def check_mat(M):
    return (sum(colinear(u, v) for u, v in itt.combinations(M.rows(),2)), sum(colinear(u, v) for u, v in itt.combinations(M.columns(),2)))

#---------------------------------------------------------------------

mat_lst = []
while len(mat_lst) < mat_num:
    rg = rnd.randint(rg_min, rg_max)
    mat = random_matrix(ZZ, num_rows, num_cols, rank=rg, algorithm='echelonizable', upper_bound=h_max)
    cnt0 = max([r.list().count(0) for r in mat.rows()]+[c.list().count(0) for c in mat.columns()])
    cnt1 = list(mat.columns()[0]).count(1)+list(mat.columns()[0]).count(-1)
    crows, ccols = check_mat(mat)
    red = mat.echelon_form()
    if (mat not in mat_lst) and (cnt0 < z_max) and (cnt1 > 0) and (red.height() < h_max) and (crows+ccols ==0):
        mat_lst.append(mat)
        print(mat)
        print('rank =', mat.rank())
