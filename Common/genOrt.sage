import random as rnd

load('../matrix_utils.sage')

#-----------------------------------------------------------------------------
#the following parameters must be set-up before launching this script:

#method choice
#'I'- integer othogonal matrices (orthogonal rows and orthogonal columns)
#'II'- integer semi-orthogonal matrices (orthogonal rows, but not necessarily columns)
try:
    ort_method
except NameError:
    ort_method = 'II'

#dimension
try:
    ndim_ort
except NameError:
    ndim_ort = 3

#bound on the largest entry
try:
    h_ort_max
except NameError:
    h_ort_max = 20

#bound on row squared length
try:
    l2_ort_max
except NameError:
    l2_ort_max =ndim_ort*h_ort_max^2

#bound for row or column no. of zeros
try:
    z_ort_max
except NameError:
    z_ort_max = 1

#number of tries
try:
    num_ort_tries
except NameError:
    num_ort_tries = 1000

#number of tries
try:
    num_ort_mat
except NameError:
    num_ort_mat = 1000

#data file path
try:
    ort_file_path
except NameError:
    ort_file_path='../Data/'
    
#data file names
try:
    ort_matrix_file_name
except NameError:
    ort_matrix_file_name='orthogonal-'+str(ndim_ort)+'x'+str(ndim_ort)+'-Zmatrices-m'+str(ort_method)

try:
    ort_tuples_file_name
except NameError:
    ort_tuples_file_name='pythagorean-'+str(ndim_ort)+'-tuples'

try:
	ort_print_status
except NameError:
	ort_print_status=True

#--------------------------------------------------------------------------------
#generation of orthogonal matrices that correspond to distinct Pythagorean tuples

try:
    full_ort_matrix_path = ort_file_path+ort_matrix_file_name
    full_ort_tuples_path = ort_file_path+ort_tuples_file_name
    ort_mat_lst = load(full_ort_matrix_path)
    pit_tup_lst = load(full_ort_tuples_path)
except:
    ort_mat_lst = []
    pit_tup_lst = []

for num_ort_tries in range(num_ort_tries):

    if len(ort_mat_lst) >= num_ort_mat:
        break

    try:

        if ort_method == 'I':
            ort_mat = random_orthogonal_Zmatrix_I(ndim_ort, max_height = h_ort_max)
        elif ort_method == 'II':
            ort_mat = random_orthogonal_Zmatrix_II(ndim_ort, ndim_ort, max_height = h_ort_max)

    except:
        print('random_orthogonalZmatrix_'+str(ort_method)+'() exceeded try limit. Restarting on attempt no.'+str(num_ort_tries) + ' with ' + str(len(ort_mat_lst)) + ' classes of orthogonal matrices found so far!')
        continue

    if not accept_matrix(ort_mat, max_zeros=z_ort_max, max_height = h_ort_max, max_len2 = l2_ort_max):
        continue

   #update list of Pythagorean tuples
    if ort_method == 'I':
       update_lst(pit_tup_lst, Pythagorean_tuples(ort_mat))
       pit_tup_lst.sort()


    #find a representative with most positive entries and store it
    eqv_ort_mats = flip_and_permute(ort_mat)
    eqv_ort_mats.sort()
    rep_ort_mat = eqv_ort_mats[-1]
    if rep_ort_mat not in ort_mat_lst:
        ort_mat_lst.append(rep_ort_mat)
        ort_mat_lst.sort()
    	
save(ort_mat_lst, full_ort_matrix_path)
save(pit_tup_lst, full_ort_tuples_path)

if ort_print_status:
    if ort_method=='I':
        print(':::::::::::::::::::::::::')
        print('Pythagorean tuples found:\n')
        for tp in pit_tup_lst:
            print(tp)
    print(':::::::::::::::::::::::::')
    print('Orthogonal matrices found:\n')
    for mat in ort_mat_lst:
        print(mat)
        print('\n')