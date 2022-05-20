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
data_name = 'gram-schmidt'
full_data_path=data_path+data_name
#test file name location and naming
test_name='Gramo-Šmito procedūra'
test_path='ProblemSet/'
test_ext='.xml'

#---------------------------------------------------------------------
#load the earlier generated data
try:
    gs_mat_data = load(full_data_path)
except:
    gs_mat_data = []

#load the template text
tmpl_file_name = 'template'
tmpl = open(tmpl_file_name, 'r')
otxt = tmpl.read()
tmpl.close()

#---------------------------------------------------------------------
#group matrices by height of Q factor
hreps = [(nice_GramSchmidtZ(mat))[0].height() for mat in gs_mat_data]
mreps = list(zip(gs_mat_data, hreps))
hkeys = set(hreps)
dreps = {k: [mat for mat,h in mreps if h == k] for k in hkeys}

#sample data uniformly by height of Q factor
selected_data = []
num_req = ceil(num_probs/len(hkeys))

for k in dreps.keys():
    selected_data += sample(dreps[k], num_req)
    
problem_data = sample(selected_data, num_probs)

#print header with timestamp
print('------------------------ Test data for %s ------------------------' % get_date_time())

#make tests
for nr, mat in enumerate(problem_data):

    ndim = mat.ncols()
    Q,L = nice_GramSchmidtZ(mat)

    subs = {' ' : ''}

    strU= [make_subs(str(u), subs) for u in mat.rows()]
    subU= {'$u%s$'%str(j+1) : vec_str for j, vec_str in enumerate(strU)}
    
    strV=[make_subs(str(v), subs) for v in Q.rows()]
    subV={'$v%s$'%str(j+1) : vec_str for j, vec_str in enumerate(strV)}
    answ_str = ';'.join(strV)
    
    eqs_str = latex_GramSchmidt_eqs(Q,L, 'u', 'v')
    sub_eqs ={'$eq%s$' % str(j+1) : eq for j, eq in enumerate(eqs_str)}

    sub_oth = {'$id$': str(nr+1), '$dim$': str(ndim), '$answ$': answ_str}
    subs = {**subU, **subV, **sub_eqs, **sub_oth}
    ntxt = make_subs(otxt, subs)

    full_test_path = test_path+test_name+' '+str(nr+1)+' variantas'+test_ext
    write_file(full_test_path, ntxt)    

    #test printout
    print(':::::::::::::::::::::::::::')    
    print(mat, '\n')
    print( Q, '\n')
    print(L, '\n')