load('matrix_utils.sage')

#-----------------------------------------------------------------------------
#the following parameters must be set-up before launching this script:

#number of rows and columns
try:
    nrows
except NameError:
    nrows = 2

#number of rows and columns
try:
    ncols
except NameError:
    ncols = 2


#number of rows and columns
try:
    rg
except NameError:
    rg = min(nrows, ncols)

#bound on the largest entry size
try:
    h_max
except NameError:
    h_max = 10

#bound for no. of zeros in row or column of...
try:
    z_max
except NameError:
    z_max = 1

#data file path
try:
    file_path
except NameError:
    file_path='Data/'
    
#data file names
try:
    matrix_file_name
except NameError:
    matrix_file_name='nice-svd-' + str(nrows)+'x'+str(ncols)+'-r' + str(rg)+'-Zmatrices'


#----------------------------------------------------------------------------------------------
#generation of integral matrices whose singular values are integral or square roots of integers

try:
    full_matrix_path = file_path+matrix_file_name
    svd_mat_dict = load(full_matrix_path)
except:
    svd_mat_dict = {}

for tpl in itt.product(range(-h_max, h_max+1), repeat=nrows*ncols):
    if (tpl[0] < 0):
        continue
    A = matrix(nrows, tpl)
    if A.rank() != rg:
        continue
    if not accept_matrix(A, allow_colinear=True, max_zeros = z_max, max_height=h_max):
        continue 
    B = A*A.T
    if B.is_diagonal():
        continue
    svs = B.eigenvalues(); svs.sort()
    intsv = True
    for sv in svs:
        intsv = intsv and (sv in ZZ)
    if intsv:
        update_dict_lst(svd_mat_dict, tuple(svs), [A])

save(sort_dict(svd_mat_dict), full_matrix_path)
