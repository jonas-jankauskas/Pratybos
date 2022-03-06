import random as rnd

load('matrix_utils.sage')

#-----------------------------------------------------------------------------
#the following parameters must be set-up before launching this script:

#number of rows and columns
try:
    ndim
except NameError:
    ndim = 3

#bound on the largest entry size
try:
    h_max
except NameError:
    h_max = 20

#displacement options
try:
    displ
except NameError:
    displ = None
    
#bound on the squared length of a row vector
try:
    l2_max
except NameError:
    l2_max =2*ndim*h_max^2

#bound for no. of zeros in a single row or column
try:
    z_max
except NameError:
    z_max = 1

#number of tries
try:
    lim_tries
except NameError:
    lim_tries = 10000

#data file path
try:
    file_path
except NameError:
    file_path='Data/'
    
#data file names
try:
    matrix_file_name
except NameError:
    matrix_file_name='rnd_symmetric-'+str(ndim)+'x'+str(ndim)+'-Zmatrices'

#--------------------------------------------------------------------------------
#generation of integer symmetric matrices that have integer eigenvalues

try:
    full_matrix_path = file_path+matrix_file_name
    sym_mat_rep_dict = load(full_matrix_path+'_rep')
    sym_mat_all_dict = load(full_matrix_path+'_all') 
except:
    sym_mat_rep_dict = {}
    sym_mat_all_dict = {}

for num_tries in range(lim_tries):

    try:
        sym_mat = random_nice_symmetric_Zmatrix(ndim, max_height = h_max, displacement='random')
    except:
        print('random_nice_symmetric_Zmatrix() exceeded try limit. Restarting on attempt no.'+str(num_tries) + ' with ' + str(len(sym_mat_all_dict.values())) + ' classes of nice symmetric matrices found so far!')
        continue

    if not accept_matrix(sym_mat, max_zeros=z_max, max_height = h_max, max_len2 = l2_max, is_prim=True):
        continue
 
    lkey = sym_mat.eigenvalues()
    lkey.sort()
    lkey = tuple(lkey)
    
    if lkey not in sym_mat_rep_dict.keys():
        sym_mat_rep_dict[lkey] = []
        sym_mat_all_dict[lkey] = []
        
    mat_found = False
    
    for eqv_class in sym_mat_all_dict[lkey]:
        mat_found = (sym_mat in eqv_class)
        if mat_found:
            break
    
    if not mat_found:
        new_class = flip_and_permute_sym(sym_mat)
        new_class.sort()
        sym_mat_rep_dict[lkey].append(new_class[-1])
        sym_mat_all_dict[lkey].append(new_class)        

save(sort_dict_lst(sym_mat_rep_dict), full_matrix_path + '_rep')
save(sort_dict(sym_mat_all_dict), full_matrix_path + '_all')
