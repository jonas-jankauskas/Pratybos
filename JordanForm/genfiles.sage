load('../text_utils.sage')
load('../matrix_utils.sage')


ndim=3

file_name_pfx = 'Žordano forma '
file_name_inf = str(ndim)+'x'+str(ndim)+ ' eilė 3'
file_name_ext = '.xml'

tmpl_file_name = 'template'

start=10

tmpl = open(tmpl_file_name, 'r')
otxt = tmpl.read()
tmpl.close()

mat_list = load('../Data/jordan-form-3x3_3')

for nr, triple in enumerate(mat_list):

    A = triple[0]
    J, Tinv = A.jordan_form(transformation=True)
    T = ~Tinv; T = mat_cfactor(T)*T
    
    subs = {'$A$': latex(A),'$J$': latex(J), '$T$': latex(T), '$nr$': str(start+nr)}

    ntxt = make_subs(otxt, subs)

    new_file_name = file_name_pfx + file_name_inf + ' ' + str(nr+1) + ' variantas' + file_name_ext 
    write_file(new_file_name, ntxt)
