reset()

load('../matrix_utils.sage')
load('../text_utils.sage')

#---------------------------------------------------------------------
#the following parameters must be set-up before launching this script:
#dimension

#number of rows and columns
num_rows = 3
num_cols = 3

#rank
rg = 3

#orthogonal matrix type
method='I'
    
#largest allowed matrix elements
h_ort_max = 11
h_t_max = 10
h_max = 20

#bound for no. of zeros in row or column of...
z_t_max = 0
z_max = 0

#maximal number of matrices
num_mat = 1000

#number of tries
num_tries = 10000

#data file location
data_path='../Data/'
data_name='gram-schmidt' 
full_data_path=data_path+data_name

#---------------------------------------------------------------------
#load generated data
try:
    gs_mat_data = load(full_data_path)
except:
    gs_mat_data = []

#print header with timestamp
print('------------------------ New data for %s ------------------------' % get_date_time())

#----------------------------------------------------------------------------------------
#generates the matrix of a specified rank with nice Gram-Schmidt reduction of row vectors

for attempts in range(num_tries):

    if len(gs_mat_data) > num_mat:
        break

    #choose random rank
    mat = random_GramSchmidt_Zmatrix(num_rows, num_cols, rg, h_max, z_max, h_ort_max, z_max, h_t_max, z_max, is_pr=True, ort_method=method)

    if mat in gs_mat_data:
    	continue
    
    gs_mat_data.append(mat)
    
    Q,L=nice_GramSchmidtZ(mat)
    print('̣̣===============')
    print('Q =')
    print(Q)
    print('L =')
    print(L)
    print('M =')
    print(mat, '\n')

gs_mat_data.sort() 
save(gs_mat_data, full_data_path)