reset()

load('../text_utils.sage')

#---------------------------------------------------------------------
#the following parameters must be set-up before launching this script:

#number of tests to make
num_probs=20
#data file location
data_path='../Data/'
data_name = 'lin-depend'
full_data_path=data_path+data_name
#test file name location and naming
test_name='Tiesinė priklausomybė'
test_path='ProblemSet/'
test_ext='.xml'

#---------------------------------------------------------------------
#load the earlier generated data
l=var('l',latex_name='\\lambda')

try:
    vec_data = load(full_data_path)
except:
    vec_data = []

#load the template text
tmpl_file_name = 'template'
tmpl = open(tmpl_file_name, 'r')
otxt = tmpl.read()
tmpl.close()

#---------------------------------------------------------------------
problem_data = sample(vec_data, num_probs);

#print header with timestamp
print('------------------------ Test data for %s ------------------------' % get_date_time())

#make tests
for nr, vec_sys in enumerate(problem_data):

    mat = matrix(SR, len(vec_sys), vec_sys)
    det_mat = mat.det()
    sols=solve(det_mat==0,l)
    lval = l.subs(sols)

    sub1 = {'$v_{%s}$' % str(j+1) : latex(vec_sys[j]) for j in range(len(vec_sys))}
    sub2 = {'$id$': str(nr+1), '$M$': latex(mat), '$detM$': latex(det_mat), '$answ$': str(lval)}
    subs = {**sub1, **sub2}
    ntxt = make_subs(otxt, subs)

    full_test_path = test_path+test_name+' '+str(nr+1)+' variantas'+test_ext
    write_file(full_test_path, ntxt)    

    #test printout
    print('\nM =', mat.rank(), ', det(M) = ', det_mat, ', l = ', lval)
    print(mat)