reset()

#the following parameters must be set-up before launching this script:

#number of rows and columns
num_rows = 4
num_cols = 4


#rank bounds
rg_min = 3
rg_max = 3

#largest matrix elements
h_ort_max = 10
h_t_max = 10
h_max = 20

#bound for no. of zeros in row or column
z_ort_max = 1
z_t_max = 0
z_max = 1

#maximal number of matrices
ort_mat_num = 5
t_mat_num = 10

#number of tries
lim_tries = 10000

#starting id number
start_id = 20


#number of matrices
mat_num = 10

load('gengs1.sage')
load('gengs2.sage')
load('genfiles.sage')

reset()
