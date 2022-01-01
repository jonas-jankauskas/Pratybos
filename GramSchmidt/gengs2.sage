import random as rnd

load('../matrix_utils.sage')

#check if the list of matrices has been prepared

def get_eqs(M, L):

    '''
        Writes down equation expressions for row vectors v1, v2, ...,  of M as linear expressions of u1, u2, ..., specified by rows of L.
    '''

    m = L.nrows(); n = L.ncols()

    u_str = ['u'+ str(j+1) +',' for j in range(m)]
    v_str = ['v' + str(j+1) + ',' for j in range(n)]
    var_str = (str().join(u_str+v_str))[:-1]
    
    R = PolynomialRing(QQ, m+n, names=var_str)
    v = vector(R, R.ngens(), R.gens())
    N=identity_matrix(R, m).augment(-lt_part(L))
    eqs_vec = N*v
    
    return [latex(R.gens()[m+j])+ ' = ' + latex(M.rows()[j])+ ' \sim ' + latex(eqs_vec[j]) for j in range(n)]

eqs = []

for vr, M in enumerate(mat_lst):
    
	Q, L = nice_GramSchmidtZ(M)
	 
	eqs.append(get_eqs(Q, L))
	print('----------- Užd.'+ str(vr+1)+'. -----------------')    
	for i, rw in enumerate(M.rows()):
		print('u_{'+str(i+1)+ '}='+str(rw))
	
	print('ATS.:')    
	for eq in eqs[-1]:
		print(eq)
