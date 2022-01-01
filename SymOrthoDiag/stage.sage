reset()

#the following parameters must be set-up before launching this script:

#number of rows and columns
ndim = 3

#rank bounds
rg = 3

#largest matrix elements
h_ort_max = 400
h_t_max = 100
h_max = 50

#bound for no. of zeros in row or column
z_ort_max = 1
z_max = 1

#maximal number of matrices
_mat_num = 1000

#number of tries
lim_tries = 1000

#starting id number
start_id = 1


#number of matrices
mat_num = 100

load('gensym.sage')
load('gendiag.sage')
load('genfiles.sage')

reset()
