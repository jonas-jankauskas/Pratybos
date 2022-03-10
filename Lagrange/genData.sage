reset()

#---------------------------------------------------------------------
#the following parameters must be set-up before launching this script:

#degree of a polynomial
deg = 2

#maximal height
h_max = 8

#maximal absolute x value
x_max = deg+1

#maximal absolute y value
y_max = 30

#admissible number of zero coefficients
z_max = 0

#maximal no. of polynomials
num_poly = 10000

#number of attempts
num_tries = 10000 

#data path
data_path = '../Data/'

#data file
data_name = 'lagrange'

full_data_path=data_path+data_name	

#---------------------------------------------------------------------
#set up polynomial ring
R.<x> = ZZ['x']

#load the earlier generated data
try:
	poly_data = load(full_data_path)
except:
	poly_data = []
	
xRange = [num for num in range(-x_max, x_max+1) if num != 0]

print('------------------------ New data ------------------------')

for attempts in range(num_tries):
    if len(poly_data) > num_poly:
        break
    poly = R.random_element(deg, x=-h_max+1, y=h_max)    

    if (poly.list().count(0) > z_max) or (abs(poly.content())>1):
        continue

    xVal = sample(xRange, deg+2)
    x0 = choice(xVal)
    xVal.remove(x0)
    xVal.sort()
    xVal.insert(0, x0)
    yVal = [poly(t) for t in xVal]
    y0 = yVal[0]

    if (0 in yVal) or (max(yVal) > max_y) or (min(yVal) < -max_y):
        continue

    tp = (poly, xVal, yVal)
    if tp not in poly_data:
        poly_data.append(tp)
        print('f(x)=', latex(poly))
        print('x=', xVal)
        print('y=', yVal)
        print('f('+str(x0)+')='+str(y0))

poly_data.sort(key=lambda tp: tp[0].norm(+oo))
save(poly_data, full_data_path)