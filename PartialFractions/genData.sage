reset()

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

roots_lst = [num for num in range(-r_max, r_max+1)]
quads_lst = [ (num1, num2) for num1 in roots_lst for num2 in roots_lst if num1^2 < 4*num2]
const_lst = [num for num in range(-c_max, c_max+1)]

print('------------------------ New data ------------------------')

for attempts in range(num_tries):

	#if too much data already...
    if len(poly_data) >= pol_max:
        break

	#real roots
    a, b, c  = tuple(sample(roots_lst, 3))

    #quadratic term
    p, q = choice(quads_lst)

	#numerator constants
    A,B,C = tuple(sample(const_lst,3))

	#if too many zeros then skip
    if [a,b,c,p,q].count(0) > z_max:
        continue
    if [A, B, C].count(0) > z_max:
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

    small_fracs=filter(lambda poly: (poly.numerator().norm(+oo) <= h_max) and (poly.denominator().norm(+oo) <= h_max), new_fracs)
	            
    for poly in small_fracs:
        if poly not in poly_data:
            poly_data.append(poly)
            print(poly, '=', SR(poly).partial_fraction())
        
save(poly_data, full_data_path)