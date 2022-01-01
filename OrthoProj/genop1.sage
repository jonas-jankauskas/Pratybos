import random as rnd

load('../matrix_utils.sage')

#the following parameters must be set-up before launching this script:
#number of rows and columns
#num_rows = 2
#num_cols = 3

#rank bounds
#rg_min = 3
#rg_max = 3

#largest matrix elements
#h_ort_max = 10
#h_t_max = 10
#h_max = 10

#bound for no. of zeros in row or column
#z_ort_max = 1
#z_t_max = 0
#z_max = 0

#maximal number of matrices
#ort_mat_num = 20
#t_mat_num = 20

#number of tries
#lim_tries = 1000


#generation of orthogonal matrices that correspond to distinct Pythagorean tuples

pt_tuples_set = {}
ort_mat_lst = []

for num_tries in range(lim_tries):

    ort_mat = random_orthogonal_Zmatrix(num_cols, max_height = 20)

    if ort_mat is None:
        continue

    if not accept_matrix(ort_mat, max_zeros=z_ort_max, max_height = h_ort_max):
        continue
            
    pt_tuples = Pythagorean_tuples(ort_mat)
        
    if pt_tuples.issubset(pt_tuples_set):
        continue
        
    pt_tuples_set = pt_tuples.union(pt_tuples_set)
    ort_mat_lst.append(ort_mat)

    if len(ort_mat_lst) >= ort_mat_num:
        break


mat_lst = []
vec_lst = []
proj_lst = []
orth_lst = []


E = identity_matrix(QQ, num_cols);

for omat in ort_mat_lst:

    for num_tries in range(lim_tries):

        T = random_ltdet1_Zmatrix(num_cols, h_t_max)

        if not accept_matrix(T + T.transpose()-E, max_zeros= z_t_max, max_height=h_t_max):
            continue

        mat = T * omat

        if not accept_matrix(mat, max_zeros=z_max, max_height=h_max):
            continue
        
        rvec = random_vector(ZZ, num_cols, -h_max, h_max);
        vec = rvec * omat

        if (vec.list().count(0) > z_max)  or (vec.norm(infinity) > h_max):
            continue

        plst = (rvec.list())[:num_rows]+[0]*(num_cols-num_rows)
        pvec = vector(QQ, num_cols, plst)

        proj = pvec * omat
        orth = vec - proj

        if (proj.list().count(0) > z_max)  or (proj.norm(infinity) > h_max):
            continue

        if (orth.list().count(0) > z_max)  or (orth.norm(infinity) > h_max):
            continue
                
        mat_lst.append(mat)
        vec_lst.append(vec)
        proj_lst.append(proj)
        orth_lst.append(orth)
        
