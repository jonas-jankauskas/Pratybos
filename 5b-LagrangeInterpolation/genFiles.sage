reset()
load('../text_utils.sage')

#---------------------------------------------------------------------
#the following parameters must be set-up before launching this script:

#number of tests to make
num_probs=20 

#data file naming and location
data_path='../Data/' 
data_name = 'lagrange'
full_data_path=data_path+data_name

#test file naming and location
test_path='ProblemSet/'
test_name='Lagranžo polinomas'
test_ext='.xml'

#template file name
tmpl_name = 'template'

#load template text
tmpl = open(tmpl_name, 'r')
otxt = tmpl.read()
tmpl.close()

#---------------------------------------------------------------------
#set up polynomial ring
R.<x>=ZZ['x']

#load  generated data
try:
    poly_data = load(full_data_path)
except:
    poly_data = []

problem_data=sample(poly_data, num_probs)

print('------------------------ Test data ------------------------')

for nr, tp  in enumerate(problem_data):

    poly, xVal, yVal = tp
    
    dicX = {'$x'+str(j)+'$': str(xVal[j]) for j in range(len(xVal))}
    dicY = {'$y'+str(j)+'$': str(yVal[j]) for j in range(len(yVal))}    
    dicS = {'$id$': str(nr+1), '$poly$': latex(poly), '$answ$': str(yVal[0])}
    subs = {**dicS, **dicX, **dicY}
    
    ntxt = make_subs(otxt, subs)
    full_test_path = test_path+test_name+' '+str(nr+1)+' variantas'+test_ext
    write_file(full_test_path, ntxt)

    #test printout
    print('f(x)=', poly, 'X=', xVal, 'Y=', yVal, 'f('+str(xVal[0])+')=', yVal[0])