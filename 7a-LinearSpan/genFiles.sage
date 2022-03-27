reset()

import random as rnd
load('../text_utils.sage')

#---------------------------------------------------------------------
#the following parameters must be set-up before launching this script:

#number of tests to make
num_probs=20
#data file location
data_path='../Data/'
data_name = 'linear-span'
full_data_path=data_path+data_name
#test file name location and naming
test_name='Tiesinis apvalkalas'
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
#extract (nrow, ncols, rank) type and their matrices
mat_types = set([(mat.nrows(), mat.ncols(), mat.rank()) for mat in mat_data])
mat_class = {tp: [mat for mat in mat_data if (mat.nrows()==tp[0]) and (mat.ncols()==tp[1]) and (mat.rank()==tp[2])] for tp in mat_types}

#sample matrices by type
num_req = ceil(num_probs/ len(mat_types))
selected = sum([sample(mat_class[tp], num_req) for tp in mat_types],[])
problem_data = sample(selected, num_probs);

#print header with timestamp
print('------------------------ Test data for %s ------------------------' % get_date_time())

#make tests
for nr, mat in enumerate(problem_data):

    A = mat[:-1]
    B = mat

    v1,v2,v = tuple(mat.rows())

    subs1 = {'$id$': str(nr+1), '$A$': latex(A), '$refA$': latex(A.echelon_form()), '$rgA$': latex(A.rank()), '$B$': latex(B), '$refB$': latex(B.echelon_form()), '$rgB$': latex(B.rank()), '$v$': latex(v), '$v1$': latex(v1), '$v2$': latex(v2)}

    if A.rank() == B.rank():
        subs2 = {'$answ_str$': 'priklauso', '$not_answ_str$': 'nepriklauso', '$ineq_str$': '='}
    else:
        subs2 = {'$answ_str$': 'nepriklauso', '$not_answ_str$': 'priklauso', '$ineq_str$': '&lt'}

    subs = {**subs1, **subs2}
    ntxt = make_subs(otxt, subs)

    full_test_path = test_path+test_name+' '+str(nr+1)+' variantas'+test_ext
    write_file(full_test_path, ntxt)    

    #test printout
    print('\nRank = ', mat.rank())
    print('v_1 = ', v1, 'v_2 = ', v2, 'v = ', v)