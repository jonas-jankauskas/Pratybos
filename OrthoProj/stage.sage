reset()

#the following parameters must be set-up before launching this script:

#number of rows and columns
num_rows = 2
num_cols = 3


#largest matrix elements
h_ort_max = 20
h_t_max = 10
h_max = 20

#bound for no. of zeros in row or column
z_ort_max = 0
z_t_max = 0
z_max = 0

#maximal number of matrices
ort_mat_num = 20
t_mat_num = 20

#number of tries
lim_tries = 1000

#starting id number
start = 1


#number of matrices
mat_num = 10

load('genop1.sage')
load('genfiles.sage')

reset()
