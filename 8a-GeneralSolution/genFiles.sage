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
data_name = 'general-solution'
full_data_path=data_path+data_name
#test file name location and naming
test_name='Bendrasis TLS sprendinys'
test_path='ProblemSet/'
test_ext='.xml'

#---------------------------------------------------------------------
#load the earlier generated data
try:
    vec_mat_data = load(full_data_path)
except:
    vec_mat_data = []

#load the template text
tmpl_file_name = 'template'
tmpl = open(tmpl_file_name, 'r')
otxt = tmpl.read()
tmpl.close()

#---------------------------------------------------------------------
problem_data = sample(vec_mat_data, num_probs);

#print header with timestamp
print('------------------------ Test data for %s ------------------------' % get_date_time())

#make tests
for nr, tp in enumerate(problem_data):

    A, b, = tp

    xnames = str().join(['x'+str(j+1)+',' for j in range(A.ncols())])[:-1]
    xvars = var(xnames)
    xvec = vector(xvars)
    xvec_str = latex(xvec)

    rA = A.augment(b).rref()

    syst_str = latex_SLE(A,b, 'x')
    rsys_str = latex_SLE(rA[:,:-1],rA.column(-1),'x')

    psol, hsols = standard_solution_SLE(A,b)
    psol_str = str(psol)
    hsols_str = str().join([str(h)+';' for h in hsols])[:-1]
    sol_str = '%s = %s + < %s >' % (xvec_str, psol_str, hsols_str) 
    answ_str = psol_str+';'+hsols_str

    subs = {' ':'', '[':'', ']':''}
    sol_str=make_subs(sol_str, subs)
    answ_str=make_subs(answ_str, subs)
    

    subs = {'$id$': str(nr+1), '$vrs$': xvec_str, '$dim$': latex(A.ncols()), '$sys$': syst_str, '$rsys$': rsys_str,'$sol$':sol_str,  '$answ$': answ_str}
    ntxt = make_subs(otxt, subs)

    full_test_path = test_path+test_name+' '+str(nr+1)+' variantas'+test_ext
    write_file(full_test_path, ntxt)    

    #test printout
    print('A=')
    print(A)
    print('rank(A)=', A.rank())
    print('b = ', b)
    print(sol_str)
    print('\n')