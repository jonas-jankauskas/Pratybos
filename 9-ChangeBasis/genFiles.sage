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
data_name = 'change-basis'
full_data_path=data_path+data_name
#test file name location and naming
test_name='Koordinačių keitimas'
test_path='ProblemSet/'
test_ext='.xml'

#---------------------------------------------------------------------
#load the earlier generated data
try:
    mat_vec_data = load(full_data_path)
except:
    mat_vec_data = []

#load the template text
tmpl_file_name = 'template'
tmpl = open(tmpl_file_name, 'r')
otxt = tmpl.read()
tmpl.close()

#---------------------------------------------------------------------
problem_data = sample(mat_vec_data, num_probs);

#print header with timestamp
print('------------------------ Test data for %s ------------------------' % get_date_time())

#make tests
for nr, tp in enumerate(problem_data):

    A, B, vec = tp

    ndim = A.ncols()
    
    vecV = A.columns()
    vecW = B.columns()

    mat = A.augment(B, subdivide=True)
    rmat =mat.rref()

    S = (~A)*B

    nvec = S*vec

    vecNames = [('w%s,' % str(j+1)) for j in range(ndim)]
    vecNameStr = str().join(vecNames)[:-1]
    vecVars = var(vecNameStr)

    expr_str = latex_linear_combination_lax(vec, vecVars)

    answ_str = make_subs(str(nvec), {' ':''})

    subs1 = {'$v'+str(k+1)+'$': str(v) for k, v in enumerate(vecV)}
    subs2 = {'$w'+str(j+1)+'$': str(w) for j, w in enumerate(vecW)}
    subs3 = {'$vecB$': str(vec), '$mat$': latex(mat), '$rmat$': latex(rmat), '$T$': latex(S.T)}
    subs4 = {'$id$': str(nr+1), '$dim$': str(ndim), '$answ$': answ_str, '$expr$': expr_str}
    
    subs = {**subs1, **subs2, **subs3, **subs4}
    ntxt = make_subs(otxt, subs)

    full_test_path = test_path+test_name+' '+str(nr+1)+' variantas'+test_ext
    write_file(full_test_path, ntxt)    

    #test printout
    print('Old basis A=', str(A.columns()))
    print('New basis B=', str(B.columns()))
    print('u=', vec*vector(vecVars))
    print('Old coordinates u=', nvec)
    print('\n')
