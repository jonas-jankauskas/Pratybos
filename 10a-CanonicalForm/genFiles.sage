reset()

import random as rnd
load('../matrix_utils.sage')
load('../text_utils.sage')

#---------------------------------------------------------------------
#the following parameters must be set-up before launching this script:

#number of tests to make
num_probs=20
#data file location
data_path='../Data/'
data_name = 'canonical-form'
full_data_path=data_path+data_name
#test file name location and naming
test_name='Kanoninė forma'
test_path='ProblemSet/'
test_ext='.xml'

#---------------------------------------------------------------------
#load the earlier generated data
try:
    qforms_data = load(full_data_path)
except:
    qforms_data = []

#load the template text
tmpl_file_name = 'template'
tmpl = open(tmpl_file_name, 'r')
otxt = tmpl.read()
tmpl.close()

#---------------------------------------------------------------------
#sample forms uniformly by signature

sgns = set([qf.signature() for qf in qforms_data])
grouped = {sig: [qf for qf in qforms_data if qf.signature()==sig] for sig in sgns}
num_req = ceil(num_probs/len(sgns))
selected_data=[]
for sig in sgns:
    selected_data += sample(grouped[sig], num_req);
problem_data = sample(selected_data, num_probs)

#print header with timestamp
print('------------------------ Test data for %s ------------------------' % get_date_time())

#make tests
for nr, qForm in enumerate(problem_data):

    cForm, matC = qForm.rational_diagonal_form(return_matrix=True)
    matC = matC.T
    ndim =cForm.dim()

    vecD = vector(cForm.Gram_matrix().diagonal())
    
    x_names = ['x'+ str(j+1) for j in range(ndim)]
    y_names = ['y' + str(j+1)for j in range(ndim)]
    
    
    x_str = ','.join(x_names)
    y_str = ','.join(y_names)
    
    var_str = x_str +',' + y_str
    
    K = PolynomialRing(SR, 2*ndim, names=var_str)
    
    x_vec = vector(K, ndim, K.gens()[:ndim])
    y_vec = vector(K, ndim, K.gens()[ndim:])
    
    
    fPoly = qForm.polynomial(x_str)
    gPoly = cForm.polynomial(y_str)
        
    f_str = 'f%s=%s' % (latex(x_vec), latex(fPoly))
    g_str = 'g%s=%s' % (latex(y_vec), latex(gPoly))
    eqs_str = latex_SLE(matC, x_vec, 'y', eq_side='left', eol_str='')

    subs = {' ': ''}
    answ_str = str(vecD)
    answ_str = make_subs(answ_str, subs)

    subs = {'$id$': str(nr+1), '$dim$': str(ndim), '$f$': f_str, '$g$': g_str, '$eqs$': eqs_str, '$answ$': answ_str}
    
    ntxt = make_subs(otxt, subs)

    full_test_path = test_path+test_name+' '+str(nr+1)+' variantas'+test_ext
    write_file(full_test_path, ntxt)    

    #test printout
    print('f(%s)=' % x_str, str(fPoly))
    print('g(%s)=' % y_str, str(gPoly))
    print('\n')
