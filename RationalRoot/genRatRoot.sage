
load('../matrix_utils.sage')

#---------------------------------------------------------------------
#the following parameters must be set-up before launching this script:

#maximal prime
try:
    prime_max
except NameError:
    prime_max = 7

#size of coefficients
try:
    h_max
except NameError:
    h_max = 10

#maximal number of divisors
try:
    div_max
except NameError:
    div_max=8

#minimal number of divisors
try:
    div_min
except NameError:
    div_min=6
    
#maximal number of zero terms
try:
    z_max
except NameError:
    z_max = 1

#minimal allowed numerator
try:
    q_min
except NameError:
    q_min=2
    
#minimal allowed denominator
try:
	p_min
except NameError:
	p_min = 2

#minimal complexity of a rational root:
try:
    pq_min
except NameError:
    pq_min=3


#maximal number of examples
try:
    pol_max
except:
    pol_max = 10000

#number of tries
try:
    num_tries
except:
    num_tries = 10000

#data file path
try:
    data_path
except NameError:
    data_path='../Data/'
    
#data file names
try:
    data_name
except NameError:
    data_name = 'rational-root'

full_data_path=data_path+data_name

#load the earlier generated data
try:
    poly_data = load(full_data_path)
except:
    poly_data = []

R.<x> = ZZ['x']

num_lst = [num for num in range(-h_max, h_max+1) if (num_div(num) <= div_max) and (largest_prime_factor(num) <= prime_max)]

p_lst = [num for num in num_lst if num >= p_min]
q_lst = [num for num in num_lst if abs(num) >= q_min]
r_lst = [num for num in num_lst if num > 0]

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
