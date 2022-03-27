reset()

load('../matrix_utils.sage')
load('../text_utils.sage')

#---------------------------------------------------------------------
#the following parameters must be set-up before launching this script:
#number of rows, columns and rank of as list of tuples (nrows, ncols, rank) 
matrix_types = [(3,4,3), (3,4,2)]
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
data_name = 'linear-span'
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

	if len(mat_data) > num_mat:
		break

	num_rows, num_cols, rg = choice(matrix_types)
	mat = random_matrix(ZZ, num_rows, num_cols, rank=rg, algorithm='echelonizable', upper_bound=h_max)

	if not accept_matrix(mat, allow_colinear= False, has_ones_fc= True, max_zeros=z_max, max_height=h_max, is_prim=True):
		continue

	#vec is spanned by other rows when rank(mat)=2 and is linearly independent when rank(mat)=3, because mat has no parallel rows. 
	if (mat in mat_data) or (-mat in mat_data):
		continue

	mat_data.append(mat)
	
	print('rank=', mat.rank())
	print(mat)
		        
save(mat_data, full_data_path)