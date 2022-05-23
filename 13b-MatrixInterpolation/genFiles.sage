reset()

import random as rnd
load('../text_utils.sage')

#---------------------------------------------------------------------
#the following parameters must be set-up before launching this script:
#matrix dimensions
ndim=3
#number of tests to make
num_probs=20
#data file location
data_path='../Data/'
data_name = 'matrix-interpolation-%sx%s' % (str(ndim), str(ndim))
full_data_path=data_path+data_name
#test file name location and naming
test_name='Matricinė interpoliacija'
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
problem_data = sample(mat_data, num_probs);

#print header with timestamp
print('------------------------ Test data for %s ------------------------' % get_date_time())

#make tests
for nr, mats in enumerate(problem_data):

    matV, matW = mats

    e_str = ','.join(['e_{%s}' % str(j+1) for j in range(ndim)])
    v_names =['v_{%s}' % str(j+1) for j in range(ndim)]
    v_str = ','.join([vn for vn in v_names])
    v_eqs_str = ', \\qquad '.join('%s = %s' % (v_names[j], latex(matV.row(j))) for j in range(ndim))

    f_vals = ['f(%s)' % vname for vname in v_names]
    f_vals_str = ','.join(f_vals)
    f_eqs  = ['%s = %s' % (f_vals[j], latex(matW.row(j))) for j in range(ndim)]
    f_eqs_str = ', \\quad '.join(f_eqs)

    matVW = matV.augment(matW, subdivide=True)
    matRe = matVW.rref()
    matF = matrix((~matV)*matW)

    latexVW = latex(matVW)
    latexRe = latex(matRe)
    latexF = latex(matF)
        
    answ_str = fmt_mat_str(matF)
    	
    subs = {'$id$': str(nr+1), '$dim$': str(ndim), '$answ$': answ_str, '$VW$': latexVW, '$RREF$': latexRe, '$F$': latexF, '$feqs$': f_eqs_str, '$veqs$': v_eqs_str, '$fvals$': f_vals_str,'$vvecs$': v_str, '$evecs$': e_str} 
    ntxt = make_subs(otxt, subs)

    full_test_path = test_path+test_name+' '+str(nr+1)+' variantas'+test_ext
    write_file(full_test_path, ntxt)    

    #test printout
    print('::::::::::::::::::::::::')
    for j in range(ndim):
        print('f%s=%s' % (str(matV.row(j)), str(matW.row(j))))
    print('\n')
