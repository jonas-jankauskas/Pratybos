import random as rnd

load('../matrix_utils.sage')
load('../text_utils.sage')

#the following parameters must be set-up before launching this script:
#number of rows and columns
ndim = 3
#rank bounds
rg = 2
#largest matrix elements
h_ort_max = 10
h_t_max = 10
h_max = 20
#bound for no. of zeros in row or column
z_ort_max = 1
z_t_max = 0
z_max = 0
#maximal number of vector-matrix pairs
num_max = 1000
#number of tries
num_tries = 10000
#data file location
data_path='../Data/'
data_name = 'orthogonal-projection'
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

num_att = ceil(sqrt(num_tries))
for attempt in range(num_att):

    if len(vec_mat_data) >= num_max:
        break

    gsmat = random_GramSchmidt_Zmatrix(ndim, ndim, ndim, h_max, z_max, h_ort_max, z_ort_max, h_t_max, z_t_max)
    omat, tmat = nice_GramSchmidtZ(gsmat)
    mat = gsmat[:rg]

    if not accept_matrix(mat, max_height=h_max, max_zeros=z_max, is_prim=True):
	    continue

    for attempt in range(num_att):

        if len(vec_mat_data) >= num_max:
            break

        rvec = random_vector(ZZ, ndim, -h_max, h_max)
        if not accept_vector(rvec, h_max, z_max, is_prim=True):
            continue
                
        vec = rvec * omat
        if not accept_vector(vec, h_max, z_max, is_prim=True):
            continue

        pvec = proj(vec, mat)
        if not accept_vector(pvec, h_max, z_max):
            continue

        ovec = orth(vec, mat)
        if not accept_vector(ovec, h_max, z_max):
            continue
            
        tp = (mat, vec)        
        if tp not in vec_mat_data:
            vec_mat_data.append(tp)

        #printout
        print('=============')
        print('M =')
        print(mat)
        print('v = ', vec, ' proj = ', pvec, ' ort = ', ovec, '\n')

vec_mat_data.sort() 
save(vec_mat_data, full_data_path)