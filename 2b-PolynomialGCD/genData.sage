reset()
import itertools as itt
load('../matrix_utils.sage')

#the following parameters must be set-up before launching this script:
#---------------------------------------------------------------------
#maximal height of partial quotients and GCD
max_c = 5
#maximal heights of f(x) and g(x)
max_h = 10
#no. of zeros allowed among coefficients of f(x) and g(x)
max_z   = 1
#number of steps in Euclidean algorithm
len_exp = 3
#maximal number of pairs to generate
num_pairs = 1000
#number of attempts
num_tries = 10000
#data file location
data_path='../Data/'
data_name = 'poly-gcd'
full_data_path=data_path+data_name


#polynomial ring
R.<x>=ZZ['x']

#load generated data
try:
    poly_data = load(full_data_path)
except:
    poly_data = []

#---------------------------------------------------------------------
cfs_list = [c for c in range(-max_c, max_c+1)]
cfs_tuples = itt.product(cfs_list, repeat=2)
quo_list = [x+c for c in cfs_list if c !=0]
gcd_list = [x^2+a*x+b for a,b in cfs_tuples if b != 0]

#print header with timestamp
from datetime import datetime
now = datetime.now()
time_stamp = now.strftime("%Y/%m/%d %H:%M:%S")
print('------------------------ New data for %s ------------------------' % time_stamp)

for attempts in range(num_tries):

    if len(poly_data) > num_pairs:
        break;

    h = choice(gcd_list)
    
    cfr = sample_repl(quo_list,3)
    cfr[0] = R(1) #set first polynomial in the list = constant

    poly_frc = cfrac_to_rfun(cfr)
    f = poly_frc.numerator()
    g = poly_frc.denominator()
    
    f = f*h
    g = g*h

    if f.list()[-1] < 0:
        f = -f

    if g.list()[-1] < 0:
        g = -g

    cfr = rfunc_to_cfrac(f/g)
    #test if expansion is within parameters or skip it
    if (f.list().count(0) > max_z) or (g.list().count(0) > max_z) or (f.norm(+oo) > max_h) or (g.norm(+oo) > max_h) or (abs(gcd((f*g).list()))>1):
        continue

    if ((f, g) in poly_data) or ((g,f) in poly_data):
        continue 

    poly_data.append((f, g))
    print('f(x)=',f, 'g(x)=', g, ' | ', f.xgcd(g), ' | ', cfr)

#save generated data
poly_data.sort()
save(poly_data, full_data_path)