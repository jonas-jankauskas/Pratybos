reset()

import random as rnd
load('../text_utils.sage')

#---------------------------------------------------------------------
#the following parameters must be set-up before launching this script:
#matrix dimensions
ndim=2
#number of tests to make
num_probs=20
#data file location
data_path='../Data/'
data_name = 'change-lm-basis-%sx%s' % (str(ndim), str(ndim))
full_data_path=data_path+data_name
#test file name location and naming
test_name='Tiesinio atvaizdžio bazės keitimas'
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
#sample uniformly
problem_data = sample(mat_data, min(num_probs, len(mat_data)));

#print header with timestamp
print('------------------------ Test data for %s ------------------------' % get_date_time())

#make tests
for nr, mats in enumerate(problem_data):

    T, F = mats

    e_str = ','.join(['e_{%s}' % str(j+1) for j in range(ndim)])
    v_names =['v_{%s}' % str(j+1) for j in range(ndim)]
    v_str = ','.join([vn for vn in v_names])
    v_eqs_str = ', \\qquad '.join('%s = %s' % (v_names[j], latex(T.row(j))) for j in range(ndim))

    f_vals = ['f(%s)' % vname for vname in v_names]
    f_vals_str = ','.join(f_vals)
    #f_eqs  = ['%s = %s' % (f_vals[j], latex(matW.row(j))) for j in range(ndim)]
    #f_eqs_str = ', \\quad '.join(f_eqs)

    invT = ~T
    newF = T*F*~T

    latexF = latex(F)
    latexT = latex(T)
    latexInvT = latex(invT)
    latexNewF = latex(newF)
        
    answ_str = fmt_mat_str(newF)
    	
    subs = {'$id$': str(nr+1), '$dim$': str(ndim), '$answ$': answ_str, '$T$': latexT, '$invT$': latexInvT, '$F$': latexF, '$newF$': latexNewF, '$veqs$': v_eqs_str, '$vvecs$': v_str, '$evecs$': e_str} 
    ntxt = make_subs(otxt, subs)

    full_test_path = test_path+test_name+' '+str(nr+1)+' variantas'+test_ext
    write_file(full_test_path, ntxt)    

    #test printout
    print('::::::::::::::::::::::::')
    print('[old F]=')
    print(F)
    print('T=')
    print(T)
    print('T^(-1)=')
    print(~T)
    print('[new F]=')
    print(newF)
    print('\n')
