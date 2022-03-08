import random as rnd

load('../text_utils.sage')

#data file path
try:
    data_path
except NameError:
    data_path='../Data/' 
#data file names
try:
    data_name
except NameError:
    data_name = 'horner-deg'+str(deg)+'-h'+str(h_max)+'-c'+str(c_max)+'-s'+str(s_max)
full_data_path=data_path+data_name

try:
    test_name
except NameError:
    test_name='Teiloro skleidinys'

try:
    test_path
except NameError:
    test_path='ProblemSet/'

try:
    test_ext
except:
    test_ext='.xml'

#load the earlier generated data
try:
    poly_data = load(full_data_path)
except:
    poly_data = []

try:
    tmpl_file_name
except:
    tmpl_file_name = 'template'

tmpl = open(tmpl_file_name, 'r')
otxt = tmpl.read()
tmpl.close()

x=var('x')

problem_data = rnd.sample(poly_data, num_probs);

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
