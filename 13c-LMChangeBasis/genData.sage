reset()

load('../matrix_utils.sage')
load('../text_utils.sage')

#---------------------------------------------------------------------
#the following parameters must be set-up before launching this script:
#admissible dimensions 
ndim =2
#largest element
t_max = 9
f_max = 15
#bound for no. of zeros in row or column
z_max = 0
#number of matrices of each type
num_max = 1000
#number of tries
num_tries = 10000
#data file location
data_path='../Data/'
data_name = 'change-lm-basis-%sx%s' % (str(ndim), str(ndim))
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

    matT = random_matrix(ZZ, ndim, rank=ndim, algorithm='echelonizable', upper_bound=t_max)
    if not accept_matrix(matT, has_ones_fc=True, max_zeros=z_max, max_height=t_max, is_prim=True):
       continue

    invT = ~matT
    if not accept_matrix(invT, max_zeros = z_max, max_height= t_max, is_prim=True):
        continue
       
    oldF = random_matrix(ZZ, ndim, x=-f_max, y=f_max+1)

    if not accept_matrix(oldF, max_zeros=z_max, max_height=f_max, is_prim=True):
        continue

    newF = matT * oldF * invT
    if not accept_matrix(newF, max_zeros=z_max, max_height=f_max, is_prim=True):
        continue

    if ((matT, oldF) in mat_data) or ((-matT, oldF) in mat_data) or ((matT, -oldF) in mat_data) or ((-matT, -oldF) in mat_data):
        continue

    mat_data.append((matT, oldF))

    print('=======================')
    print('old F matrix =')
    print(oldF)
    print('T matrix =')
    print(matT)
    print('inverse T matrix =')
    print(invT)
    print('new F matrix =')
    print(newF)

save(mat_data, full_data_path)
