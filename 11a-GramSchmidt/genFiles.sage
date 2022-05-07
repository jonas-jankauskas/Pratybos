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
data_name = 'sylvester-criterion'
full_data_path=data_path+data_name
#test file name location and naming
test_name='Silvestro kriterijus'
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
#sample forms uniformly by positive definiteness/negative definiteness/indefiniteness
num_req = ceil(num_probs/3)
qf_pos = sample([qf for qf in qforms_data if qf.is_positive_definite()], num_req)
qf_neg = sample([qf for qf in qforms_data if qf.is_negative_definite()], num_req)
qf_ind = sample([qf for qf in qforms_data if qf.is_indefinite()], num_req)
selected_data=qf_pos+qf_neg+qf_ind
problem_data = sample(selected_data, num_probs)

#print header with timestamp
print('------------------------ Test data for %s ------------------------' % get_date_time())

#make tests
for nr, qForm in enumerate(problem_data):

    ndim = qForm.dim()
    matS = qForm.Gram_matrix()
    matS_str = latex(matS)
    subS = [matS[:(j+1),:(j+1)] for j in range(ndim)]
    subD = [det(mat) for mat in subS]
    
    x_names = ['x'+ str(j+1) for j in range(ndim)]
    x_str = ','.join(x_names)
    x_var = var(x_str)    
    x_vec = vector(x_var)

    fPoly = qForm.polynomial(x_str)
    f_str = 'f%s=%s' % (latex(x_vec), latex(fPoly))

    opt1_str = '0'
    opt2_str = '0'
    opt3_str = '0'
 
    if qForm.is_positive_definite():
        opt1_str = '100'
        answ_str = 'teigiamai apibrėžta'

    if qForm.is_negative_definite():
        opt2_str = '100'
        answ_str = 'neigiamai apibrėžta'

    if qForm.is_indefinite():
        opt3_str = '100'
        answ_str = 'neapibrėžta'

    subs1 = {'$M%s$' % str(j+1): latex(subS[j]) for j in range(ndim)}
    subs2 = {'$det%s$' % str(j+1): latex(subS[j].det()) for j in range(ndim)}
    subs3 = {'$id$': str(nr+1), '$dim$': str(ndim), '$S$': matS_str, '$f$': f_str, '$answ$': answ_str}
    subs4 = {'$opt1$': opt1_str, '$opt2$': opt2_str, '$opt3$': opt3_str}
    subs = {**subs1,**subs2,**subs3,**subs4}
    ntxt = make_subs(otxt, subs)

    full_test_path = test_path+test_name+' '+str(nr+1)+' variantas'+test_ext
    write_file(full_test_path, ntxt)    

    #test printout
    print('f(%s)=' % x_str, str(fPoly), 'yra '+answ_str)
    print('\n')
