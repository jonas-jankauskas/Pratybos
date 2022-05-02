reset()

load('../matrix_utils.sage')
load('../text_utils.sage')

#---------------------------------------------------------------------
#the following parameters must be set-up before launching this script:
#dimension 
ndim = 3
#largest element
h_max = 8
#bound for no. of zeros in row or column
z_max = 1
#largest coefficient
c_max = 50
#number of matrices of each type
num_forms = 1000
#number of tries
num_tries = 10000
#data file location
data_path='../Data/'
data_name = 'canonical-form'
full_data_path=data_path+data_name

#---------------------------------------------------------------------
#load generated data
try:
    qforms_data = load(full_data_path)
except:
    qforms_data = []

#print header with timestamp
print('------------------------ New data for %s ------------------------' % get_date_time())

#---------------------------------------------------------------------
for attempts in range(num_tries):

    if len(qforms_data) > num_forms:
        break

    dnums = [d for d in range(-h_max, h_max+1) if is_squarefree(d)]
    dvec  = vector(QQ, sample_repl(dnums, ndim))

    if not accept_vector(dvec, is_prim=True):
        continue

    if dvec[0] < 0:
        dvec = -dvec
    
    matD = diagonal_matrix(QQ, dvec)
    cForm = QuadraticForm(matD+matD.T)
    
    matC = random_ltdet1_Zmatrix(ndim, h_max)

    if not accept_matrix(matC+matC.T, max_zeros=z_max):
        continue

    matS = matC*matD*(matC.T)
    qForm = QuadraticForm(matS+matS.T)

    
    cfs_vec =vector(QQ, qForm.coefficients())

    if not accept_vector(cfs_vec, max_height=c_max, max_zeros=z_max, is_prim=True):
        continue

    if qForm in qforms_data:
        continue

    qforms_data.append(qForm)

    x_str = ','.join(['x'+str(j+1) for j in range(ndim)])
    y_str = ','.join(['y'+str(j+1) for j in range(ndim)])

    formPoly = qForm.polynomial(x_str)
    canfPoly = cForm.polynomial(y_str)
    
    print('f(%s)=' % x_str, str(formPoly))
    print('g(%s)=' % y_str, str(canfPoly))
    print('\n')

qforms_data.sort(key= lambda qf: qf.coefficients()) 
save(qforms_data, full_data_path)
