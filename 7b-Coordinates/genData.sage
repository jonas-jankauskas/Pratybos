reset()

load('../matrix_utils.sage')
load('../text_utils.sage')

#---------------------------------------------------------------------
#the following parameters must be set-up before launching this script:
#dimension 
ndim = 3
#largest element
h_max = 10
#bound for no. of zeros in row or column
z_max = 1
#number of matrices of each type
num_mat = 1000
#number of tries
num_tries = 10000
#data file location
data_path='../Data/'
data_name = 'vector-coordinates'
full_data_path=data_path+data_name

#---------------------------------------------------------------------
#load generated data
try:
    vec_mat_data = load(full_data_path)
except:
    vec_mat_data = []

#print header with timestamp
print('------------------------ New data for %s ------------------------' % get_date_time())

#---------------------------------------------------------------------

for attempts in range(num_tries):

    if len(vec_mat_data) > num_mat:
        break

    mat = random_matrix(ZZ, ndim, ndim, rank=ndim, algorithm='echelonizable', upper_bound=h_max)

    if not accept_matrix(mat.T, has_ones_fc= True, max_zeros=z_max, max_height=h_max, is_prim=True):
        continue

    mat_inv = mat.inverse()
    if not accept_matrix(mat_inv, max_zeros=z_max, max_height=h_max, is_prim=True):
        continue

    xVec = random_vector(ZZ, 3, x=-h_max,y=h_max+1)

    if not accept_vector(xVec, h_max,z_max, is_prim=True):
        continue

    yVec = xVec*mat

    if not accept_vector(yVec, h_max,z_max, is_prim=True):
        continue

    if ((yVec, mat) in vec_mat_data) or ((yVec, -mat) in vec_mat_data) or ((-yVec, mat) in vec_mat_data) or ((-yVec, -mat) in vec_mat_data):
        continue

    vec_mat_data.append((yVec, mat))

    print('vec=', yVec)
    print('mat=')
    print(mat)
 
save(vec_mat_data, full_data_path)