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
def cf_to_latex(cf, with_plus=True):
    '''
        Returns text representation of a scalar cf.
        
        If cf = 0, result is '0'.

        if cf > 1 positive, result is '+cf' when with_plus = True, 'cf' when with_plus=False.

        If cf == 1, result is '+' when with_plus = True, empty string '' when with_plus=False.

        If cf == -1, result is '-'

        If cf < -1, result is '-abs(cf)'
    '''
    res = str(abs(cf))
    if (abs(cf) != 1):
        res = str(abs(cf))
    else:
        res = ''
    if (cf > 0) and with_plus:
        res = '+\\,' + res
    if (cf < 0):
        res = '-\\,' + res
                
    return res

#-----------------------------------------------
def latex_lin_comb(cfs, xvars, eq_side='right'):
    '''
        Given list of real scalar coefficients cfs=[c_1,c_2,...,c_n] and list of symbolic variables xvars=[x_1,x_2,...,x_n], returns nicely formated latex formula for
        c_1*x_1+c_2*x_2+...c_n*x_n
        in array form
    '''
    terms = [cf_to_latex(cf)+latex(xvar) for cf, xvar in zip(cfs, xvars)]
    
    #replace '0' by spaces; determine first non-zero entry
    fnz = len(terms)
    for idx, cof in enumerate(cfs):
        if cof == 0:
            terms[idx] = ' '
        else:
            fnz = min(fnz, idx)

    if fnz < len(terms):
        #trim first '+'
        if cfs[fnz] > 0:
            terms[fnz] = cf_to_latex(cfs[fnz], with_plus=False)+latex(xvars[fnz])
    else:
        #if all terms 0, show only closest to '=' sign
        if eq_side == 'right':
            terms[-1] = '0'
        elif eq_side == 'left':
            terms[0] = '0'
        else:
            raise Exception('Unknown eq_side: should be either \'right\' or \'left\'!') 

    return ' & '.join(terms)

#-----------------------------------------------
def latex_lin_comb_lax(cfs, xvars):
    '''
        Given list of real scalar coefficients cfs=[c_1,c_2,...,c_n] and list of symbolic variables xvars=[x_1,x_2,...,x_n], returns nicely formated latex formula for
            c_1*x_1+c_2*x_2+...c_n*x_n
        in a non--aligned (lax) form
    '''
    return latex(vector(cfs)*vector(xvars))

#-----------------------------------------------
def latex_single_eq(cfs, xvars, yvar, eq_side='right', eq_type='array'):
    '''
        Given a list of real scalar coefficients cfs=[c_1,c_2,...,c_n], list of symbolic variables xvars=[x_1,x_2,...,x_n], and a symbolix variable y, returns nicely formated latex formula for
            c_1*x_1+c_2*x_2+...c_n*x_n = y,
        when eq_side='right' (default value), and
            y= c_1*x_1+c_2*x_2+...c_n*x_n,
        when type = 'left'.
        If eq_type = 'array' (default value), result is formated using latex array tab stops & and is suitable to insert into latex array.
        If eq_type = 'lax', result is returned as a string representing non-aligned latex symbolic expression.
        End-of-the-line marker eof_str is appended to the end of the equation. By default, it is '', but also can be '\n'.
    '''
    if eq_type =='array':
        lc_str = latex_lin_comb(cfs, xvars, eq_side)
    elif eq_type == 'lax':
        lc_str = latex_lin_comb_lax(cfs, xvars)
    else:
        raise Exception('Uknown eq_type: should be either \'array\' or \'lax\'!')

    if eq_side == 'right':
        eq_str = lc_str + '& = &' + latex(yvar)
    elif eq_side == 'left':
        eq_str = latex(yvar) + '& = &' + lc_str
    else:
        raise Exception('Unknown eq_side: should be either \'right\' or \'left\'!') 
    
    return eq_str
    
#-----------------------------------------------
def latex_SLE(A, b, xNames, eq_side='right', eol_str='\n'):
    '''
        Given a m x n square matrix of real scalar coefficients A=[[a_11,a_12,...]...[...,a_mn]], list of symbolic indeterminate variables xvars=[x_1,x_2,...,x_n], and a list of symbolic variables or contants b=[y_1 ... y_m] returns nicely formated latex formula for

            //a_11*x_1+a_12*x_2+...a_1n*x_n = y_1,
            |a_21*x_1+a_22*x_2+...a_2n*x_n = y_1
            |                  ...
            \\a_m1*x_1+a_m2*x_2+...a_mn*x_n = y_1
            
        when eq_side='right', and
        
            //y_1 = a_11*x_1+a_12*x_2+...a_1n*x_n,
            |y_2 = a_21*x_1+a_22*x_2+...a_2n*x_n,
            |                  ...
            \\y_m = a_m1*x_1+a_m2*x_2+...a_mn*x_n.
            
        when type = 'left'.
        Parameter eol_str indicates end-of-line marker string at the end of each equation and end of the system. It can be empty '' (default) or '\n' (standard system end-of-line symbol sequence).
    '''

    if A.nrows() != len(b):
        raise Exception('A rows do not match b!')
        return

    if len(xNames) == 1:
        if A.ncols() > 1:
            x_str = [xNames+ str(j+1) for j in range(A.ncols())]
        else:
            x_str = xNames
    else:
        if A.ncols() == len(xNames):
            x_str = xNames
        else:
            raise Exception('A columns do not match variables!')
            
    var_str = ','.join([str(name) for name in x_str])
    x_vars = var(var_str)

    eqs_list = []

    for row, c in zip(A.rows(), b):
        eq_str = latex_single_eq(row, x_vars, c, eq_side, eq_type='array')
        eqs_list.append(eq_str)

    form_str = 'r'*(len(x_vars))
    if eq_side == 'right':
        form_str += 'cl'
    elif eq_side == 'left':
        form_str = 'rc' + form_str
        
    syst_str = '\\left\\{\\begin{array}{%s}%s%s%s\\end{array}\\right.' % (form_str, eol_str, ('\\\\' + eol_str).join(eqs_list), eol_str)
    syst_str += eol_str

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
