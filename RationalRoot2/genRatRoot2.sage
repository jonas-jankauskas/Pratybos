load('../matrix_utils.sage')

#---------------------------------------------------------------------
#the following parameters must be set-up before launching this script:

#maximal prime
try:
    pr_max
except NameError:
    pr_max = 7

#size of coefficients
try:
    h_max
except NameError:
    h_max = 20

#maximal number of divisors
try:
    div_max
except:
    div_max=8

#minimal number of divisors
try:
    div_min
except:
    div_min=6
    

#maximal number of zero terms
try:
    z_max
except:
    z_max = 1

#number of divisors
try:
    p_min
except:
    p_min=3


#maximal number of examples
try:
    pol_max
except:
    pol_max = 1000

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
    data_name = 'rational-root-deg3'+'-h'+str(h_max)+'-p'+str(pr_max)+'-d'+str(div_min)+'-'+str(div_max)

full_data_path=data_path+data_name

#load the earlier generated data
try:
    poly_data = load(full_data_path)
except:
    poly_data = []

R.<x> = ZZ['x']

prime_lst = [1]+[pr for pr in primes(pr_max+1)]

num_lst = [pr1*pr2 for pr1 in prime_lst for pr2 in prime_lst]
num_lst += [-num for num in num_lst] 

for attempts in range(num_tries):

    p, q, r, s = tuple(sample_repl(num_lst,4))

    if abs(gcd(p,q)) > 1:
        continue

    if max([abs(p), abs(q)]) <= p_min:
        continue

    div_total = number_of_divisors(p*r)*number_of_divisors(q*s)
    if  (div_total > div_max) or (div_total < div_min):
        continue
            
    interv = [t for t in range(-h_max+1, h_max+1)]
    interv.remove(0)
    t = choice(interv)

    f = (p*x+q)*(r*x^2+t*x+s)

    if f.list()[-1] < 0:
        f = -f

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
