#---------------------------------------------------------------------
#the following parameters must be set-up before launching this script:
try:
    res_max
except NameError:
    res_max = 20
try:
    exp_len
except NameError:
    exp_len = 4
try:
    lo_prime
except NameError:
    lo_prime = 17
try:
    hi_prime
except NameError:
    hi_prime = 199
try:
    lo_b
except NameError:
    lo_b = 1000
try:
    hi_b
except NameError:
    hi_b = 4000
try:
    hi_a
except NameError:
    hi_a = 16000
try:
    pair_num
except NameError:
    pair_num = 20
#---------------------------------------------------------------------

prime_list = [pr for pr in primes(hi_prime+1) if pr >= lo_prime]

int_pairs = []

while len(int_pairs) < pair_num:
    divlist = sample(prime_list, 3)
    a = divlist[0]*divlist[1]
    b = divlist[0]*divlist[2]
    if a < b:
        a, b = b, a
    cf = continued_fraction(a/b)
    if (b > lo_b) and (b < hi_b) and (a < hi_a) and (len(cf) == exp_len) and (max(cf) < res_max) and (cf.quotients().count(1) <=1):
        int_pairs.append((a, b))
        print(a, b, xgcd(a, b), cf)
