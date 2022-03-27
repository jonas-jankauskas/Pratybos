reset()
load('../text_utils.sage')

#---------------------------------------------------------------------
#the following parameters must be set-up before launching this script:

#number of tests to make
num_probs=20

#data file location
data_path='../Data/'
data_name = 'poly-gcd'
full_data_path=data_path+data_name

#test file name location and naming
test_name='Daugianarių DBD'
test_path='ProblemSet/'
test_ext='.xml'

#---------------------------------------------------------------------
#load earlier generated data

try:
    poly_data = load(full_data_path)
except:
    poly_data = []

#load the template text
try:
    tmpl_file_name
except:
    tmpl_file_name = 'template'

#load template text
tmpl = open(tmpl_file_name, 'r')
otxt = tmpl.read()
tmpl.close()

#print header with timestamp
from datetime import datetime
now = datetime.now()
time_stamp = now.strftime("%Y/%m/%d %H:%M:%S")
print('------------------------ Test data for %s ------------------------' % time_stamp)

poly_pairs = sample(poly_data, num_probs)

for nr, pair in enumerate(poly_pairs):

    f, g = pair
    d, u, v = f.xgcd(g)
    
    eq_str = '<p dir=\"ltr\" style=\"text-align: left;\">ATSAKYMAS: \\( %s =  (%s) \\cdot (%s) + (%s) \\cdot (%s) \\)<br></p>' % (latex(d), latex(u), latex(f), latex(v), latex(g))

    p, q = f, g
    if q.degree() >= p.degree():
        p, q = q, p
    sol_str = ''
    while (q != 0):   
        s, r = p.quo_rem(q)
        sol_str += '<p dir=\"ltr\" style=\"text-align: left;\">\\(%s = (%s) \\cdot (%s) + (%s)\\)<br></p>' % (latex(p), latex(s), latex(q), latex(r))
        p = q
        q = r
    sol_str += eq_str

    d_str = str(d.list()[::-1])
    u_str = str(u.list()[::-1])
    v_str = str(v.list()[::-1])
	
    answ_str = '%s;%s;%s' % (d_str, u_str, v_str)
    dels = {' ':'', '[':'', ']':''} #remove spaces and brackets
    answ_str = make_subs(answ_str, dels)
			
    subs = {'$id$': str(nr+1), '$f$':latex(f), '$g$':latex(g),'$gcd$': latex(d),'$u$': latex(u), '$v$': latex(v), '$sol$': sol_str, '$answ$': answ_str}
    ntxt = make_subs(otxt, subs)
        
    full_test_path = test_path+test_name+' '+str(nr+1)+' variantas'+test_ext
    write_file(full_test_path, ntxt)
    
    #test printout
    print('f(x)= %s, g(x)=%s | gcd(f, g) = %s = (%s)*f(x)+(%s)*g(x)' % (str(f), str(g), str(d), str(u), str(v)))