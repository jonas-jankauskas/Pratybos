reset()

import random as rnd
load('../matrix_utils.sage')
load('../text_utils.sage')

#---------------------------------------------------------------------
#the following parameters must be set-up before launching this script:

#dimension
ndim=3
#number of tests to make
num_probs=20
#data file location
data_path='../Data/'
data_name = 'eigenvectors-%sx%s' % (str(ndim), str(ndim))
full_data_path=data_path+data_name
#test file name location and naming
test_name='%s x %s Tikrinės reikšmės ir vektoriai' %(str(ndim), str(ndim))
test_path='ProblemSet/'
test_ext='.xml'

#---------------------------------------------------------------------
#load the earlier generated data
try:
    mat_data = load(full_data_path)
except:
    mat_data = []

#---------------------------------------------------------------------
#load the template text
tmpl_file_name = 'template'
tmpl = open(tmpl_file_name, 'r')
otxt = tmpl.read()
tmpl.close()

#---------------------------------------------------------------------
#only pick matrices with 3 distinct eigenvlaues
mtyps = [len(set(mat.eigenvalues())) for mat in mat_data]
mreps = list(zip(mat_data, mtyps))

#sample data
selected_data = [mat for mat, mtype in mreps if mtype==ndim]
problem_data = sample(selected_data, min(num_probs, len(selected_data)))

#print header with timestamp
print('------------------------ Test data for %s ------------------------' % get_date_time())

#make tests
for nr, mat in enumerate(problem_data):

    D,T = nice_eigenmatrix(mat)
    dg = D.diagonal()
    f = -mat.charpoly()
    pr = factor(f)

    evs_str = ','.join([str(ev) for ev in dg])
    vec_str = ';'.join([str(v) for v in T.rows()])
    answ_str = ';'.join([evs_str,vec_str])
    subs = {' ' : ''}
    answ_str = make_subs(answ_str, subs)

    subs1 = {'$dim$': str(ndim), '$A$':latex(mat), '$f$': latex(f), '$factor$': latex(pr), '$id$': str(nr+1), '$answ$': answ_str}
    subs2 = {'$l%s$' % str(j+1): latex(ev) for j, ev in enumerate(dg)}
    subs3 = {'$v%s$' % str(j+1): latex(v) for j, v in enumerate(T.rows())}
    
    subs = {**subs1, **subs2, **subs3}
    ntxt = make_subs(otxt, subs)

    full_test_path = test_path+test_name+' '+str(nr+1)+' variantas'+test_ext
    write_file(full_test_path, ntxt)    

    #printout
    print(':::::::::::::::::')
    print('M =')
    print(mat)
    print('D =')
    print(D)
    print('T =')
    print(T)