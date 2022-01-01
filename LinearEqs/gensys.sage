import random as rnd

#the following parameters must be set-up before launching this script:
#number of rows and columns
#num_rows = 4
#num_cols = 4


#rank bounds
#rg_min = 3
#rg_max = 3

#largest matrix element
#h_max = 8

#bound for no. of zeros in row or column
#z_max = 2

#number of matrices
#sys_num = 30

mat_lst = []
while len(mat_lst) < sys_num:
    rg = rnd.randint(rg_min, rg_max)
    mat = random_matrix(ZZ, num_rows, num_cols, rank=rg, algorithm='echelonizable', upper_bound=h_max)
    cnt0 = max([r.list().count(0) for r in mat.rows()]+[c.list().count(0) for c in mat.columns()])
    cnt1 = list(mat.columns()[0]).count(1)+list(mat.columns()[0]).count(-1)
    red = mat.echelon_form()
    if (mat not in mat_lst) and (cnt0 < z_max) and (cnt1 > 0) and (red.height() < h_max):
        mat_lst.append(mat)

bvec_lst = []
uvec_lst = []
answ_lst = []

for mat in mat_lst:

    bvec = random_vector(ZZ, num_rows, x=-h_max+1, y=h_max)
    uvec = random_vector(ZZ, num_rows, x=-h_max//2 + 1, y=h_max//2)*mat
    answ = uvec*bvec
    
    ucnt0 = bvec.list().count(0)
    bcnt0 = bvec.list(),count(0)
   
    if (uvec.height() < h_max^2//2) and (abs(answ) < h_max^2) and (ucnt0 = 0) and (bcnt0 <= z_max):
        bvec_lst.append(bvec)
        uvec_lst.append(uvec)
        answ_lst.append(answ)

        print('A =', mat)
        print('rank =', mat.rank())
        print('b = ', bvec)
        print('u = ', uvec)
        print('u*b =', answ)
        print('\n')
