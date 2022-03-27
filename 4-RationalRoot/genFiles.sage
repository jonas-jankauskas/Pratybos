reset()

import random as rnd
load('../text_utils.sage')

#---------------------------------------------------------------------
#the following parameters must be set-up before launching this script:

#number of tests to make
num_probs=20
#data file location
data_path='../Data/'
data_name = 'rational-root'
full_data_path=data_path+data_name
#test file name location and naming
test_name='Racionalioji šaknis'
test_path='ProblemSet/'
test_ext='.xml'

#---------------------------------------------------------------------
#set up polynomial ring
R.<x> = ZZ['x']

#load the earlier generated data
try:
    poly_data = load(full_data_path)
except:
    poly_data = []

#load the template text
tmpl_file_name = 'template'
tmpl = open(tmpl_file_name, 'r')
otxt = tmpl.read()
tmpl.close()

#sample uniformly  by rational roots
root_data = {f: f.roots(QQ,multiplicities=False)[0] for f in poly_data}
rep_root = set(root_data.values())
candidates = {r: [f for f in poly_data if root_data[f] == r] for r in rep_root}
#sample the data for the required number of problems
numreq = ceil(num_probs/ len(rep_root))
select = sum([rnd.sample(candidates[r], numreq) for r in rep_root],[])
problem_data = rnd.sample(select, num_probs);

#print header with timestamp
print('------------------------ Test data for %s ------------------------' % get_date_time())

#make tests
for nr, f in enumerate(problem_data):

    rt=max(f.roots(QQ, multiplicities=False)) 

    subs = {'$f$': latex(f), '$answ$': str(rt), '$id$': str(nr+1), '$sol$': latex(factor(f))}
    ntxt = make_subs(otxt, subs)
    
    full_test_path = test_path+test_name+' '+str(nr+1)+' variantas'+test_ext
    write_file(full_test_path, ntxt)
    
    #test printout
    print(f, '=', factor(f))