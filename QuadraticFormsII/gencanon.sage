reset()

import random as rnd

load('../matrix_utils.sage')

#check if the list of matrices has been prepared
try:
    s_mat_lst = load('../Data/s_mat_lst')
    dq_mat_lst = load('../Data/dq_mat_lst')
except:
    s_mat_lst = []
    dq_mat_lst = []

try:
    ndim = s_mat_lst[0].nrows()
except NameError:
    ndim = 3

x_names = ['x'+ str(j+1) for j in range(ndim)]
y_names = ['y' + str(j+1)for j in range(ndim)]


x_str = ','.join(x_names)
y_str = ','.join(y_names)

var_str = x_str +',' + y_str

K = PolynomialRing(SR, 2*ndim, names=var_str)

x_vec = vector(K, ndim, K.gens()[:ndim])
y_vec = vector(K, ndim, K.gens()[ndim:])

F_lst = []
G_lst = []
eqs_lst = []


for nr, mat in enumerate(s_mat_lst):

    D, Q = dq_mat_lst[nr]

    f = QuadraticForm(mat+mat.transpose())
    F = f.polynomial(names=x_names)
    F_str = latex(F)

    g = QuadraticForm(D+D.transpose())
    G = g.polynomial(names=y_names)
    G_str = latex(G)

    lsub = y_vec*Q
    lsub_str = [latex(sb) for sb in lsub]
    eqs_str = [lsub_str[j] for j in range(ndim)]

    print('----------- Užd.'+ str(nr+1)+'. -----------------')    
    print('f('+x_str[:-1]+')='+F_str)
    print('ATS.:') 
    print('g('+y_str[:-1]+')='+G_str)
    print('\n'.join([eq for eq in eqs_str]))

    F_lst.append(F_str); G_lst.append(G_str); eqs_lst.append(eqs_str)
