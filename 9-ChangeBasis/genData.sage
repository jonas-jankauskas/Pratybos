reset()

load('../matrix_utils.sage')
load('../text_utils.sage')

#---------------------------------------------------------------------
#the following parameters must be set-up before launching this script:
#dimension 
ndim = 3
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
data_name = 'change-basis'
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

    matA = random_matrix(ZZ, ndim, ndim, rank=ndim, algorithm='echelonizable', upper_bound=h_max)
	
    if not accept_matrix(matA, allow_colinear=False, has_ones_fc= True, max_zeros=z_max, max_height=h_max, is_prim=True):
        continue

    matB = random_matrix(ZZ, ndim, ndim, rank=ndim, algorithm='echelonizable', upper_bound=h_max)
	
    if not accept_matrix(matB, max_zeros=z_max, max_height=h_max, is_prim=True):
        continue

    matT = (matA.inverse())*matB

    if not accept_matrix(matT, max_zeros=z_max, max_height=h_max, is_prim=True):
        continue

    vec = random_vector(ZZ, ndim, x=-h_max//2 , y=h_max//2+1)
    
    if not accept_vector(vec, h_max, 0, is_prim=True):
        continue

    vecT = matT*vec

    if not accept_vector(vecT, h_max, z_max, is_prim=True):
        continue

    tp = (matA, matB, vec)
    
    if tp in mat_vec_data:
        continue

    mat_vec_data.append(tp)

    print('A=')
    print(matA)
    print('B =')
    print(matB)
    print('v = ', vec)
    print('\n')

mat_vec_data.sort() 
save(mat_vec_data, full_data_path)
