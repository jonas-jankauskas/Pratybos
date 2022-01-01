reset()
#----------------------------------------
#set-up script parameters
#largest matrix element (default value)
h_max = 8
#bound for no. of zeros in row or column
z_max = 2

#number of rows and columns
ndim = 3
#rank
rg = 3

#starting id number
start = 0


#number of matrices
mat_num = 20

#----------------------------------------
load('genmat.sage')

load('genfiles.sage')

#----------------------------------------
#cleanup
reset()
