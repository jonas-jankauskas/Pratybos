load('../text_utils.sage')

file_name_pfx = str(ndim)+'x'+str(ndim)+ ' '
file_name_inf = ' Simetrinės matricos ortodiagonalizacija'
file_name_ext = '.xml'

tmpl_file_name = 'template.xml'

tmpl = open(tmpl_file_name, 'r')
otxt = tmpl.read()
tmpl.close()

s_mat_lst = load('../Data/s_mat_lst')
dq_mat_lst = load('../Data/dq_mat_lst')

for nr, mat in enumerate(s_mat_lst):

    D, Q = dq_mat_lst[nr]
    
    subs = {'$A$': latex(mat), '$D$': latex(D), '$Q$': latex(Q), '$dim$': str(ndim), '$nr$': str(nr+1)}

    ntxt = make_subs(otxt, subs)

    new_file_name = file_name_pfx + file_name_inf + ' ' + str(nr+1) + ' variantas' + file_name_ext 
    write_file(new_file_name, ntxt)
