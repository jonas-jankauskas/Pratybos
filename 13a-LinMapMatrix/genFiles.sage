reset()

import random as rnd
load('../text_utils.sage')

#---------------------------------------------------------------------
#the following parameters must be set-up before launching this script:

#number of tests to make
num_probs=20
#data file location
data_path='../Data/'
data_name = 'linmap-matrix'
full_data_path=data_path+data_name
#test file name location and naming
test_name='Tiesinio atvaizdžio matrica'
test_path='ProblemSet/'
test_ext='.xml'

#---------------------------------------------------------------------
#load the earlier generated data
try:
    mat_data = load(full_data_path)
except:
    mat_data = []

#load the template text
tmpl_file_name = 'template'
tmpl = open(tmpl_file_name, 'r')
otxt = tmpl.read()
tmpl.close()

#---------------------------------------------------------------------
#sample uniformly by nor. of rows and no. of columns
matdims = [(mat.nrows(), mat.ncols()) for mat in mat_data]
diffdim = set(matdims)
eqv_cls = {dims: [mat for mat in mat_data if mat.nrows()==dims[0] and mat.ncols()==dims[1]] for dims in diffdim}
num_req = ceil(num_probs/len(diffdim))
sel_cls = {dims: sample(eqv_cls[dims], num_req) for dims in diffdim}
problem_data = sample(sum(eqv_cls.values(),[]), num_probs);

#print header with timestamp
print('------------------------ Test data for %s ------------------------' % get_date_time())

#make tests
for nr, mat in enumerate(problem_data):

    m = mat.nrows()
    n = mat.ncols()

    x_str = ','.join(['x%s' % str(j+1) for j in range(m)])
    x_var = var(x_str)
    x_vec = vector(SR, m, x_var)

    y_vec = x_vec*mat

    em_str = ','.join(['e%s' % str(j+1) for j in range(m)])
    em_var = var(em_str)
    em_vec = vector(SR,m,em_var)

    en_str = ','.join(['e%s' % str(j+1) for j in range(n)])
    en_var = var(en_str)
    en_vec = vector(SR,n,en_var)
    e_sum = mat*en_vec

    mbasis_str = ','.join([latex(el) for el in em_var])
    nbasis_str = ','.join([latex(el) for el in en_var])

    eq_str = ['f(e_%s)=%s' % (str(j+1), latex(e_sum[j])) for j in range(m)]
    eq_all = ', \\quad '.join(eq_str)
    
    x_vec_str = latex(x_vec)
    y_vec_str = latex(y_vec)

    mat_latex = latex(mat)    
    answ_str = fmt_mat_str(mat)
    	
    subs = {'$id$': str(nr+1), '$mdim$': str(m), '$ndim$': str(n), '$answ$': answ_str, '$A$': mat_latex, '$x$': x_vec_str, '$y$': y_vec_str, '$eqs$': eq_all, '$mbasis$': mbasis_str, '$nbasis$': nbasis_str} 
    ntxt = make_subs(otxt, subs)

    full_test_path = test_path+test_name+' '+str(nr+1)+' variantas'+test_ext
    write_file(full_test_path, ntxt)    

    #test printout
    print('::::::::::::::::::::::::')
    print('f(%s)=%s' %(x_str, str(y_vec)))
    print('\n')
