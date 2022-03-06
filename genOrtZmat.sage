import random as rnd

load('matrix_utils.sage')

#-----------------------------------------------------------------------------
#the following parameters must be set-up before launching this script:

#method choice
try:
    meth
except NameError:
    meth = 'II'

#number of rows and columns
try:
    ndim
except NameError:
    ndim = 2

#bound on the largest entry size
try:
    h_max
except NameError:
    h_max = 100

#bound on the squared length of a row vector
try:
    l2_max
except NameError:
    l2_max =10000

#bound for no. of zeros in row or column of...
try:
    z_max
except NameError:
    z_max = 1

#number of tries
try:
    lim_tries
except NameError:
    lim_tries = 1000

#data file path
try:
    file_path
except NameError:
    file_path='Data/'
    
#data file names
try:
    matrix_file_name
except NameError:
    matrix_file_name='orthogonal-'+str(ndim)+'x'+str(ndim)+'-Zmatrices-m'+str(meth)

try:
    tuples_file_name
except NameError:
    tuples_file_name='pythagorean-'+str(ndim)+'-tuples'


#--------------------------------------------------------------------------------
#generation of orthogonal matrices that correspond to distinct Pythagorean tuples

try:
    full_matrix_path = file_path+matrix_file_name
    full_tuples_path = file_path+tuples_file_name
    ort_mat_rep_dict = load(full_matrix_path+'_rep')
    ort_mat_all_dict = load(full_matrix_path+'_all') 
    pt_tuples = load(full_tuples_path)
except:
    ort_mat_rep_dict = {}
    ort_mat_all_dict = {}
    pt_tuples = {}

for num_tries in range(lim_tries):

    try:
        if meth == 'I':
            ort_mat = random_orthogonal_Zmatrix_I(ndim, max_height = h_max)
        else:
            if meth == 'II':
                ort_mat = random_orthogonal_Zmatrix_II(ndim, ndim, max_height = h_max)

    except:
        print('random_orthogonalZmatrix_'+str(meth)+'() exceeded try limit. Restarting on attempt no.'+str(num_tries) + ' with ' + str(len(ort_mat_all_dict.values())) + ' classes of orthogonal matrices found so far!')
        continue

    if not accept_matrix(ort_mat, max_zeros=z_max, max_height = h_max, max_len2 = l2_max):
        continue
            
    if meth == 'I':
        new_tuples = Pythagorean_tuples(ort_mat)
        new_len = max([vector(tp).norm() for tp in new_tuples])
        update_dict_lst(pt_tuples, new_len, new_tuples)

    lkey = norm_rows(ort_mat);
    if lkey not in ort_mat_rep_dict.keys():
        ort_mat_rep_dict[lkey] = []
        ort_mat_all_dict[lkey] = []
        
    mat_found = False
    
    for eqv_class in ort_mat_all_dict[lkey]:
        mat_found = (ort_mat in eqv_class)
        if mat_found:
            break
    
    if not mat_found:
        new_class = flip_and_permute(ort_mat)
        new_class.sort()
        ort_mat_rep_dict[lkey].append(new_class[-1])
        ort_mat_all_dict[lkey].append(new_class)        

save(sort_dict(ort_mat_rep_dict), full_matrix_path + '_rep')
save(sort_dict(ort_mat_all_dict), full_matrix_path + '_all')
save(sort_dict(pt_tuples), full_tuples_path)
