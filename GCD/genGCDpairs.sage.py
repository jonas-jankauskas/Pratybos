

# This file was *autogenerated* from the file genGCDpairs.sage
from sage.all_cmdline import *   # import sage library

_sage_const_20 = Integer(20); _sage_const_4 = Integer(4); _sage_const_17 = Integer(17); _sage_const_199 = Integer(199); _sage_const_4000 = Integer(4000); _sage_const_16000 = Integer(16000); _sage_const_1 = Integer(1); _sage_const_3 = Integer(3); _sage_const_0 = Integer(0); _sage_const_2 = Integer(2)#---------------------------------------------------------------------
#the following parameters must be set-up before launching this script:
try:
    res_max
except NameError:
    res_max = _sage_const_20 
try:
    exp_len
except NameError:
    exp_len = _sage_const_4 
try:
    lo_prime
except NameError:
    lo_prime = _sage_const_17 
try:
    hi_prime
except NameError:
    hi_prime = _sage_const_199 
try:
    hi_a
except NameError:
    hi_a = _sage_const_4000 
try:
    hi_b
except NameError:
    hi_b = _sage_const_16000 
try:
    pair_num
except NameError:
    pair_num = _sage_const_20 
#---------------------------------------------------------------------

prime_list = [pr for pr in primes(hi_prime+_sage_const_1 ) if pr >= lo_prime]

int_pairs = []

while len(int_pairs) < pair_num:
    divlist = sample(prime_list, _sage_const_3 )
    a = divlist[_sage_const_0 ]*divlist[_sage_const_1 ]
    b = divlist[_sage_const_0 ]*divlist[_sage_const_2 ]
    if a < b:
        a, b = b, a
    cf = continued_fraction(a/b)
    if (a < hi_a) and (b < hi_b) and (len(cf) == exp_len) and (max(cf) < res_max):
        int_pairs.append((a, b))
        print(a, b, xgcd(a, b), cf)

