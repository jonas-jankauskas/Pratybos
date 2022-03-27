reset()

import random as rnd
load('../text_utils.sage')

#---------------------------------------------------------------------
#the following parameters must be set-up before launching this script:

#number of tests to make
num_probs=20
#data file location
data_path='../Data/'
data_name = 'matrix-rank'
full_data_path=data_path+data_name
#test file name location and naming
test_name='Matricos rangas'
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
  
    subs = {'$id$': str(nr+1), '$matrix$': latex(mat), '$echform$': latex(mat.echelon_form()), '$answ$': str(mat.rank())}
    ntxt = make_subs(otxt, subs)

    full_test_path = test_path+test_name+' '+str(nr+1)+' variantas'+test_ext
    write_file(full_test_path, ntxt)    

    #test printout
    print('\nRank =', mat.rank())
    print(mat)