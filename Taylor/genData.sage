try:
    deg
except NameError:
    deg = 4

#maximal inital height
try:
    h_max
except NameError:
    h_max = 5

#maximal resulting height
try:
    c_max
except NameError:
    c_max = 100

#maximal shift
try:
    s_max
except NameError:
    s_max = 5

#maximal number of zero terms
try:
    z_max
except:
    z_max = 1

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
    data_name = 'taylor'

full_data_path=data_path+data_name

#load the earlier generated data
try:
    poly_data = load(full_data_path)
except:
    poly_data = []

shifts = [s for s in range(-s_max, s_max+1) if abs(s) >=2]

R.<t> = ZZ['t']
x=var('x')

print('------------------------ New data ------------------------')

for attempts in range(num_tries):

    f = R.random_element(deg, x=-h_max,y=h_max+1)
    cf = f.list()
    zf = cf.count(0)
    hf = f.norm(+oo)
    
    if (hf>h_max) or (zf>z_max) or (cf[0]==0) or (abs(gcd(cf))>1):
        continue

    if cf[-1] < 0:
        f = -f

    for s in shifts:
    
        g = f(t+s)
        cg = g.list()
        	    
        hg = g.norm(infinity)
        zg = cg.count(0)

        if (hg>c_max) or (zg>z_max) or (cg[0]==0):
            continue

        tp = (f, g, s)
        if tp not in poly_data:
            poly_data.append(tp)
            print('f(x)=', str(f(x)), '=', str(SR(f(x)).series(x==s,+oo)))

    if len(poly_data) >= pol_max:
        break

poly_data.sort(key=lambda tp: tp[1].norm(+oo))
save(poly_data, full_data_path)