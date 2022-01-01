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
    sizes
except NameError:
    sizes = [1, 2]

   
#largest allowed matrix elements

try:
    h_max
except NameError:
    h_max = 10

try:
    z_max
except NameError:
    z_max = 1

try:
    lim_tries
except NameError:
    lim_tries = 1000

try:
    mat_num
except NameError:
    mat_num = 8

try:
    mat_lst = load('../Data/jordan-form-3x3_3')
except:
    mat_lst = []

#--------------------------------------------------------------------------------
#generation of Jordan form

for attempt in range(lim_tries):
    T = random_matrix(ZZ, ndim, ndim, rank=ndim, algorithm='echelonizable', upper_bound=h_max)
    if not accept_matrix(T, max_zeros= z_max):
        continue
    ev = rnd.choice([ -2, -1, 1, 2])
    J1 = jordan_block(ev, 1)
    J2 = jordan_block(ev, 2)
    Jo = jordan_block(ev, 3)
    A = T*Jo*(~T)
    if not accept_matrix(A, max_zeros= z_max, max_height=h_max):
        continue
    if A not in [trp[0] for trp in mat_lst]:
        mat_lst.append((A, Jo, T))
    if len(mat_lst) > mat_num:
        break 

save(mat_lst, '../Data/jordan-form-3x3_3')
