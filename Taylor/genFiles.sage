reset()

import random as rnd

load('../text_utils.sage')
#---------------------------------------------------------------------
#the following parameters must be set-up before launching this script:

#number of tests to make
num_probs=20 

#data file naming and location
data_path='../Data/' 
data_name = 'taylor'
full_data_path=data_path+data_name

#test file naming and location
test_path='ProblemSet/'
test_name='Teiloro skleidinys'
test_ext='.xml'

#template file name
tmpl_name = 'template'

#---------------------------------------------------------------------
#set up polynomial rings
R.<t>=ZZ['t']
x=var('x')

#load the earlier generated data
try:
    poly_data = load(full_data_path)
except:
    poly_data = []

tmpl = open(tmpl_name, 'r')
otxt = tmpl.read()
tmpl.close()

#sample shifts uniformly
shifts = set([tp[2] for tp in poly_data])
numreq = ceil(num_probs/ len(shifts))
select = {s: rnd.sample([tp for tp in poly_data if tp[2]==s], numreq) for s in shifts}
problem_data = rnd.sample(sum(select.values(),[]), num_probs);

#print header with timestamp
from datetime import datetime
now = datetime.now()
time_stamp = now.strftime("%Y/%m/%d %H:%M:%S")
print('------------------------ Test data for %s ------------------------' % time_stamp)


for nr, triple in enumerate(problem_data):

    f,g,s=triple
    
    h = SR(f(x)).series(x==s,+oo)

    cfs = str(g.list())
    dels = {'[':'',']':'',' ':''} 
    answ = make_subs(cfs,dels)

    if s >= 0:
        strs = '-'+str(s)
    else:
        strs = '+'+str(abs(s))

    subs = {'$f$': latex(f(x)), '$s$': strs, '$h$': latex(h), '$answ$': answ, '$id$': str(nr+1)}
    ntxt = make_subs(otxt, subs)
    full_test_path = test_path+test_name+' '+str(nr+1)+' variantas'+test_ext
    write_file(full_test_path, ntxt)

	#test printout
    print('f(x)=', str(f(x)), '=', str(SR(f(x)).series(x==s,+oo)))