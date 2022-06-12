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
data_name = 'particular-solution'
full_data_path=data_path+data_name
#test file name location and naming
test_name='Atskirasis TLS sprendinys'
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

    A, b, r = tp
    t = r*A
	
    xnames = str().join(['x'+str(j+1)+',' for j in range(A.ncols())])[:-1]
    xvars = var(xnames)
    xvec = vector(xvars)

    texpr_str = latex_lin_comb_lax(t,xvars)

    rA = A.augment(b).rref()

    syst_str = latex_SLE(A,b, 'x', eol_str='')
    rsys_str = latex_SLE(rA[:,:-1],rA.column(-1),'x', eol_str='')

    psol, hsols = standard_solution_SLE(A,b)
    psol_str = str(psol)
    
    answ_str = str(r*b)
	
    subs = {'$id$': str(nr+1), '$vrs$': latex(xvec), '$dim$': latex(A.ncols()), '$expr$': texpr_str, '$sys$': syst_str, '$rsys$': rsys_str,'$psol$':psol_str,  '$answ$': answ_str}
    ntxt = make_subs(otxt, subs)

    full_test_path = test_path+test_name+' '+str(nr+1)+' variantas'+test_ext
    write_file(full_test_path, ntxt)    

    #test printout
    print('A=')
    print(A)
    print('rank(A)=', A.rank())
    print('b = ', b, 't = ', t, 't*x = ', r*b)
    
