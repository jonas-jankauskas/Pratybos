#---------------------------------------------------------------------
#the following parameters must be set-up before launching this script:
try:
    hi_prime
except NameError:
    hi_prime = 13

try:
    hi_cfs
except NameError:
    hi_cfs = 20

try:
    poly_num
except NameError:
    poly_num = 20


#---------------------------------------------------------------------

prime_lst = [pr for pr in primes(hi_prime+1)] + [-pr for pr in primes(hi_prime+1)]

poly_lst = []

while len(poly_lst) < poly_num:

    p, q = sample(prime_lst, 2)
    interv = [t for t in range(-hi_cfs+1, hi_cfs)]
    interv.remove(0)
    r = choice(interv)
    R.<x> = ZZ['x']
    f = (x-p)*(x^2+r*x+q)
    cfs = f.list()
    maxc = max(max(cfs), -min(cfs))
    cnt0 = cfs.count(0)

    if not((r^2-4*q).is_square()) and (maxc < hi_cfs) and (cnt0 ==0):
        poly_lst.append((f, p))
        print(f, '=', factor(f))
