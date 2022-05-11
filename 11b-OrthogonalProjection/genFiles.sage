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
data_name = 'orthogonal-projection'
full_data_path=data_path+data_name
#test file name location and naming
test_name='Ortogonali projekcija'
test_path='ProblemSet/'
test_ext='.xml'

#---------------------------------------------------------------------
#load the earlier generated data
try:
    vec_mat_data = load(full_data_path)
except:
    vec_mat_data = []

#---------------------------------------------------------------------
#load the template text
tmpl_file_name = 'template'
tmpl = open(tmpl_file_name, 'r')
otxt = tmpl.read()
tmpl.close()

#---------------------------------------------------------------------
#group  matrices by height of first row-vector
hreps = [mat.row(0).norm(+oo) for mat, vec in vec_mat_data]
mreps = list(zip(vec_mat_data, hreps))
hkeys = set(hreps)
dreps = {k: [tp for tp, h in mreps if h == k] for k in hkeys}

#sample data uniformly by height of Q factor
selected_data = []
num_req = ceil(num_probs/len(hkeys))

for k in dreps.keys():
    selected_data += sample(dreps[k], min(num_req, len(dreps[k])))
    
problem_data = sample(selected_data, min(num_probs, len(selected_data)))

#print header with timestamp
print('------------------------ Test data for %s ------------------------' % get_date_time())

#make tests
for nr, tp in enumerate(problem_data):

    mat, vec = tp

    ndim = mat.ncols()
    Q,L = nice_GramSchmidtZ(mat)

    subs = {' ' : '', '[' : '<', ']' : '>'}

    pvec  = proj(vec, mat)
    ovec  = orth(vec, mat) 

    vec_str = make_subs(str(vec), subs)
    pro_str = make_subs(str(pvec), subs)
    ort_str = make_subs(str(ovec), subs)

    strW = make_subs(str(mat.rows()), subs)
    
    strU= [make_subs(str(u), subs) for u in mat.rows()]
    subU= {'$w%s$'%str(j+1) : vec_str for j, vec_str in enumerate(strU)}
    
    strV=[make_subs(str(v), subs) for v in Q.rows()]
    subV={'$v%s$'%str(j+1) : vec_str for j, vec_str in enumerate(strV)}
    
    answ_str = ';'.join([pro_str, ort_str])
    
    eqs_str = latex_GramSchmidt_eqs(Q,L, 'u', 'v')
    sub_eqs ={'$eq%s$' % str(j+1) : eq for j, eq in enumerate(eqs_str)}

    sub_oth = {'$id$': str(nr+1), '$dim$': str(ndim), '$vec$': vec_str, '$W$': strW, '$pro$': pro_str, '$ort$': ort_str, '$answ$': answ_str}
    subs = {**subU, **subV, **sub_eqs, **sub_oth}
    ntxt = make_subs(otxt, subs)

    full_test_path = test_path+test_name+' '+str(nr+1)+' variantas'+test_ext
    write_file(full_test_path, ntxt)    

    #test printout
    print('::::::::::::')    
    print('W basis:            ', mat.rows(), '\n')
    print('W orthogonal basis: ', Q.rows(), '\n')
    print('vec = ', vec, 'proj = ', pvec, 'ort = ', ovec, '\n')