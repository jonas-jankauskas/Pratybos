reset()
load('../text_utils.sage')

#---------------------------------------------------------------------
#the following parameters must be set-up before launching this script:

#number of tests to make
num_probs=20

#data file location
data_path='../Data/'
data_name = 'integer-gcd'
full_data_path=data_path+data_name

#test file name location and naming
test_name='Sveikųjų skaičių DBD'
test_path='ProblemSet/'
test_ext='.xml'

#---------------------------------------------------------------------
#load earlier generated data

try:
    number_data = load(full_data_path)
except:
    number_data = []

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

int_pairs = sample(number_data, num_probs)

for nr, pair in enumerate(int_pairs):

    a, b = pair
    d, u, v = xgcd(a, b)
    
    s = ' - '
    if v >= 0:
        s = ' + '
    eq_str = '<p dir=\"ltr\" style=\"text-align: left;\">\\('+str(d)+' = '+str(u)+'\\cdot'+str(a)+s+str(abs(v))+'\\cdot'+str(b)+'\\)<br></p>'

    x, y = a, b
    if y > x:
        x, y = y, x
    sol_str = ''
    while (y != 0):   
        q, r = x.quo_rem(y)
        sol_str += '<p dir=\"ltr\" style=\"text-align: left;\">\\('+str(x)+' = '+ str(q)+'\\cdot'+str(y)+' + '+str(r)+'\\)<br></p>'
        x = y
        y = r
    sol_str += eq_str
			
    subs = {'$id$': str(nr+1), '$a$':str(a), '$b$':str(b),'$gcd$': str(d),'$u$':str(u), '$v$':str(v), '$sol$':sol_str}
    ntxt = make_subs(otxt, subs)
        
    full_test_path = test_path+test_name+' '+str(nr+1)+' variantas'+test_ext
    write_file(full_test_path, ntxt)
    
    #test printout
    print('a=', a, ' b=', b, ' gcd(a, b) = ', d, ' = ', str(u)+'a'+s+str(abs(v))+'b')