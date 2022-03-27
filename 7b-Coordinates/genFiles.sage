reset()

import random as rnd
load('../text_utils.sage')

#---------------------------------------------------------------------
#the following parameters must be set-up before launching this script:

#number of tests to make
num_probs=20
#data file location
data_path='../Data/'
data_name = 'vector-coordinates'
full_data_path=data_path+data_name
#test file name location and naming
test_name='Koordinatės bazėje'
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

    vec, mat = tp
    v1,v2,v3 = tuple(mat.rows())
    coord = vec*(mat.inverse())

    subs={' ':''}
    answ_str = make_subs(str(coord), subs)

    sys_str = latex_LSE(mat.transpose(), vec, 'c')
	
    subs = {'$id$': str(nr+1), '$v$': latex(vec), '$v1$': latex(v1), '$v2$': latex(v2), '$v3$': latex(v3), '$answ$': answ_str, '$sys$': sys_str}
    ntxt = make_subs(otxt, subs)

    full_test_path = test_path+test_name+' '+str(nr+1)+' variantas'+test_ext
    write_file(full_test_path, ntxt)    

    #test printout
    print('v_1 = ', v1, 'v_2 = ', v2, 'v_3 = ', v3, 'v = ', vec)