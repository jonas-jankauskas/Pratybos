import random as rnd

load('../text_utils.sage')

#number of tests to make
try:
	num_probs
except NameError:
	num_probs=20

#data file path
try:
    data_path
except NameError:
    data_path='../Data/'
    
#data file name and path to it
try:
    data_name
except NameError:
    data_name = 'rational-root'

#test file name and path to it
try:
    test_name
except NameError:
    test_name='Racionalioji šaknis'

try:
    test_path
except NameError:
    test_path='ProblemSet/'

try:
    test_ext
except:
    test_ext='.xml'

full_data_path=data_path+data_name

R.<x> = ZZ['x']

#load the earlier generated data
try:
    poly_data = load(full_data_path)
except:
    poly_data = []

#load the template text
try:
    tmpl_file_name
except:
    tmpl_file_name = 'template'

tmpl = open(tmpl_file_name, 'r')
otxt = tmpl.read()
tmpl.close()

#sample the data for the required number of problems
problem_data = rnd.sample(poly_data, num_probs);

for nr, f in enumerate(problem_data):

    rt=max(f.roots(QQ, multiplicities=False)) 

    subs = {'$f$': latex(f), '$answ$': str(rt), '$id$': str(nr+1), '$sol$': latex(factor(f))}
    ntxt = make_subs(otxt, subs)

    
    full_test_path = test_path+test_name+' '+str(nr+1)+' variantas'+test_ext
    write_file(full_test_path, ntxt)