import random as rnd

load('../matrix_utils.sage')

#-----------------------------------------------------------------------------
#the following parameters must be set-up before launching this script:
#matrix dimensions
try:
    nrows
except NameError:
    nrows = 2

try:
    ncols
except NameError:
    ncols = 2

#rank of th restricted subspace
try:
    rg
except NameError:
    rg = min(nrows, ncols)

   
#largest allowed matrix elements

try:
    s_max
except NameError:
    s_max = 10


try:
    file_path
except NameError:
    file_path='../Data/'

try:
    file_name
except NameError:
    file_name = 'nice-svd-'+str(nrows)+'x'+str(ncols)+'-r'+str(rg)+'-Zmatrices'

full_file_path = file_path+file_name

#--------------------------------------------------------------------------------
#generation of orthogonal vector sets

try:
    svd_mat_dict = load(full_file_path)
except Exception:
    svd_mat_dict = {}

svd_dict = {}

for sv_pair in svd_mat_dict.keys():
    if (sum(map(sqrt, sv_pair)) <= s_max) and (max(sv_pair) <= 50) and is_square(sv_pair[0]) and is_square(sv_pair[1]):
        M = rnd.choice(svd_mat_dict[sv_pair])
        if M != M.T:
            svd_dict[sv_pair] = nice_SVD(M)
