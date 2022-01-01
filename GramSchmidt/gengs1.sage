import random as rnd

load('../matrix_utils.sage')

#-----------------------------------------------------------------------------
#the following parameters must be set-up before launching this script:
#number of rows and columns
try:
    num_rows
except NameError:
    num_rows = 3

try:
    num_cols
except NameError:
    num_cols = 3

#rank bounds

try:
    rg_min
except NameError:
    rg_min = 3

try:
    rg_max
except NameError:
    rg_max = 3
    
#largest allowed matrix elements

try:
    h_ort_max
except NameError:
    h_ort_max = 20

try:
    h_t_max
except NameError:
    h_t_max = 10

try:
    h_max
except NameError:
    h_max = 20

#bound for no. of zeros in row or column of...

try:
    z_ort_max
except NameError:
    z_ort_max = 0


try:
    z_t_max
except NameError:
    z_t_max = 0

try:
    z_max
except NameError:
    z_max = 0

#maximal number of matrices

try:
    ort_mat_num
except NameError:
    ort_mat_num = 20

try:
    t_mat_num
except NameError:
    t_mat_num = 20

try:
    mat_num
except NameError:
    mat_num = 10


#number of tries

try:
    lim_tries
except NameError:
    lim_tries = 1000

#--------------------------------------------------------------------------------
#generation of orthogonal matrices that correspond to distinct Pythagorean tuples

pt_tuples_set = {}
ort_mat_lst = []

for num_tries in range(lim_tries):

    try:
        ort_mat = random_orthogonal_Zmatrix(num_cols, max_height = h_ort_max)
    except:
        print('random_orthogonalZmatrix() exceeded try limit. Restarting on attempt no.'+str(num_tries) + ' with ' + str(len(ort_mat_lst)) + ' orthogonal matrices found so far!')
        ort_mat = None

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

#----------------------------------------------------------------------------------------
#generates the matrix of a specified rank with nice Gram-Schmidt reduction of row vectors

mat_lst = []
t_lst = []

E = identity_matrix(QQ, num_cols);

for omat in ort_mat_lst:

    for num_tries in range(lim_tries):

        #choose random rank
        rg = rnd.randint(rg_min, rg_max)

        try:
            T = random_ltdet1_Zmatrix(num_cols, h_t_max)
        except:
            print('random_ltdet1_Zmatrix exceeded the allowed number of tries. Restarting attempt no.'+ str(num_tries)+' with '+str(len(t_lst))+' matrices found so far.')
            T = None

        if T is None:
            continue

        if not accept_matrix(T + T.transpose()-E, max_zeros= z_t_max, max_height=h_t_max):
            continue

        k = min(num_rows, num_cols);

        #trim down T
        T = T.submatrix(0, 0, nrows=num_rows, ncols=num_cols)

        #add vectors that will cancel out in Gram-Schmidt
        defects = rnd.sample(range(2, k), k - rg)
        for df in defects:
            for col in range(min(rg, df), num_cols):
                T[df,col] = 0

        mat = T * omat

        if accept_matrix(mat, max_zeros=z_max, max_height=h_max):
            mat_lst.append(mat)
            t_lst.append(T)
            break
    if len(mat_lst) > mat_num:
        break

for j in range(len(mat_lst)):
    print('+++++++++++++++')
    print('T=')
    print(t_lst[j])
    print('Q=')
    print(mat_lst[j])
