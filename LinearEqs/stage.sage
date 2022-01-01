reset()

#the following parameters must be set-up before launching this script:

#largest matrix element
h_max = 8

#bound for no. of zeros in row or column
z_max = 2

#number of rows and columns
num_rows = 4
num_cols = 4

#---------------------------------------
rank bounds
rg_min = 2
rg_max = 2

starting id number
start = 0


number of matrices
mat_num = 10

load('gensys.sage')
load('genfiles.sage')

#---------------------------------------
#rank bounds
rg_min = 3
rg_max = 3

#starting id number
start += mat_num 

#number of matrices
mat_num = 10

load('gensys.sage')
load('genfiles.sage')

#---------------------------------------
reset()
