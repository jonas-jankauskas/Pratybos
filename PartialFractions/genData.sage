reset()

import itertools as itt

#---------------------------------------------------------------------
#the following parameters must be set-up before launching this script:

#height of numerator and denominator
h_max = 10 
#root bounds
r_max = 5
#coefficient bounds
c_max = 5
#maximal number of zeros among roots
z_max = 1
#bound on the number of examples
pol_max = 10000
#number of tries
num_tries = 10000
#data file location
data_path='../Data/'
data_name = 'partial-fraction'

full_data_path=data_path+data_name

#---------------------------------------------------------------------
#set up polynomial ring and its fraction field
R.<x>=QQ['x']
K = R.fraction_field()

#load generated data
try:
    poly_data = load(full_data_path)
except:
    poly_data = []

num_lst = [num for num in range(-r_max, r_max+1)]
roots_lst = [num for num in num_lst if num != 0]
quads_lst = [tp for tp in itt.product(num_lst, num_lst) if tp[0]^2 < 4*tp[1]]
const_lst = [tp for tp in itt.product([c for c in range(-c_max, c_max+1) if c != 0], repeat=3)]

#print header with timestamp
from datetime import datetime
now = datetime.now()
time_stamp = now.strftime("%Y/%m/%d %H:%M:%S")
print('------------------------ New data for %s ------------------------' % time_stamp)

for attempts in range(num_tries):

	#if too much data already...
    if len(poly_data) >= pol_max:
        break

	#real roots
    a, b, c  = tuple(sample(roots_lst, 3))

    #quadratic term
    p, q = choice(quads_lst)

	#numerator constants
    A,B,C = choice(const_lst)

	#if too many zeros then skip
    if [a,b,c,p,q].count(0) > z_max:
        continue

    if abs(gcd([A,B,C])) > 1:
        continue

    new_fracs =[]
    
    if A*B*C != 0:
        new_fracs.append(A/(x-a)+B/(x-b)+C/(x-c))

    if B*C != 0:
        new_fracs.append(A/(x-a)+B/(x-a)^2+C/(x-b))

    if C*a != 0:
        new_fracs.append(A/(x-a)+B/(x-a)^2+C/(x-a)^3)

    if A*(B^2+C^2) != 0:
        new_fracs.append(A/(x-a)+(B*x+C)/(x^2+p*x+q))

    small_fracs=filter(lambda poly: (poly.numerator().norm(+oo) <= h_max), new_fracs)
	            
    for poly in small_fracs:
        if poly not in poly_data:
            poly_data.append(poly)
            print(poly, '=', SR(poly).partial_fraction())
        
save(poly_data, full_data_path)
