reset()
load('../text_utils.sage')

#---------------------------------------------------------------------
#the following parameters must be set-up before launching this script:

#number of tests to make
num_probs=20
#data file location
data_path='../Data/'
data_name = 'poly-long-div'
full_data_path=data_path+data_name
#test file name location and naming
test_name='Daugianarių dalyba kampu'
test_path='ProblemSet/'
test_ext='.xml'

#---------------------------------------------------------------------
#set up polynomial rings
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

problem_data = sample(poly_data, num_probs);

#print header with timestamp
from datetime import datetime
now = datetime.now()
time_stamp = now.strftime("%Y/%m/%d %H:%M:%S")
print('------------------------ Test data for %s ------------------------' % time_stamp)


for nr, tp in enumerate(problem_data):

    f, g = tp
    q, r  = f.quo_rem(g)
	
    dels = {'[' : '', ']' : '', ' ' : ''}
    cfs_list = q.list()
    cfs_list.reverse()
    answ_str = make_subs(str(cfs_list), dels)

    print_str = str(f)+'=('+str(g)+')('+str(q)+') + ('+str(r)+')'
    sol_str = latex(f)+'=('+latex(g)+')('+latex(q)+') + ('+latex(r)+')'
	
    subs = {'$id$': str(nr+1), '$f$':latex(f), '$g$':latex(g), '$q$':latex(q), '$r$':latex(r),'$answ$': answ_str, '$sol$': sol_str}
    ntxt = make_subs(otxt, subs)

    full_test_path = test_path+test_name+' '+str(nr+1)+' variantas'+test_ext
    write_file(full_test_path, ntxt)
     
    #test printout
    print(print_str)