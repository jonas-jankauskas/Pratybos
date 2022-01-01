import random as rnd

load('../matrix_utils.sage')

#-----------------------------------------------------------------------------
#the following parameters must be set-up before launching this script:
#matrix dimensions
try:
    ndim
except NameError:
    ndim = 3

#rank of th restricted subspace
try:
    rg
except NameError:
    rg = 3

   
#largest allowed matrix elements

try:
    h_t_max
except NameError:
    h_t_max = 100

try:
    h_ort_max
except NameError:
    h_ort_max = 400


try:
    h_max
except NameError:
    h_max = 50

try:
    len2_ort_max
except NameError:
    len2_ort_max = 400

try:
    len2_max
except NameError:
    len2_max = 400

#bound for no. of zeros in row or column of...
try:
    z_ort_max
except NameError:
    z_ort_max = 1

try:
    z_max
except NameError:
    z_max = 1

#maximal number of matrices
try:
    mat_num
except NameError:
    mat_num = 1000


#number of tries
try:
    lim_tries
except NameError:
    lim_tries = 1000


#Data file name
try:
    sym_mat_file_name
except NameError:
    sym_mat_file_name = '../Data/sym_mat '+str(ndim)+'x'+str(ndim)+' '+'rg '+str(rg)+'.dat'

#--------------------------------------------------------------------------------
#generation of orthogonal vector sets

t_mat_lst = []
ort_mat_lst = []
sym_mat_lst = []

try:
    t_mat_lst = load('../Data/t_mat_lst')
except Exception:
    t_mat_lst = []

try:
    ort_mat_lst = load('../Data/ort_mat_lst')
except Exception:
    ort_mat_lst = []

try:
    sym_mat_lst = load('../Data/sym_mat_lst')
except Exception:
    sym_mat_lst = []

try:
    sym_mat_unique = load('../Data/sym_mat_unique')
except Exception:
    sym_mat_unique = {}


E = identity_matrix(QQ, ndim)

for num_tries in range(lim_tries):

    t_mat = random_matrix(ZZ, rg, ndim, x = -h_t_max, y=h_t_max)
    ort_mat, rel_mat = nice_GramSchmidtZ(t_mat)

    if not accept_matrix(ort_mat, allow_colinear=True,  max_zeros=z_ort_max, max_height = h_ort_max, max_len2 = len2_ort_max):
        continue
            
    lens2 = [rw * rw for rw in ort_mat.rows()]
    lens2.sort()

    #mid = (lens2[0]+lens2[-1])//2
    mid = lens2[len(lens2)//2]
    
    tau = 1
    #tau = mid
    if 2*rg > ndim:
       if lens2[-1] + lens2[0] > 2*mid:
          mid +=2
       mid -= 1
       tau = mid

    sym_mat = ort_mat.transpose()*ort_mat - tau*E 

    if not accept_matrix(sym_mat, max_zeros=z_max, max_height = h_max, max_len2 = len2_max):
        continue

    if sym_mat in sym_mat_lst:
        continue

    evs = sym_mat.eigenmatrix_left()[0].diagonal()
    evs.sort()
    sig = tuple(evs)
    

    if t_mat not in t_mat_lst:
        t_mat_lst.append(t_mat)
        
    if ort_mat not in ort_mat_lst:
        ort_mat_lst.append(ort_mat)

    if sym_mat not in sym_mat_lst:
        sym_mat_lst.append(sym_mat)

    if sig in sym_mat_unique.keys():
        if sym_mat not in sym_mat_unique[sig]:
            sym_mat_unique[sig].append(sym_mat)
    else:
        sym_mat_unique[sig]=[sym_mat]

    if len(sym_mat_lst) >= mat_num:
        break

for j in range(len(sym_mat_lst)):
    print('+++++++++++++++')
    print('T=')
    print(t_mat_lst[j])
    print('Q=')
    print(ort_mat_lst[j])
    print('S=')
    print(sym_mat_lst[j])

for tp in sym_mat_unique.keys():
    print('===================')
    print(tp)
    print('+++++++++++++++++++')
    for mat in sym_mat_unique[tp]:
        print(mat)
        print('-------------------')


for tp in sym_mat_unique.keys():
    for mat in sym_mat_unique[tp]:
        while sym_mat_unique[tp].count(mat) > 1:
            sym_mat_unique[tp].remove(mat)
            

save(t_mat_lst, '../Data/t_mat_lst')
save(ort_mat_lst, '../Data/ort_mat_lst')
save(sym_mat_lst, '../Data/sym_mat_lst')
save(sym_mat_unique, '../Data/sym_mat_unique')
