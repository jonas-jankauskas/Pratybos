reset()
#---------------------------------------------------------------------
#the following parameters must be set-up before launching this script:

#height of polynomials f and g
h_max = 8
c_max = 20

#degrees of polynomials f and g
f_deg = 4
g_deg = 2

#maximal number of zero coefficients allowed
z_max=0

#maximal no. of examples
num_poly = 10000

#number of tries
num_tries = 1000

#data file location
data_path='../Data/'
data_name = 'poly-long-div'

full_data_path=data_path+data_name

#---------------------------------------------------------------------
#set up polynomial ring and its fraction field
R.<x>=ZZ['x']

#print header with timestamp
from datetime import datetime
now = datetime.now()
time_stamp = now.strftime("%Y/%m/%d %H:%M:%S")
print('------------------------ New data for %s ------------------------' % time_stamp)

#load generated data
try:
    poly_data = load(full_data_path)
except:
    poly_data = []

for attempts in range(num_tries):

    if len(poly_data) >= num_poly:
        break
   
    f = R.random_element(f_deg, x=-h_max, y=h_max+1)
    if f.list()[-1] < 0:
        f = -f    
    g = x^g_deg + R.random_element(g_deg-1, x=-h_max, y=h_max+1)
    
    cnt0f = f.list().count(0)
    cnt0g = g.list().count(0)
    if (f==0) or (g==0) or (cnt0f > z_max) or (cnt0g > z_max):
        continue

    if abs(gcd(f.list())) > 1:
    	continue 

    q, r = f.quo_rem(g)
	
    cnt0q = q.list().count(0)
    cnt0r = r.list().count(0)
    if (q==0) or (r==0) or (cnt0q > z_max) or (cnt0r > z_max):
        continue
    maxc = max([q.norm(infinity), r.norm(infinity)])
    if (maxc > c_max):
        continue

    if (f, g) not in poly_data:
        poly_data.append((f, g))
        print(str(f)+'=('+str(g)+')('+str(q)+') + '+str(r))

poly_data.sort()
save(poly_data, full_data_path)