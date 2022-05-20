import random as rnd

load('../matrix_utils.sage')
load('../text_utils.sage')

#the following parameters must be set-up before launching this script:
#dimension
ndim=2
#Jordan block structure
btypes = [[1]*(ndim-j)+[j] for j in range(1,ndim+1)]
#size of matrix elements
ev_max = 8
t_max = 9
h_max = 20
#admissible no. of zeros in row or column
zt_max = 0
z_max = 0
#maximal number of matrices
num_max = 1000
#number of tries
num_tries = 10000
#data file location
data_path='../Data/'
data_name = 'diagonalization-%sx%s' % (str(ndim), str(ndim))
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

#possible eigenvalues
evals = [ev for ev in range(-ev_max, ev_max+1) if abs(ev) > 1]

#no. of repetitions for inner and outer loops
num_att = ceil(sqrt(num_tries))

for btype in btypes:

    for attempt in range(ceil(num_att/len(btypes))):

        if len(mat_data) >= num_max:
            break
    #sample eigenvalues
        evs = sample_repl(evals, len(btype))
        shuffle(evs)
        try:
           mat = random_nice_jordan_Zmatrix(evs, btype, h_max, z_max, t_max, zt_max, num_att)
        except:
           continue
       
        if not accept_matrix(mat, max_height=h_max, max_zeros=z_max, is_prim=True):
    	    continue

        if mat not in mat_data:
            mat_data.append(mat)
            D,T=nice_eigenmatrix(mat)
            #printout
            print('=============')
            print('M =')
            print(mat)
            print('D =')
            print(D)
            print('T =')
            print(T)
        
mat_data.sort() 
save(mat_data, full_data_path)