load('matrix_utils.sage')

#-----------------------------------------------------------------------------
#the following parameters must be set-up before launching this script:

#number of rows and columns
try:
    ndim
except NameError:
    ndim = 2

#bound on the largest entry size
try:
    h_max
except NameError:
    h_max = 100

#bound for no. of zeros in row or column of...
try:
    z_max
except NameError:
    z_max = 1

#data file path
try:
    file_path
except NameError:
    file_path='Data/'
    
#data file names
try:
    file_name
except NameError:
    file_name='nice-sym-' + str(ndim)+'x'+str(ndim)+'-Zmatrices'


#----------------------------------------------------------------------------------------------
#generation of integral matrices whose singular values are integral or square roots of integers

try:
    full_path = file_path+file_name
    mat_dict = load(full_path)
except:
    mat_dict = {}

E = identity_matrix(ndim)
u = vector(E.diagonal())

for tpl in itt.product(range(-h_max, h_max+1), repeat=ndim*(ndim+1)//2):

    #if (tpl[0] > 0):
    #    break

    #build rows of a symetric matrix from
    rws = []; k=0
    for i, j in enumerate(range(ndim,0,-1)):
        rws += [[0]*i+list(tpl[k:k+j])]
        k += j
    A = matrix(ndim, rws)
    A += lt_part(A.T)
    
    evs = A.eigenvalues();
    evs.sort();
    evs = vector(evs);

    int_evs = True
    for ev in evs:
        int_evs = int_evs and (ev in ZZ)

    if not int_evs:
        continue

    mid = evs[ndim//2]
    A -= mid*E 
    evs -= mid*u 

    a = gcd(A.list())
    if a != 0:
        A = A/a
        evs =1/a*evs

    if accept_matrix(A, allow_colinear=True, max_zeros = z_max, max_height=h_max):
        update_dict_lst(mat_dict, tuple(evs), [A])

save(sort_dict(mat_dict), full_path)
