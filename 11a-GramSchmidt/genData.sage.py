

# This file was *autogenerated* from the file genData.sage
from sage.all_cmdline import *   # import sage library

_sage_const_3 = Integer(3); _sage_const_2 = Integer(2); _sage_const_6 = Integer(6); _sage_const_8 = Integer(8); _sage_const_15 = Integer(15); _sage_const_0 = Integer(0); _sage_const_1000 = Integer(1000); _sage_const_10000 = Integer(10000)
reset()

load('../matrix_utils.sage')
load('../text_utils.sage')

#---------------------------------------------------------------------
#the following parameters must be set-up before launching this script:
#dimension

#number of rows and columns
num_rows = _sage_const_3 
num_cols = _sage_const_3 
ndim_ort = num_cols

#rank bounds
rg_min = _sage_const_2 
rg_max = _sage_const_3 

#orthogonal matrix type
ort_method='I'
    
#largest allowed matrix elements
h_ort_max = _sage_const_6 
h_t_max = _sage_const_8 
h_max = _sage_const_15 

#bound for no. of zeros in row or column of...
z_t_max = _sage_const_0 
z_max = _sage_const_0 

#maximal number of matrices
num_mat = _sage_const_1000 

#number of tries
num_tries = _sage_const_10000 

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

#abort if enough data
if len(gs_mat_data) > num_mat:
    exit()

#load orthogonal matrix data
try:
    load('../Common/genOrt.sage')
    ort_mat_data=[mat for mat in ort_mat_lst if accept_matrix(mat, max_height=h_ort_max, max_zeros=z_ort_max)]
except:
    ort_mat_data = []

num_omat = len(ort_mat_data)

#if  num_omat < num_ort_mat:
#    print('Not enough orthogonal matrices! Only ' + str(num_omat) + ' found!\n')
#    exit()

#print header with timestamp
print('------------------------ New data for %s ------------------------' % get_date_time())

#---------------------------------------------------------------------
#sample orthogonal matrices uniformly
num_req = ceil(num_mat/num_omat)
num_att = ceil(num_tries/num_omat)

#----------------------------------------------------------------------------------------
#generates the matrix of a specified rank with nice Gram-Schmidt reduction of row vectors
E = identity_matrix(QQ, num_cols);

for omat in ort_mat_lst:

    if len(gs_mat_data) > num_mat:
        break

    for attempts in range(num_att):

        #choose random rank
        rg = rnd.randint(rg_min, rg_max)

        try:
            T = random_ltdet1_Zmatrix(num_cols, h_t_max)
        except:
            print('random_ltdet1_Zmatrix exceeded the allowed number of tries. Restarting attempt no.'+ str(num_tries)+' with '+str(len(t_lst))+' matrices found so far.')
            T = None

        if T is None:
            continue

        if not accept_matrix(T + T.transpose()-E, max_zeros= z_t_max, max_height=h_t_max):
            continue

        k = min(num_rows, num_cols);

        #trim down T
        T = T.submatrix(_sage_const_0 , _sage_const_0 , nrows=num_rows, ncols=num_cols)

        #add vectors that will cancel out in Gram-Schmidt
        defects = rnd.sample(range(_sage_const_2 , k), k - rg)
        for df in defects:
            for col in range(min(rg, df), num_cols):
                T[df,col] = _sage_const_0 

        mat = T * omat
        if not accept_matrix(mat, max_zeros=z_max, max_height=h_max):
            continue

        if mat in gs_mat_data:
        	continue
        
        gs_mat_data.append(mat)
        print('̣̣===============')
        print('T =')
        print(T)
        print('Q =')
        print(omat)
        print('M =')
        print(mat, '\n')

        if len(gs_mat_data) > num_mat:
                break

gs_mat_data.sort() 
save(gs_mat_data, full_data_path)

