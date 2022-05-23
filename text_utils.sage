from datetime import datetime

#-----------------------------------------------
def make_subs(old_text, changes):
    '''
        Performs substitutions in old_text string specified in the dicrtionary changes
    '''
    new_text = str(old_text)
    for s in changes.keys():
            new_text = new_text.replace(s, changes[s])
    return new_text

#-----------------------------------------------
def write_file(file_name, text):
    '''
        Overwrites the text into a file
    '''
    outf = open(file_name, 'w')
    outf.write(text)
    outf.close()

#-----------------------------------------------
def get_date_time():
    '''
        Returns pre-formated current date-time string
    '''
    now = datetime.now()
    time_stamp = now.strftime("%Y/%m/%d %H:%M:%S")


    return time_stamp

#-----------------------------------------------
def latex_linear_combination_aligned(cfs, xvars):
    '''
        Given list of real scalar coefficients cfs=[c_1,c_2,...,c_n] and list of symbolic variables xvars=[x_1,x_2,...,x_n], returns nicely formated latex formula for
        c_1*x_1+c_2*x_2+...c_n*x_n
        in aligned form
    '''
    if len(cfs) != len(xvars):
        raise Exception('Coefficients do not match variables!')

    lc_str = ''

    was_nonzero = False
	
    for cf, xvar in zip(cfs, xvars):

        #check if all previous coeffs where zeros
        if was_nonzero:
            sg_str = '+\\,'
        else:
            sg_str = ' '
        	
        cf_str = latex(xvar)
        
        if cf < 0:
            sg_str = '-\\,'

        if cf == 0:
            sg_str = ' '
            if (xvar != xvars[-1]) or was_nonzero:
                cf_str = ' '
            else:
                cf_str = '0'
        else:
            was_nonzero = True
        	        	
        if abs(cf) > 1:
            cf_str = latex(abs(cf))+cf_str

        lc_str += '%s%s&' % (sg_str, cf_str)

    if lc_str[0] == '+':
        lc_str = lc_str[1:]

    return lc_str

#-----------------------------------------------
def latex_linear_combination_lax(cfs, xvars):
    '''
        Given list of real scalar coefficients cfs=[c_1,c_2,...,c_n] and list of symbolic variables xvars=[x_1,x_2,...,x_n], returns nicely formated latex formula for
            c_1*x_1+c_2*x_2+...c_n*x_n
        in a non--aligned (lax) form
    '''
    return latex(vector(cfs)*vector(xvars))

#-----------------------------------------------
def latex_single_eq_aligned(cfs, xvars, yvar, eq_type='right'):
    '''
        Given a list of real scalar coefficients cfs=[c_1,c_2,...,c_n], list of symbolic variables xvars=[x_1,x_2,...,x_n], and a symbolix variable y, returns nicely formated latex formula for
            c_1*x_1+c_2*x_2+...c_n*x_n = y,
        when eq_type='right', and
            y= c_1*x_1+c_2*x_2+...c_n*x_n,
        when type = 'left', in aligned form
    '''
    lc_str = latex_linear_combination_aligned(cfs, xvars)

    if eq_type == 'right':
        eq_str = lc_str +'&=&'+latex(yvar)
    elif eq_type == 'left':
        eq_str = latex(yvar) + '&=&' + lc_str
    else:
        raise Exception('Unknown equation type!') 

    return eq_str

#-----------------------------------------------
def latex_single_eq_lax(cfs, xvars, yvar, eq_type='right'):
    '''
        Given a list of real scalar coefficients cfs=[c_1,c_2,...,c_n], list of symbolic variables xvars=[x_1,x_2,...,x_n], and a symbolix variable y, returns nicely formated latex formula for
            c_1*x_1+c_2*x_2+...c_n*x_n = y,
        when eq_type='right', and
            y= c_1*x_1+c_2*x_2+...c_n*x_n,
        when type = 'left', in non-aligned (lax) form
    '''
    lc_str = latex_linear_combination_lax(cfs, xvars)

    if eq_type == 'right':
        eq_str = lc_str +'='+latex(yvar)
    elif eq_type == 'left':
        eq_str = latex(yvar) + '=' + lc_str
    else:
        raise Exception('Unknown equation type!') 

    return eq_str
    
#-----------------------------------------------
def latex_SLE(A, b, xNames, eq_type='right'):

    '''
        Given a m x n square matrix of real scalar coefficients A=[[a_11,a_12,...]...[...,a_mn]], list of symbolic indeterminate variables xvars=[x_1,x_2,...,x_n], and a list of symbolic variables or contants b=[y_1 ... y_m] returns nicely formated latex formula for

            /a_11*x_1+a_12*x_2+...a_1n*x_n = y_1,
            |a_21*x_1+a_22*x_2+...a_2n*x_n = y_1
            |                  ...
            \a_m1*x_1+a_m2*x_2+...a_mn*x_n = y_1
            
        when eq_type='right', and
        
            /y_1 = a_11*x_1+a_12*x_2+...a_1n*x_n,
            |y_2 = a_21*x_1+a_22*x_2+...a_2n*x_n,
            |                  ...
            \y_m = a_m1*x_1+a_m2*x_2+...a_mn*x_n.
            
        when type = 'left'.
    '''

    if A.nrows() != len(b):
        raise Exception('A rows do not match entries of b!')
        return

    if len(xNames) == 1:
        if A.ncols() > 1:
            x_str = [xNames+ str(j+1) for j in range(A.ncols())]
        else:
            x_str = [xNames]
    else:
        if A.ncols() == len(xNames):
            x_str = [xNames]
        else:
            raise Exception('A columns do not match variables!')
            
    var_str = (str().join([s+',' for s in x_str]))[:-1]
    x_vars = var(var_str)

    eqs_list = []

    for row, c in zip(A.rows(), b):
        eq_str = latex_single_eq_aligned(row, x_vars, c, eq_type) + '\\\\'
        eqs_list.append(eq_str)

    form_str = 'r'*(len(x_vars))+'cr'
    syst_str = '\\left\\{\\begin{array}{%s}%s \\end{array} \\right.' %(form_str, str().join(eqs_list))

    return syst_str

#---------------------------------------------------------------------
#printing procedure for Gram-Schmidt equations
def latex_GramSchmidt_eqs(M, T, ovec_name_str, nvec_name_str):

    '''
        Writes down equation expressions for row vectors v1, v2, ...,  of M as linear expressions of u1, u2, ..., specified by rows of L.
    '''

    m = T.nrows(); n = T.ncols()

    u_str = ','.join([ovec_name_str + str(j+1) for j in range(m)])
    v_str = ','.join([nvec_name_str + str(j+1) for j in range(n)])
    var_str = ','.join([u_str,v_str])
    
    R = PolynomialRing(QQ, m+n, names=var_str)
    v = vector(R, R.ngens(), R.gens())
    N=identity_matrix(R, m).augment(-lt_part(T))
    eqs_vec = N*v
    
    return [latex(R.gens()[m+j]) + ' = ' + latex(M.rows()[j])+ ' \\sim ' + latex(eqs_vec[j]) for j in range(n)]

#---------------------------------------------------------------------
#formated strings for vector and matrix answers

def fmt_vecs_str(vec_lst):
    '''
        Returns string representation of vec cleared from spaces
    '''
    subs={' ':''}
    temp = ';'.join(str(vec) for vec in vec_lst)
    return make_subs(str(temp), subs)	

def fmt_mat_str(mat):
    '''
        Returns a string containing matrix elements, enclosed by square brackets [ ], listed row-by-row from top left to bottom right. Matrix elements are separated by commas; rows are separated by semicolons; spaces are trimmed.
    '''
    
    temp = '[%s]' % fmt_vecs_str(mat.rows())
    subs={'(':'', ')':''}
    return make_subs(str(temp), subs)

