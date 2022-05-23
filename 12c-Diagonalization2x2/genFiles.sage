reset()

import random as rnd
load('../matrix_utils.sage')
load('../text_utils.sage')

#---------------------------------------------------------------------
#the following parameters must be set-up before launching this script:

#dimension
ndim=2
#number of tests to make
num_probs=20
#data file location
data_path='../Data/'
data_name = 'diagonalization-%sx%s' % (str(ndim), str(ndim))
full_data_path=data_path+data_name
#test file name location and naming
test_name='%s x %s Matricos diagonalizavimas' %(str(ndim), str(ndim))
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
#pick matrices with distinct eigenvalues only
mchars = [nice_eigenmatrix(mat) for mat in mat_data]
nroot = [len(set(tp[0].diagonal())) for tp in mchars]
nvecs = [rank(tp[1]) for tp in mchars]
mreps = list(zip(mat_data, nroot, nvecs))

#sample matrices with multiple roots only
#filtered = [(mat, nvs) for mat, nrs, nvs in mreps if nrs < ndim and nrs > 1]
#filtered = [(mat, nvs) for mat, nrs, nvs in mreps]
#select1 = [mat for mat, nvs in filtered if nvs < ndim]
#select2 = [mat for mat, nvs in filtered if nvs == ndim]
select1 = [mat for mat, nrs, nvs in mreps if nvs < ndim]
select2 = [mat for mat, nrs, nvs in mreps if nvs == ndim]
numreq1 = min(num_probs//2, len(select1))
numreq2 = min(num_probs - num_probs//2, len(select2))
problem_data = sample(select1, numreq1) + sample(select2, numreq2)
shuffle(problem_data)

#print header with timestamp
print('------------------------ Test data for %s ------------------------' % get_date_time())

#make tests
for nr, mat in enumerate(problem_data):

	#unpack eigendata:
    edata = nice_eigenvectors(mat)
    #distinct eigenvalues:
    evs = [tp[0] for tp in edata]
    #distinct eigenspaces:
    vspc = {tp[0]: tp[1] for tp in edata}
    #algebraic and geometric multiplicities
    amul = {tp[0]: tp[2] for tp in edata}
    gmul = {tp[0]: len(tp[1]) for tp in edata}

	#characteristic polynomial
    f = ((-1)**(mat.nrows()))*mat.charpoly()
    pr = factor(f)

    subs0 = {'[':'<', ']':'>'}
    
    eval_str = ['\\lambda_{%s}=%s' % (j+1, str(ev)) for j, ev in enumerate(evs)]
    amul_str = ['\\text{alg}_A(%s)=%s' % (str(ev), str(amul[ev])) for ev in evs]
    gmul_str = ['\\text{geom}_A(%s)=%s' % (str(ev), str(gmul[ev])) for ev in evs]
    subv_str = ['\\text{V}_A(%s)=%s' % (str(ev), make_subs(latex(vspc[ev]), subs0)) for ev in evs]

    eigv_str = ', \\quad '.join(eval_str)
    algm_str = ', \\quad '.join(amul_str)
    geom_str = ', \\quad '.join(gmul_str)
    spcv_str = ', \\quad '.join(subv_str)
        
    subs1 = {'$eigs$': eigv_str, '$amuls$': algm_str, '$gmuls$': geom_str, '$spcV$': spcv_str}

    if sum(gmul.values()) == ndim:
        arg_str = 'sutampa'
        dec_str = 'diagonalizuojama'
        pt1_str = '100'
        pt2_str = '0'
    else:
        arg_str = 'nesutampa'
        dec_str = 'nediagonalizuojama'
        pt1_str = '0'
        pt2_str = '100'


    subs2 = {'$arg$': arg_str, '$dec$': dec_str, '$pt1$': pt1_str, '$pt2$': pt2_str}
    subs3 = {'$dim$': str(ndim), '$A$':latex(mat), '$f$': latex(f), '$factor$': latex(pr), '$id$': str(nr+1)}
    
    subs = {**subs1, **subs2, **subs3}
    ntxt = make_subs(otxt, subs)

    full_test_path = test_path+test_name+' '+str(nr+1)+' variantas'+test_ext
    write_file(full_test_path, ntxt)    

    #printout
    D, T = nice_eigenmatrix(mat)
    print(':::::::::::::::::')
    print('M =')
    print(mat)
    print('D =')
    print(D)
    print('T =')
    print(T)
