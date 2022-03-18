reset()
load('../matrix_utils.sage')

#---------------------------------------------------------------------
#the following parameters must be set-up before launching this script:

#maximal prime
prime_max = 7
#size of coefficients
h_max = 250
#maximal number of divisors
div_max=8
#minimal number of divisors
div_min=6
#maximal number of zero terms
z_max = 1
#minimal allowed numerator
q_min=2
#minimal allowed denominator
p_min = 2
#minimal complexity of a rational root:
pq_min=3
#maximal number of examples
pol_max = 10000
#number of tries
num_tries = 10000
#data file location
data_path='../Data/'
data_name = 'rational-root'

full_data_path=data_path+data_name

#---------------------------------------------------------------------
#set up polynomial ring
R.<x>=ZZ['x']

#load the earlier generated data
try:
    poly_data = load(full_data_path)
except:
    poly_data = []

num_lst = [num for num in range(-h_max, h_max+1) if (num_div(num) <= div_max) and (largest_prime_factor(num) <= prime_max)]

p_lst = [num for num in num_lst if num >= p_min]
q_lst = [num for num in num_lst if abs(num) >= q_min]
r_lst = [num for num in num_lst if num > 0]

#print header with timestamp
from datetime import datetime
now = datetime.now()
time_stamp = now.strftime("%Y/%m/%d %H:%M:%S")
print('------------------------ New data for %s ------------------------' % time_stamp)

for attempts in range(num_tries):

    p = choice(p_lst)
    q = choice(q_lst)

    if abs(gcd(p,q)) > 1:
        continue

	#when numerators and denominars too small...
    if max([abs(p), abs(q)]) <= pq_min:
        continue

    r = choice(r_lst)
    s = choice(num_lst)

    if abs(r*s)==1:
    	continue

    div_total = number_of_divisors(p*r)*number_of_divisors(q*s)
    if  (div_total < div_min) or (div_total > div_max):
        continue
            
    interv = [t for t in range(-h_max, h_max+1)]
    interv.remove(0)
    t = choice(interv)

    f = (p*x+q)*(r*x^2+t*x+s)

    maxc = f.norm(+oo)
    cnt0 = f.list().count(0)
    con = abs(f.content())
    
    if (t^2-4*r*s).is_square() or (maxc > h_max) or (cnt0 > z_max) or (con>1):
        continue
        
    if len(poly_data) >= pol_max:
        break
        
    if f not in poly_data:
        poly_data.append(f)
        print(f, '=', factor(f))
        
save(poly_data, full_data_path)
