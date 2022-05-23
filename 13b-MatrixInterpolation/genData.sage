reset()

load('../matrix_utils.sage')
load('../text_utils.sage')

#---------------------------------------------------------------------
#the following parameters must be set-up before launching this script:
#admissible dimensions 
ndim =3
#largest element
v_max = 9
w_max = 9
f_max = 15
#bound for no. of zeros in row or column
z_max = 1
#number of matrices of each type
num_max = 1000
#number of tries
num_tries = 10000
#data file location
data_path='../Data/'
data_name = 'matrix-interpolation-%sx%s' % (str(ndim), str(ndim))
full_data_path=data_path+data_name

#---------------------------------------------------------------------
#load generated data
try:
    mat_data = load(full_data_path)
except:
    mat_data = []

#print header with timestamp
print('------------------------ New data for %s ------------------------' % get_date_time())

#---------------------------------------------------------------------

for attempts in range(num_tries):

    if len(mat_data) > num_max:
        break

    matV = random_matrix(ZZ, ndim, rank=ndim, algorithm='echelonizable', upper_bound=v_max)

    if not accept_matrix(matV, has_ones_fc=True, max_zeros=z_max, max_height=v_max, is_prim=True):
       continue
       
    matW = random_matrix(ZZ, ndim, x=-w_max, y=w_max+1)

    if not accept_matrix(matW, max_zeros=z_max, max_height=w_max, is_prim=True):
        continue

    matF = (~matV)*matW

    if not accept_matrix(matF, max_zeros = z_max, max_height= f_max, is_prim=True):
        continue

    if ((matV, matW) in mat_data) or ((-matV, matW) in mat_data) or ((matV, -matW) in mat_data) or ((-matV, -matW) in mat_data):
        continue

    mat_data.append((matV, matW))

    print('=======================')
    print('v vectors = ', matV.rows())
    print('w vectors = ', matW.rows())
    print('F matrix =')
    print(matF)
    
save(mat_data, full_data_path)
