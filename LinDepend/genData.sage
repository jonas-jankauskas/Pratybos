reset()

load('../matrix_utils.sage')
load('../text_utils.sage')

#---------------------------------------------------------------------
#the following parameters must be set-up before launching this script:
#number and dimension  of vectors 
dim_vec = 3
#largest coordinate
h_max = 5
#bound for no. of zeros in row or column
z_max = 1
#number of matrices of each type
num_sys = 100
#number of tries
num_tries = 10000
#data file location
data_path='../Data/'
data_name = 'lin-depend'
full_data_path=data_path+data_name

#---------------------------------------------------------------------
#Lambda parameter
l = var('l', latex_name='\\lambda')

#load generated data
try:
    vec_data = load(full_data_path)
except:
    vec_data = []

#print header with timestamp
print('------------------------ New data for %s ------------------------' % get_date_time())

#---------------------------------------------------------------------
#make examples

for attempts in range(num_tries):

	if len(vec_data) > num_sys:
		break

	mat = random_matrix(ZZ, dim_vec, dim_vec, x=-h_max,y=h_max+1)

	#skip if matrix too easy
	if not accept_matrix(mat, allow_colinear= False, has_ones_fc= True, max_zeros=z_max, max_height=h_max, is_prim=True):
		continue
		
	#skip if rank is too low	
	if mat.rank() < dim_vec -1:
		continue
		
	#get adjugate; skip if too large
	mat_adj = mat.adjugate().T
	if mat_adj.height() > 2*h_max:
		continue
		
	#where minors != 0
	good_rc =[(i,j) for i in range(mat.nrows()) for j in range(mat.ncols()) if mat_adj[i,j] != 0]
	r,c = choice(good_rc)
	
	#change the good entry to a parameter
	new_mat=mat.change_ring(SR)
	new_mat[r,c]=l

	vec_sys = new_mat.rows()
	if (vec_sys in vec_data):
		continue
		
	vec_data.append(vec_sys)
	print(vec_sys)
		        
save(vec_data, full_data_path)