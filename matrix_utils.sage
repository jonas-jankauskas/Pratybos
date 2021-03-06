import itertools as itt
import random as rnd


#---------------------------------------------------------------------
def num_div(n):
	'''
		Returns a number of divisors of n
	'''
	if n != 0:
		return number_of_divisors(n)
	else:
		return +oo
#---------------------------------------------------------------------
def prime_factors(n):
	'''
		Returns a list of all prime factors of integer n
	'''
	if n != 0:
		return [tp[0] for tp in list(factor(n))]
	else:
		return []
#---------------------------------------------------------------------
def largest_prime_factor(n):
	'''
		Returns the largest prime factor of integer n
	'''
	if (abs(n)>1):
		return max(prime_factors(n))
	elif n != 0:
		return 0
	else:
		return +oo

#---------------------------------------------------------------------
def rfunc_to_cfrac(R):
	'''
		Returns the list of partial quotients for the continued fraction expansion of the rational function f=P/Q
	'''
	P = R.numerator()
	Q = R.denominator()

	cfr_lst = []

	while (Q != 0):
		S, R = P.quo_rem(Q)
		cfr_lst.append(S)
		P, Q = Q, R

	return(cfr_lst)

#---------------------------------------------------------------------
def cfrac_to_rfun(cfr_lst):
	'''
		Returns the rational function f=P/Q provided its continued fraction expansion lst
	'''
	P = cfr_lst[-1]
	for Q in reversed(cfr_lst[:-1]):
		P = 1/P + Q
	return P

#---------------------------------------------------------------------
def sign_complex(num):
    '''
        Given the complex number num=a+b*i, returns the sign of re(num)=a if a !=0; otherwise returns the sign of img(num)=b
    '''
    t = real(num)
    if t == 0:
        t = imag(num) 
    return(sign(t))
	
#---------------------------------------------------------------------
def vec_cden(v):
    ''' LCM of denominators of vector v coordinates'''
    return lcm([fr.denominator() for fr in v])

#---------------------------------------------------------------------
def vec_cnum(v):
    ''' GCD of numerators of vector v coordinates'''
    return gcd([fr.numerator() for fr in v])

#---------------------------------------------------------------------
def vec_cfactor(v):
    '''rational fraction a/b, such that coordinates of a/b*v are coprime and integral'''
    vcn = vec_cnum(v)
    if vcn == 0:
        vcn = 1
    return vec_cden(v)/vcn

#---------------------------------------------------------------------
def vec_nice(v):
    '''
        Produces a scalar multiple c*v of a rational vector v, such that:
        
        -- the coordinates of c*v are integers with gcd=1
        
        -- the first non zero coordinate of c*v is positive
    '''
    vec = vec_cfactor(v)*v
    vec *= vec_fsgn(vec)
    return(vec)

#---------------------------------------------------------------------
def vec_index(vec):
    '''
        Returns numbers of positive, negative and zero entries of vec
    '''
    cds = [sign(c) for c in vec]
    pos_idx = cds.count(1)
    neg_idx = cds.count(-1)
    nul_idx = len(vec)-pos_idx-neg_idx
    return pos_idx, neg_idx, nul_idx 
#---------------------------------------------------------------------
def vec_signature(vec):
    '''
        Returns signature of vec = no. of positive entries -  no. of negative entries
    '''
    p, q, r = vec_index(vec) 
    return p - q

#---------------------------------------------------------------------
def vec_rank(vec):
    '''
        Returns no. of non-zero entries of vec
    ''' 
    p,q,r=vec_index(vec)
    return p+q

#---------------------------------------------------------------------
def vec_snza(vec):
    '''
        Returns absolute value of a smallest non-zero entry of vec
    ''' 
    nza = [abs(c) for c in vec if c !=0]
    snza =0
    if len(nza) > 0:
       snza = min(nza)
    return snza

#---------------------------------------------------------------------
def vec_fnz(vec):
    '''
        Returns first non-zero entry of vec or zero if no such entry exists
    ''' 
    nz = [c for c in vec if c !=0]
    if len(nz) > 0:
       return  nz[0]
    else:
       return 0

#---------------------------------------------------------------------
def vec_fsgn(vec):
    '''
        Returns sign of first non-zero entry or zero if no such entry exists
    '''    
    return sign_complex(vec_fnz(vec))

#---------------------------------------------------------------------
def vec_fnzi(vec):
    '''
        Returns the position of the first non-zero entry of vec or +oo if no such entry exists
    ''' 
    for j, c in enumerate(vec):
        if c != 0:
            return j
    return +oo

#---------------------------------------------------------------------
def accept_vector(vec, max_height=10000, max_zeros=10000, is_prim=False):
    '''
        Tests if vector properties are within limits 
    ''' 
    if vec.norm(+oo)> max_height:
        return False

    if vec.list().count(0) > max_zeros:
        return False

    if is_prim and abs(gcd(vec)) != 1:
        return False

    return True

#---------------------------------------------------------------------
def mat_cfactor(mat):
    '''diagonal matrix D, such that D*mat has rows with all coordinates coprime and integral'''
    return diagonal_matrix(vec_cfactor(rw) for rw in mat.rows())

#---------------------------------------------------------------------
def make_primitive(mat):
    '''Returns a version of  math such that gcd of its entries in each row and column are = 1'''
    scaleRows = mat_cfactor(mat)*mat
    scaleCols = scaleRows*(mat_cfactor(scaleRows.T).T)
    return scaleCols

#---------------------------------------------------------------------
def make_primitive_sym(mat):
    '''Returns a primitive scaled version of  math (gcd of its entries are = 1). If mat is symmetric, then results is still symmetric'''
    cfact = gcd(mat.list())
    if cfact != 0:
        return mat/cfact
    return mat
#---------------------------------------------------------------------
def mat_cden(M):
    ''' LCM of denominators of vector v coordinates'''
    return lcm([fr.denominator() for rw in M.rows() for fr in rw])

#---------------------------------------------------------------------
def lt_part(M):
    '''Lower triangular part of a matrix M, without the principal  diagonal'''
    N = zero_matrix(M.base_ring(), M.nrows(), M.ncols())
    for i in range(M.nrows()):
        N[i,:i] = M[i,:i]
    return N

#---------------------------------------------------------------------
def ut_part(M):
    '''Upper triangular part of a matrix M, together with its principal diagonal'''
    N = zero_matrix(M.base_ring(), M.nrows(), M.ncols())
    for i in range(M.nrows()):
        N[i, i:] = M[i, i:]
    return N

#---------------------------------------------------------------------
def skew_up(M):
    '''Skew-symmetric matrix by reflection of the upper triangular part of M'''
    up = ut_part(M)
    return (up - up.transpose())

#---------------------------------------------------------------------
def skew_down(M):
    '''Skew-symmetric matrix by reflection of the lower triangular part of M'''
    down = lt_part(M)
    return(down - down.transpose())

#---------------------------------------------------------------------
def find_lead_cols(M):
    '''
        Returns the list containing the first non-zero position in each non-zero row of M
    '''
    S = set()
    for r in M.rows():
        c = vec_fnzi(r)
        if c < +oo:
            S.add(c)
    lst = list(S)
    lst.sort()
    return(lst)

#---------------------------------------------------------------------
def find_free_cols(M):
    '''
        Returns the list containing the positions of free (non-leading) columns of M
    '''
    lcols = find_lead_cols(M)
    fcols = [j for j in range(M.ncols()) if j not in lcols] 
    return fcols

#---------------------------------------------------------------------
def standard_solution_SLE(A, b):
    '''
        For a given matrix A and a vector b, returns the standard solution to A*x=b as tuple

        (p, [h_1,..., h_n])

        where:

        p -- a particular solution corresponding to the zero values of free variables in RREF of A; p=None if A*x=b has no solution.
        
        [h_1, ..., h_n] -- a list containing standard basis of homogenous solutions A*x=O, namely: k-th homegenous solution h_k is obtained by setting the k-th free variable of x to 1 and all other free variables to 0.
    '''
    if len(b) != A.nrows():
        raise Exception("Column b does not match rows of A!")
    mat = A.augment(b)
    rmat = mat.rref()
    rrmat = rmat[:,:-1]
    lvars = find_lead_cols(rrmat)
    fvars = find_free_cols(rrmat)
    R = rrmat.base_ring()
    nc = A.ncols()
    #particular solution
    p=zero_vector(R, nc)
    for j in range(len(lvars)):
    	p[lvars[j]]=rmat.column(-1)[j]
    if A*p != b:
        p = None
    #homogenous solutions
    hsols = []
    for i in fvars:
        hsol=zero_vector(R, nc)
        for j in range(len(lvars)):
            hsol[lvars[j]]=-rrmat.column(i)[j]
            hsol[i]=1
        hsols+=[hsol]
    return p, hsols

#---------------------------------------------------------------------
def nice_solution_SLE(A, b):
    '''
        For a given rational matrix A and a rational vector b, returns the standard solution to A*x=b as tuple

        (p, [h_1,..., h_n])

        where:

        p -- a particular solution corresponding to the zero values of free variables in RREF of A; p is empty vector p=() if A*x=b has no sulution
        
        [h_1, ..., h_n] -- a list containing standard basis of homogenous solutions A*x=O, namely: k-th homegenous solution h_k is obtained by setting all but  k-th free variables to zero. Homogenous solutions are normalized so that that each h_k has integer coordinates with gcd=1 and first non-zero coordinate is  positive.
    '''

    p, hsols = standard_solution_SLE(A, b)
    nsols = [vec_nice(h) for h in hsols]
    return p, nsols

#---------------------------------------------------------------------
def solution_LSQ(A, b):
    '''
        For a given rational matrix A and a rational vector b, finds a general solution to minimization problem min||A*x-b||.
        The solution is returned in the same form as nice_solution_SLE()
    '''
    return nice_solution_SLE((A.transpose())*A, (A.transpose())*b)

#---------------------------------------------------------------------
def proj(v, A):
    '''
        For a given rational row-vector v and a rational matrix A, returns the orthogonal projection of v in to row space of A.
    '''
    p = solution_LSQ(A.T, v)[0]
    return p*A

#---------------------------------------------------------------------
def orth(v, A):
    '''
        For a given rational row-vector v and a rational matrix A, returns the normal of v to the row space of A.
    '''
    return v-proj(v,A)

#---------------------------------------------------------------------
def nice_kernel(mat):
    '''
        Returns the list

        [v_1, v_2, ..., v_k]

        containing basis of a left-kernel of a matrix mat, i.e. the set of row-vectors v, such that v*mat=O.
        Each v_j is normalized so that its non-zero entries are integers with gcd = 1, and the first non-zero entry (if any) is > 0.
    '''

    p,h=nice_solution_SLE(mat.T,zero_vector(mat.nrows()))

    return h

#---------------------------------------------------------------------
def nice_eigenvalues(mat):
    '''
        Returns the list of eigenvalues of matrix mat that belong to QQ or QQ(I), I^2=-1. If mat has other irrational eigevalues, an exception is raised.
    '''
    evs =[]
    for ev in mat.eigenvalues():
        if ev in QQ:
            nv = ev
        else:
            try:
                nv = QQ(real(ev))+I*QQ(imag(ev))
            except:
                raise Exception('Cannot cast eigenvalue'+srt(ev)+' to QQ(I)!!!')
        evs.append(nv)
    evs.sort(reverse=True)
    return evs

#---------------------------------------------------------------------
def nice_eigenvectors(mat):
    '''
        For the matrix mat, returns the list of triples

        (ev, [v_1, v_2, ..., v_k], m)

        where ev is an eigenvalue of mat that belongs to field QQ(I), m is algenraic multiplicity of ev,  and v_1, ... ,v_k is are the basis of left-eigenspave of ev, i.e. the set of row-vectors v, such that v*mat=ev*mat.
        Each v_j is normalized so that its non-zero entries are integers with gcd = 1, and the first non-zero entry (if any) is > 0.
    '''
    E = identity_matrix(mat.base_ring(), mat.nrows())
    evecs = []
    evs = nice_eigenvalues(mat)
    dvs = set(evs)
    for ev in dvs:
        M = mat - ev*E
        evecs += [(ev, nice_kernel(M), evs.count(ev))]
    evecs.sort(key=lambda el: el[0], reverse=True)
    return evecs

#---------------------------------------------------------------------
def nice_eigenmatrix(mat):
    '''
        returns the pair (D, T) where:

            D is diagonal matrix whose entries on the main diagonal are eigenvalues of matrix mat. Eigenvalues are sorted in descending order; each eigenvalue appears the number of times equal to its algebraic multiplicity.

            T is matrix whose rows are basis vectors for the left eigenspace of eigenvalue of mat that appears on the same row in D, or a zero vector. Row vectors are normalized so that their entries are integers; non-zero entries of a row have gcd = 1, and first non-zero entry in the row  is > 0.

        In particular, if mat is diagonalizable, then T*mat*T.inverse()=D.
    '''
    dlst = []
    rvec = []
    zv = zero_vector(mat.ncols())
    evm = nice_eigenvectors(mat)
    for ev, evecs, mult in evm:
        dlst += [ev]*mult
        rvec += evecs + [zv]*(mult-len(evecs))
    D = diagonal_matrix(dlst)
    T = matrix(len(rvec), rvec)
    return D,T

#---------------------------------------------------------------------
def jordan_matrix(eigenvals = [], bsizes = []):
    '''
        Given lists of eigenvalues

        [ev1, ev2, ..., evk]

        and block sizes

        [s1, s2, .., sl]

        returns m x m Jordan matrix

         J = J_s1(ev1) x J_s2(ev2) x ... J_sm(evm),    m = min(k, l)
    '''
    lst = list(zip(eigenvals, bsizes))
    mats = []
    for ev, sz in lst:
        mats +=[jordan_block(ev,sz)]
        
    return block_diagonal_matrix(mats)

#---------------------------------------------------------------------
def random_nice_jordan_Zmatrix(evals, bsizes, max_h=100, max_z=1, max_t =10, max_tz=1, num_tries=10000):
    '''
        Given lists of eigenvalues

        evals=[ev1, ev2, ..., evk]

        and block sizes

        bsizes=[s1, s2, .., sl]

        attempts to generate a random returns m x m M, such that, for some integer matrix T with det(T)= +/-1, M has the Jordan form

        T*M*T.inverse() = J_s1(ev1) x J_s2(ev2) x ... J_sm(evm),    m = min(k, l),

       subject to contraints on the height and number of zero entries in matrices M and T.
    '''
    J = jordan_matrix(evals, bsizes)
    ndim = J.nrows()
    
    for attempt in range(num_tries):

       T = random_matrix(ZZ, ndim, rank=ndim, algorithm='echelonizable', upper_bound=max_t)
       if not accept_matrix(T, max_zeros=max_tz, max_height=max_t, is_prim=True):
           continue
       M = T.inverse()*J*T
       if accept_matrix(M, max_height=max_h, max_zeros=max_z, is_prim=True):
           return M

    raise Exception('Could not find suitable matrix with these parameters!')
    
#---------------------------------------------------------------------
def random_ltdet1_Zmatrix(ndim, max_height):
    ''' Returns square random lower triangular integer matrix of the size ndim x ndim  with entries in a given ring (=ZZ by default) of height at most max_height (=100 by default)  and all 1's on the principal diagonal'''
    return lt_part(random_matrix(ZZ, ndim, ndim, x=-max_height, y=max_height+1))+identity_matrix(ZZ, ndim)

#---------------------------------------------------------------------
def random_orthogonal_Qmatrix(ndim, max_height=100, max_tries = 10000):
    '''
        Attempts to generate random orthogonal ndim x ndim matrix with rational entries whose numerators and denominators does not exceed max_height (=10000 by default). If it does not succeed after max_tries (= 1000 by default) attempts, an exception is raised.
    '''

    #Bounds on the number of tries, if not specified
    #if max_tries is None:
    #    max_tries = ceil((2*max_height+1)**(ndim/2))

    #Limit the size of the search space so that the number of tries is within square root of (2*height(M)+1)^(n^2) 
    max_bound = 3*ceil((max_tries**(2/(ndim**2))).n())

    if max_height < max_bound:
        max_bound = max_height
    
        
    for attempt in range(max_tries):
        M = random_matrix(QQ, ndim, ndim, num_bound = max_bound, den_bound = max_bound)
        E = identity_matrix(QQ, ndim)
        S = skew_up(M)
        Q = (E+S).inverse()*(E-S)
        if Q.height() <= max_height:
        	return Q
       #normalization to non-negative diagonal
       # dsgn = [sign(el) for el in T.diagonal()]
       # for n, it in enumerate(dsgn):
       #     if it == 0:
       #         dsgn[n] = 1
       # D = diagonal_matrix(QQ, ndim, dsgn);        
       # if T.height() < max_height:
       #     return D*T
    raise Exception('Number of tries exceeded!')

#---------------------------------------------------------------------
def random_orthogonal_Zmatrix_I(ndim, max_height=100, num_tries = 10000):
    '''
            Attempts to generate random orthogonal ndim x ndim matrix with integer entries not exceeding max_height (= 100 by default) in absolute value and normalizes it so that main diagonal elements are >= 0. If it does not succeed after max_tries (= 1000 by default) number of attempts, an exception is raised.
    '''
    M = random_orthogonal_Qmatrix(ndim, max_height, num_tries)
    return mat_cden(M)*M

#---------------------------------------------------------------------
def random_orthogonal_Zmatrix_II(numr, numc, max_height=100, num_tries = 10000):
    '''
            Attempts to generate random ndim x ndim matrix with mutually orthogonal rows and integer entries not exceeding max_height (= 100 by default) in absolute value. If it does not succeed after max_tries (= 1000 by default) number of attempts, an exception is raised.
    '''

    #Bounds on the number of tries, if not specified
    #if num_tries is None:
    #    num_tries = ceil((2*max_height+1)**(ndim/2))
    
    for attempt in range(num_tries):
        M = random_matrix(ZZ, numr, numc, rank=min(numr, numc), algorithm='echelonizable', upper_bound=max_height)
        Q, R = nice_GramSchmidtZ(M)
        if Q.height() <= max_height: 
            return Q
    raise Exception('Number of tries exceeded!')

#---------------------------------------------------------------------
def random_GramSchmidt_Zmatrix(numr=3, numc=None, numrk=None, maxh=100, maxz=1, maxQ=None, maxQz=None, maxL=None, maxLz=None, is_pr=True, ort_method='II', num_attempts=10000):
    '''
        Generates numr x numc integer matrix M that has a nice factorization M = L*Q into integer matrices L and Q, such that:

        L is integer lower triangular of size = numr x numc and rank = numrk and non-zero diagonal entries 1

        Q is integer numc x numc matrix with orthogonal rows.
        
        The entries in rows of L correspond to coefficients in Gram-Schmidt orthogonalization of row-vectors of returned matrix M.
    '''

    if numr is None:
        raise Exception('Need to know no. of rows!')

    if numc is None:
        numc = numr

    #dimensions for inner calculations
    k = min(numr, numc)
    n = max(numr, numc)

	#default number of attempts
    #if num_attempts is None:
    #    num_attempts = ceil((2*maxh+1)**(n/2))
       
    #default height and no. of zeros parameters for matrices L and Q (if not specified)
    if numrk is None:
        numrk=k
    elif numrk > k:
        raise Exception('Rank exceeds matrix dimensions!')

    defh = ceil(sqrt(maxh))
    defnz = maxz
    
    if maxQ is None:
       maxQ = defh
       
    if maxQz is None:
       maxQz = defnz

    if maxL is None:
       maxL = defh
       
    if maxLz is None:
       maxLz = defnz

    #debug
    #print("Parameters so far:", numr, numc, numrk, maxh, maxQ, maxQz, maxL, maxLz)
    #print('n=',n)
    #print('maxh=',maxh)
    #print('num_attempts=', num_attempts)

    E = identity_matrix(QQ, n);
    
    adm_att = ceil(sqrt(num_attempts))

    #outer loop over orthogonal multiplier Q -- they are harder to choose and must be picked first to assure more uniform variety
    for attempt1 in range(adm_att):
        
        try:
            if ort_method =='II':
                Q = random_orthogonal_Zmatrix_II(numc, numc, max_height=maxQ)
            elif ort_method =='I':
                Q = random_orthogonal_Zmatrix_I(numc, max_height=maxQ)
            else:
                raise Exception('Wrong orthogonal method!')
                return None
        except:
            continue

        if not accept_matrix(Q, max_height=maxQ, max_zeros= maxQz, is_prim=is_pr):
            continue

        #inner loop over for chosen Q to find lower triangular multiplier L that matches constraints.
        for attempt2 in range(adm_att):

            L = random_ltdet1_Zmatrix(n, maxL)    
            #trim down L

            if not accept_matrix(L + L.T - E, max_zeros= maxLz, max_height=maxL, is_prim=is_pr):
                continue
            
            L = L[:numr, :numc]
        
            #add vectors that will cancel out in Gram-Schmidt
            k = min(numr, numc)
            defects = rnd.sample(range(2, k), k - numrk)
            for df in defects:
                for col in range(min(numrk, df), numc):
                    L[df,col] = 0

            M = L * Q

            if accept_matrix(M, max_height=maxh, max_zeros=maxz, is_prim=is_pr):
                return M

    raise Exception('random_GramSchmidt_Zmatrix() did not succeed: no. of attempts exceeded %s!' % str(num_attempts))

#---------------------------------------------------------------------
def random_nice_symmetric_Zmatrix(ndim, max_height=100, max2len=None, num_tries = 10000, nrank=None, signature=None, evec_weights=None, displ=None):
    '''
            Attempts to generate random symmetric ndim x ndim matrix with integer entries <= max_height (= 100 by default) in absolute value and integer eigenvalues < max_ev (=100 by default) in absolute value. If it does not succeed after max_tries (= 1000 by default) number of attempts, an exception is raised.
    '''

    #if rank and signature are not given, generate valid random values
    if nrank is None:
        rnk = rnd.randint(1, ndim)
    else:
        rnk = nrank
    if signature == None:
        sgt = rnk - 2*rnd.randint(0, rnk)
    else:
        sgt = signature
        
    #index calculations
    nul_dim = ndim - rnk
    neg_idx = (rnk - sgt) // 2
    pos_idx = rnk - neg_idx

    #check if nullity, signature and dimensions are compatible
    if (ndim<= 0) or (nul_dim <0) or (rnk < 0) or (neg_idx < 0) or (pos_idx < 0) or (pos_idx-neg_idx != sgt) or (neg_idx+pos_idx+nul_dim != ndim):
        raise Exception('Incompatible dimension, nullity and signature values!')
        
    #if evec_weights are not overriden, then calculate from the nullity and signature:
    ev_weights = neg_idx*[-1]+nul_dim*[0]+pos_idx*[1]
    rnd.shuffle(ev_weights)

    #if evec_weights is specified, default weights are overriden
    if (evec_weights is not None) and (len(evec_weights)==ndim):
        ev_weights = evec_weights

    if max2len is None:
        max_ev = ndim*max_height^2
    else:
        max_ev = max2len
    
    #debug
    #print("\n nrank=", rnk, "\n nulldim=", nul_dim, "\n neg_idx=", neg_idx, "\n pos_idx=", pos_idx, "\n ev_weights=", ev_weights, "\n")
        
    for attempt in range(ceil(sqrt(num_tries))):

        try:
            U = random_orthogonal_Zmatrix_II(ndim, ndim, max_ev, ceil(sqrt(num_tries)))
        except Exception:
            continue
                             
        #extract and sort U rows
        rowsU = [matrix(U.base_ring(), 1, ndim, rvec) for rvec in U.rows()]
        rowsU.sort(key=norm)

        #size of eigenvalues; if too large, skip this candidate 
        evals = [wgt*((rvec*rvec.T)[0,0]) for wgt, rvec in zip(ev_weights, rowsU)]
        evals.sort()

        if displ is None:
            shift = 0
        elif displ == 'random': 
            shift = evals[rnd.choice([neg_idx, -pos_idx-1]) % ndim] + rnd.choice([-1, 0, 1])
        elif displ == 'symmetric':
            shift = (max(evals)-min(evals))//2
        elif displ == 'middle':
            shift = evals[len(evals)//2]
        else:
            shift = displ 

        if max([abs(ev+shift) for ev in evals]) > max_ev:
            continue

        #rank-1 scaled projections into row vectors of U
        projU = [mat.T * mat for mat in rowsU]
        tpls = zip(ev_weights, projU)

        # M = weight_1 * P_1 + weight_2*P_2 + ... + weight_n*P_n + shift*E
        # where P_i is a projection to i-th row of U, E - ndim x ndim identity matrix
        M = make_primitive_sym(sum(wgt*mat for wgt, mat in tpls)+shift*identity_matrix(U.base_ring(), ndim))
        if M.height() <= max_height: 
            return M
            
    raise Exception('Number of tries exceeded!')

#---------------------------------------------------------------------
def sample_repl(population, num):
    '''
        Returns num repeated samples (with replacement) from population 
    '''
    return [rnd.choice(population) for j in range(num)]
    
#---------------------------------------------------------------------
def random_nice_SVD_Zmatrix(nrows, ncols, max_height=100, max2len=None, num_tries = 10000, nrank=None, svec_weights=None):
    '''
            Attempts to generate random nrows x ncols matrix with integer entries <= max_height (= 100 by default) in absolute value and integer singular values < max_sing (=100 by default) in absolute value. If it does not succeed after max_tries (= 1000 by default) number of attempts, an exception is raised.
    '''

    #if rank and signature are not given, generate valid random values
    if nrank == None:
        rnk = rnd.randint(1, min(nrows, ncols))
    else:
        rnk = nrank
        
    #check if nullity, signature and dimensions are compatible
    if (nrows <= 0) or (ncols <= 0) or (rnk > nrows) or (rnk > ncols):
        raise Exception('Incompatible dimension, nullity and signature values!')
        
    if max2len == None:
        max_sv = ceil(sqrt(max(nrows, ncols)*max_height))+1
    else:
        max_sv = max2len

    #if svec_weights is specified, default weights are overriden
    if (svec_weights != None):
        sv_weights = svec_weights

    #debug
    #print('sv_weights=', sv_weights)      
    for attempt in range(ceil(sqrt(num_tries))):

        try:
            U = random_orthogonal_Zmatrix_II(nrows, nrows, max_sv, ceil(sqrt(num_tries)))
            V = random_orthogonal_Zmatrix_II(ncols, ncols, max_sv, ceil(sqrt(num_tries)))
        except Exception:
            continue

        #debug
        #print('U=', U, ' V=', V)
                             
        #extract and order randomly U and V rows
        rowsU = [matrix(U.base_ring(), 1, U.ncols(), rvec) for rvec in U.rows()]
        rnd.shuffle(rowsU)
        rowsV = [matrix(V.base_ring(), 1, V.ncols(), rvec) for rvec in V.rows()]
        rnd.shuffle(rowsV)

        #prepare weights
        if svec_weights == None:
            rng = list(range(-ceil(sqrt(max_height)/2)-1,0))+list(range(1,ceil(sqrt(max_height)/2)+1))
            sv_weights = sample_repl(rng, rnk)

        #debug
        #print('sv_weights=',sv_weights, ' rowsU=', rowsU, ' rowsV=', rowsV)
        
        #size of singular values; if too large, skip this candidate 
        svals = [wgt*((rvec*rvec.T)[0,0]) for wgt, rvec in zip(sv_weights, rowsU)]
        svals.sort()

        if max([abs(sv) for sv in svals]) > max_sv:
            continue

        #rank-1 scaled projections into row vectors of U
        lmaps = [uvec.T * vvec for uvec, vvec in zip(rowsU, rowsV)]
        tpls = zip(sv_weights, lmaps)

        # M = weight_1 * M_1 + weight_2*M_2 + ... + weight_n*M_n
        # where M_i is a map to i-th row of U on to the i-th row of V
        M = make_primitive_sym(sum(wgt*mat for wgt, mat in tpls))
        if M.height() <= max_height: 
            return M
            
    raise Exception('Number of tries exceeded!')

#---------------------------------------------------------------------
def Pythagorean_tuples(mat):
    '''
        Extracts all possible different Pythagorean tuples from rows and columns of mat
    '''
    pt_tuples = set()
    
    for vec in mat.rows() + mat.columns():
        pt = [abs(c) for c in vec]
        pt.sort()
        pt_tuples.add(tuple(pt))

    return pt_tuples

#---------------------------------------------------------------------
def nice_GramSchmidtZ(mat):
    '''
        Produces matrices Q and L, such that L*Q = mat, rows of Q are orthogonal and integer, L is lower triangular and integral (if possible)  
    '''
    Q,L = mat.gram_schmidt()
    D = mat_cfactor(Q) #integralizing factor
    niceQ = D*Q
    niceL = L*D.inverse()

    return niceQ, niceL

#---------------------------------------------------------------------
def nice_left_eigenmatrix(mat):
    '''
        Produces integer matrix T and diagonal matrix D, such that rows of T contain eigenvectors of mat, and diagonal of D contains eigenvalues of mat. If T is invertible, then T diagonalizes mat: T*mat*T^(-1) = D
    '''
    D, T = mat.eigenmatrix_left()

    #sort the eigenvectors by eigenvalues from largest to smallest
    evec_pairs = [(D[i, i], t) for i, t in enumerate(T.rows())]
    evec_pairs.sort(reverse=True, key=lambda evp: evp[0])
    sortedD = diagonal_matrix([evp[0] for evp in evec_pairs])
    sortedT = matrix([evp[1] for evp in evec_pairs])

    niceT = mat_cfactor(sortedT)*sortedT    
    return (sortedD, niceT)

#---------------------------------------------------------------------
def normalize_vec(vec):
    '''
        Returns a normalized version of vec with coordinates in SAGE symbolic ring SR
    '''
    nvec = vector(SR, vec)
    if nvec.norm() > 0:
        nvec = nvec / nvec.norm()
    return nvec

#---------------------------------------------------------------------
def normalize_rows(mat):
    '''
        Returns a matrix over SAGE symbolic ring SR whose rows are normalized row vectors of mat
    '''
    return matrix(SR, [normalize_vec(rvec) for rvec in mat.rows()])

#---------------------------------------------------------------------
def len2_rows(mat):
    '''
        Returns maximal squared length of row in mat
    '''
    return max([rvec*rvec for rvec in mat.rows()])

#---------------------------------------------------------------------
def norm_rows(mat):
    '''
        Returns maximal row length of mat
    '''
    return sqrt(len2_rows(mat))


#---------------------------------------------------------------------
def nice_orthodiagonalization(sym_mat):
    '''
        Computes diagonal matrix D and orthogonal matrix Q, Q*Q^t = I  with 'nice' entries, such that Q*sym_mat*Q^(-t) = D (i.e. Q orthodiagonlizes sym_mat)
    '''
    if sym_mat.transpose() != sym_mat:
        raise Exception('sym_mat is not symmetric!')
        
    D, T = nice_left_eigenmatrix(sym_mat)
    Q, R = nice_GramSchmidtZ(T)
    normQ = normalize_rows(Q)
    symbD = matrix(SR, D)
    return (symbD, normQ)

#---------------------------------------------------------------------

def nice_SVD(mat):
    '''
        Computes 'nice' orthogonal matrices U and V, and a diagonal matrix S, such that mat=U*S*V^t.
    '''
    m = mat.nrows(); n = mat.ncols()

    temp_mat = matrix(mat)
    if m < n:
        temp_mat = temp_mat.transpose()
        
    aux_mat = temp_mat*temp_mat.transpose()
    
    D, T = nice_orthodiagonalization(aux_mat)
    U = T.transpose()

    S = diagonal_matrix(SR, [sqrt(sig2) for sig2 in D.diagonal()])
    S = S[: temp_mat.nrows(), : temp_mat.ncols()]

    null_mat = normalize_rows(nice_GramSchmidtZ(temp_mat.right_kernel().basis_matrix())[0])
    null_vec = iter(null_mat.rows())
    v_vecs = []
    for j in range(S.ncols()):
        if S[j, j] > 0:
            v_vecs.append(T[j]*temp_mat/S[j, j])
        else:
            v_vecs.append(next(null_vec))
    V = matrix(SR, v_vecs).transpose()

    if m < n:
        S = S.transpose()
        U, V = V, U

    return S, U, V

#---------------------------------------------------------------------
def sort_matrix_rows(M, rev=False):
    '''
        Sorts matrix rows
    '''
    rw = M.rows()
    rw.sort(reverse=rev)
    
    return matrix(M.base_ring(), M.nrows(), M.ncols(), rw)

#---------------------------------------------------------------------
def sort_matrix_cols(M, rev=False):
    '''
        Sorts matrix columns
    '''
    cl = M.columns()
    cl.sort(reverse=rev)
    
    return matrix(M.base_ring(), M.ncols(), M.nrows(), cl).transpose()


#---------------------------------------------------------------------
def sort_matrix(M, rev=False):
    '''
        Sorts matrix by columns then by rows until it stabilizes or enters a cycle
    '''
    prev_mats = [M]

    while True:
        next_mat = sort_matrix_rows(sort_matrix_cols(prev_mats[-1], rev), rev)
        if next_mat in prev_mats:
            break
        prev_mats.append(next_mat)
        
    return next_mat

#---------------------------------------------------------------------
def permute_rows_cols(mat):
    '''
        Returns the list of all distinct matrices obtained by permuting rows and columns of mat
    '''
    G = SymmetricGroup(mat.nrows()).list()
    H = SymmetricGroup(mat.ncols()).list()
    rowPerm = [g.matrix() for g in G]
    colPerm = [h.matrix() for h in H]

    pmats = []
    for P in rowPerm:
        for Q in colPerm:
            pmat = P*mat*Q
            if pmat not in pmats:
                pmats.append(pmat)
            
    return pmats

#---------------------------------------------------------------------
def permute_rows_cols_sym(sym_mat):
    '''
        Returns the list of all distinct symmetric matrices obtained by permuting rows and columns of a symmetric matrix sym_mat
    '''
    G = SymmetricGroup(sym_mat.nrows()).list()
    perms = [g.matrix() for g in G]

    psmats = []
    for P in perms:
        psmat = P*sym_mat*(P.T)
        if psmat not in psmats:
           psmats.append(psmat)
           
    return psmats

#---------------------------------------------------------------------
def flip_signs_rows_cols(mat):
    '''
        Returns the list of all distinct matrices obtained from mat by flipping signs of rows and columns
    '''
    combrep = itt.product([1, -1], repeat=mat.nrows())
    rSgn = [diagonal_matrix(c) for c in combrep]
    
    combrep = itt.product([1, -1], repeat=mat.ncols())
    cSgn = [diagonal_matrix(c) for c in combrep]

    smats = []
    for P in rSgn:
        for Q in cSgn:
            smat = P*mat*Q
            if smat not in smats:
                smats.append(smat)
            
    return smats

#---------------------------------------------------------------------
def flip_signs_rows_cols_sym(sym_mat):
    '''
        Returns the list of all distinct symmetric matrices obtained from a symmetric matrix mat by flipping signs of rows and columns
    '''
    combrep = itt.product([1, -1], repeat=sym_mat.nrows())
    sgns = [diagonal_matrix(c) for c in combrep]
    
    ssmats = []
    for P in sgns:
        smat = P*sym_mat*(P.T)
        if smat not in ssmats:
                ssmats.append(smat)
            
    return ssmats

#---------------------------------------------------------------------
def remove_duplicates(lst):
    '''
        Returns a copy of lst with removed duplicates
    '''
    cleaned = []
    for itm in lst:
        if itm not in cleaned:
            cleaned.append(itm)
    return cleaned
        
#---------------------------------------------------------------------
def flip_and_permute(mat):
    '''
        Returns the list of distinct matrices obtained from mat by flipping signs and permuting rows and columns in all possible ways
    '''
    nmats = []
    fmats = flip_signs_rows_cols(mat)
    
    for fmat in fmats:
        nmats += permute_rows_cols(fmat)

    return remove_duplicates(nmats)

#---------------------------------------------------------------------
def flip_and_permute_sym(sym_mat):
    '''
        Returns the list of distinct symmetric matrices obtained from a symmetric matrix mat by flipping signs and permuting rows and columns in all possible ways
    '''
    nsmats = []
    fsmats = flip_signs_rows_cols_sym(sym_mat)
    
    for fsmat in fsmats:
        nsmats += permute_rows_cols_sym(fsmat)

    return remove_duplicates(nsmats)
    
#---------------------------------------------------------------------
def populate_mats(mat_lst):
    '''
        Returns a list of distinct matrixes that are sign-flipped and permuted matrices from mat_lst
    '''
    lst = []
    for mat in mat_lst:
        lst += flip_and_permute(mat)
    return remove_duplicates(lst)

#---------------------------------------------------------------------
def populate_mats_sym(sym_mat_lst):
    '''
        Returns a list of distinct symmetric matrixes that are sign-flipped and permuted versions of symmeric matrices from sym_mat_lst
    '''
    slst = []
    for smat in sym_mat_lst:
        slst += flip_and_permute_sym(smat)
    return remove_duplicates(slst)

#---------------------------------------------------------------------
def extend_basis(U, V, W):
    '''Expands the basis of a subspace V until the basis of the space W in such a way that the newly adjoined basis vectors are linearly independent with respect to subspace U. If U or V are not subspaces of W, an error is raised.'''
    Q, pi, rho = W.quotient_abstract(U+V);
    return [rho(v) for v in Q.basis()]     

#---------------------------------------------------------------------
def new_lead_vectors(old_vecs, U, W):
    '''Generates the set of new lead vectors of a Jordan chain. Given list old_vecs of vectors 'vecs', computes the set of new vectors that extends old_vecs to the full W basis in such a way that the newly adjoined basis vectors remain linearly independent with respect to subspace U. If at least one of vectors from old_vecs does not belong to W, or U is not a proper subspace of W, an error will be raised'''
    V = W.subspace(old_vecs)
    return extend_basis(U, V, W)     

#---------------------------------------------------------------------
def colinear_vecs(u, v):
    ''' Checks if two vectors u and v  are colinear.'''
    A = matrix(ZZ, [u, v])
    if A.rank() == 2:
        return 0
    else:
        return 1

#---------------------------------------------------------------------
def colinear_rc(M):
    ''' Reports number r of colinear rows and number c of colinear columns in matrix M. '''
    return (sum(colinear_vecs(u, v) for u, v in itt.combinations(M.rows(),2)), sum(colinear_vecs(u, v) for u, v in itt.combinations(M.columns(),2)))

#---------------------------------------------------------------------
def zeros_rc(M):
    ''' Reports maximal numbers of zeros accross rows and columns of  matrix M.'''
    return (max([r.list().count(0) for r in M.rows()]), max([c.list().count(0) for c in M.columns()]))    

#---------------------------------------------------------------------
def ones_fc(M):
    ''' Reports number of 1 and -1 in the first column of matrix M '''
    return list(M.columns()[0]).count(1)+list(M.columns()[0]).count(-1)

#---------------------------------------------------------------------
def max_row_len2(M):
    '''Returns largest length squared of its the row of M'''
    return max([rw * rw for rw in M.rows()])

#---------------------------------------------------------------------
def max_col_len2(M):
    '''Returns largest length squared of its the row of M'''
    return max([cl * cl for cl in M.columns()])

#---------------------------------------------------------------------
def accept_matrix(M, allow_colinear = True, has_ones_fc = False, max_zeros = 10000, max_height = 10000, max_len2 = 10000, is_prim=False):
    ''' Runs tests on matrix M: 
        a) If allow_colinear = False, checks if M has ay colinear rows or columns
        b) If has_ones = True, then checks if first column of M contains any 1 or -1
        c) Checks if matrix has no more than max_zeros in each row and column of M
        d) Checks if squared length of row vectors of M does not exceed max_len2
        e) checks if M is primitive, that is, gcd of entries = 1
        If all checks succeed, returns True, otherwise returns False.
     '''

    if not allow_colinear:
        if max(colinear_rc(M)) > 0:
            return False
     
    if has_ones_fc:
        if ones_fc(M) == 0:
            return False

    if max(zeros_rc(M)) > max_zeros:
        return False

    if M.height() > max_height:
        return False

    if (max_row_len2(M) > max_len2) or (max_col_len2(M) > max_len2):
        return False

    if is_prim:
        cf = gcd(M.list())
        if abs(cf) > 1:
            return False
    
    return True

#---------------------------------------------------------------------
def update_lst(lst, items):
    '''
        Appends items that are not present in the list
    '''
    lst += [itm for itm in items if itm not in lst]

#---------------------------------------------------------------------
def update_dict_lst(dic, key, item_lst):
    '''
        Takes a dictionary whose values are lists and appends new items to the list at dic[key]
    '''
    if key not in dic.keys():
        dic[key] = []

    for itm in item_lst:
        if itm not in dic[key]:
            dic[key].append(itm)

#---------------------------------------------------------------------
def sort_dict(dic):
    '''
        Returns a dictionary whose keys are sorted in ascending order
    '''
    return {key: dic[key] for key in sorted(dic)}

#---------------------------------------------------------------------
def sort_dict_lst(dic):
    '''
        Returns a dictionary of lists whose keys and lists are sorted in ascending order
    '''
    return {key: sorted(dic[key]) for key in sorted(dic)}
