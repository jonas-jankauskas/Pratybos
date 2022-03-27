#the following parameters must be set-up before launching this script:
#---------------------------------------------------------------------
#smallest and largest primes in the factorization of a and b
min_prime = 17
max_prime = 199
#gcd bound
max_gcd   = 99
#ranges for a and b, a > b
min_b = 1000
max_b = 4000
max_a = 9999
#max. quotient in  Euclidean algorithm
max_quo = 20
#number of steps in Euclidean algorithm
len_exp = 4
#maximal number of pairs to generate
num_pairs = 10000
#number of attempts
num_tries = 10000
#data file location
data_path='../Data/'
data_name = 'integer-gcd'
full_data_path=data_path+data_name

#load generated data
try:
    number_data = load(full_data_path)
except:
    number_data = []
#---------------------------------------------------------------------
prime_list = prime_range(min_prime, max_prime+1)
gcd_list = [p for p in prime_list if p <= max_gcd]

#print header with timestamp
from datetime import datetime
now = datetime.now()
time_stamp = now.strftime("%Y/%m/%d %H:%M:%S")
print('------------------------ New data for %s ------------------------' % time_stamp)

for attempts in range(num_tries):

    if len(number_data) > num_pairs:
        break;

    c = choice(gcd_list)
    a, b = tuple(sample(prime_list, 2))
    a = a*c
    b = b*c
    if a < b:
        a, b = b, a

    if (b < min_b) or (b > max_b) or (a > max_a):
        continue
    
    cf = continued_fraction(a/b)
    #test if expansion is within parameters and skip the most often ones with many quotients=1
    if (len(cf) != len_exp) or (max(cf) > max_quo) or (cf.quotients().count(1) > 1):
        continue

    if (a, b) not in number_data:
        number_data.append((a, b))
        print(a, b, xgcd(a, b), cf)

#save the generated data
number_data.sort()
save(number_data, full_data_path)