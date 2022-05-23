reset()

load('../matrix_utils.sage')
load('../text_utils.sage')

#---------------------------------------------------------------------
#the following parameters must be set-up before launching this script:
#admissible dimensions 
rows_min = 2
rows_max = 3
cols_min = 2
cols_max = 3
#largest element
h_max = 10
#bound for no. of zeros in row or column
z_max = 1
#number of matrices of each type
num_max = 1000
#number of tries
num_tries = 10000
#data file location
data_path='../Data/'
data_name = 'linmap-matrix'
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

    num_rows = randint(rows_min, rows_max)
    num_cols = randint(cols_min, cols_max)

    mat = random_matrix(ZZ, num_rows, num_cols, x=-h_max, y=h_max+1)

    if not accept_matrix(mat, max_zeros=z_max, max_height=h_max, is_prim=True):
        continue

    if (mat in mat_data) or (-mat in mat_data):
        continue

    mat_data.append(mat)

    print('=======================')
    print(mat)
    
save(mat_data, full_data_path)
