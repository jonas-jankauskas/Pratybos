import random as rnd

load('matrix_utils.sage')

#-----------------------------------------------------------------------------
#the following parameters must be set-up before launching this script:

#method choice
#'I'- integer othogonal matrices (orthogonal rows and orthogonal columns)
#'II'- integer semi-orthogonal matrices (orthogonal rows, but not necessarily columns)
try:
    method
except NameError:
    method = 'I'

#dimension
try:
    ndim
except NameError:
    ndim = 2

#bound on the largest entry
try:
    h_max
except NameError:
    h_max = 50

#bound on row squared length
try:
    l2_max
except NameError:
    l2_max =ndim*h_max^2

#bound for row or column no. of zeros
try:
    z_max
except NameError:
    z_max = 0

#number of tries
try:
    num_tries
except NameError:
    num_tries = 1000

#data file path
try:
    file_path
except NameError:
    file_path='Data/'
    
#data file names
try:
    matrix_file_name
except NameError:
    matrix_file_name='orthogonal-'+str(ndim)+'x'+str(ndim)+'-Zmatrices-m'+str(method)

try:
    tuples_file_name
except NameError:
    tuples_file_name='pythagorean-'+str(ndim)+'-tuples'

try:
	print_status
except NameError:
	print_status=False

#--------------------------------------------------------------------------------
#generation of orthogonal matrices that correspond to distinct Pythagorean tuples

try:
    full_matrix_path = file_path+matrix_file_name
    full_tuples_path = file_path+tuples_file_name
    ort_mat_lst = load(full_matrix_path)
    pit_tup_lst = load(full_tuples_path)
except:
    ort_mat_lst = []
    pit_tup_lst = []

for num_tries in range(num_tries):

    try:

        if method == 'I':
            ort_mat = random_orthogonal_Zmatrix_I(ndim, max_height = h_max)
        elif method == 'II':
            ort_mat = random_orthogonal_Zmatrix_II(ndim, ndim, max_height = h_max)

    except:
        print('random_orthogonalZmatrix_'+str(method)+'() exceeded try limit. Restarting on attempt no.'+str(num_tries) + ' with ' + str(len(ort_mat_lst)) + ' classes of orthogonal matrices found so far!')
        continue

    if not accept_matrix(ort_mat, max_zeros=z_max, max_height = h_max, max_len2 = l2_max):
        continue

   #update list of Pythagorean tuples
    if method == 'I':
       update_lst(pit_tup_lst, Pythagorean_tuples(ort_mat))
       pit_tup_lst.sort()


    #find a representative with most positive entries and store it
    eqv_ort_mats = flip_and_permute(ort_mat)
    eqv_ort_mats.sort()
    rep_ort_mat = eqv_ort_mats[-1]
    if rep_ort_mat not in ort_mat_lst:
        ort_mat_lst.append(rep_ort_mat)
        ort_mat_lst.sort()
    	
save(ort_mat_lst, full_matrix_path)
save(pit_tup_lst, full_tuples_path)

if print_status:
    if method=='I':
        print(':::::::::::::::::::::::::')
        print('Pythagorean tuples found:\n')
        for tp in pit_tup_lst:
            print(tp)
    print(':::::::::::::::::::::::::')
    print('Orthogonal matrices found:\n')
    for mat in ort_mat_lst:
        print(mat)
        print('\n')
