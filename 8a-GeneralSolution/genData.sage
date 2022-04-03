reset()

load('../matrix_utils.sage')
load('../text_utils.sage')

#---------------------------------------------------------------------
#the following parameters must be set-up before launching this script:
#dimension 
num_rows = 4
num_cols = 4
#system rank
num_rank = 2
#largest element
h_max = 8
#bound for no. of zeros in row or column
z_max = 1
#number of matrices of each type
num_mat = 1000
#number of tries
num_tries = 10000
#data file location
data_path='../Data/'
data_name = 'general-solution'
full_data_path=data_path+data_name

#---------------------------------------------------------------------
#load generated data
try:
    mat_vec_data = load(full_data_path)
except:
    mat_vec_data = []

#print header with timestamp
print('------------------------ New data for %s ------------------------' % get_date_time())

#---------------------------------------------------------------------
for attempts in range(num_tries):

    if len(mat_vec_data) > num_mat:
        break

    mat = random_matrix(ZZ, num_rows, num_cols, rank=num_rank, algorithm='echelonizable', upper_bound=h_max)
	
    if not accept_matrix(mat, allow_colinear=False, has_ones_fc= True, max_zeros=z_max, max_height=h_max, is_prim=True):
        continue

    rvec = random_vector(ZZ, num_cols, x=-h_max//2 , y=h_max//2+1)
    bvec = mat*rvec
    
    if not accept_vector(bvec, h_max, z_max, is_prim=True):
        continue

    aug_mat = mat.augment(bvec)
    if not accept_matrix(aug_mat, allow_colinear=False):
        continue

    red = aug_mat.echelon_form()
    if not accept_matrix(red, max_height=h_max):
        continue

    tp = (mat, bvec)
    if tp in mat_vec_data:
        continue

    mat_vec_data.append(tp)

    print('A =', mat)
    print('b = ', bvec)
    print('rank =', mat.rank())
    print('\n')

mat_vec_data.sort() 
save(mat_vec_data, full_data_path)