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
    c_max = 300

#maximal shift
try:
    s_max
except NameError:
    s_max = 10

#maximal number of zero terms
try:
    z_max
except:
    z_max = 1

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
    data_name = 'taylor'

full_data_path=data_path+data_name

#load the earlier generated data
try:
    poly_data = load(full_data_path)
except:
    poly_data = []

shifts = [s for s in range(2, s_max+1)]
shifts += [-s for s in shifts]
shifts.sort()

R.<t> = ZZ['t']
x=var('x')

for attempts in range(num_tries):
    f = R.random_element(deg, x=-h_max,y=h_max+1)

    cfs = f.list()
    
    if (cfs[0] == 0) or (cfs[-1] <= 0):
        continue
        
    s = choice(shifts)
    g = f(t+s)

    cfs = g.list()
    if (cfs[0] == 0):
        continue
    
    hf = f.norm(infinity)
    hg = g.norm(infinity)
    zf = f.list().count(0)
    zg = g.list().count(0)

    if (hf>h_max) or (hg>c_max) or (zf>z_max) or (zg>z_max):
        continue

    tp = (f, g, s)
    if tp not in poly_data:
        poly_data.append(tp)
        print('f(x)=', str(f(x)), '=', str(SR(f(x)).series(x==s,+oo)))

    if len(poly_data) >= pol_max:
        break

save(poly_data, full_data_path)
