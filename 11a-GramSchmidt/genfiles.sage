load('../text_utils.sage')

file_name_pfx = str(num_rows)+'x'+str(num_cols) + ' '
file_name_inf = 'Gramo - Šmito ortogonalizacija'
file_name_ext = '.xml'

tmpl_file_name = 'template.xml'

tmpl = open(tmpl_file_name, 'r')
otxt = tmpl.read()
tmpl.close()

#start of the numbering
if start_id is None:
    start_id = 1

idx = start_id

for nr, mat in enumerate(mat_lst):

    eqsys = eqs[nr]
    rws = mat.rows()
    
    subs1 = {'$u'+str(j+1)+'$': latex(rws[j]) for j in range(len(rws))}
    subs2 = {'$eq'+str(j+1)+'$': str(eqsys[j]) for j in range(len(eqsys))}
    subs3 = {'$id$': str(idx)}

    subs = {**subs1, **subs2, **subs3}

    ntxt = make_subs(otxt, subs)

    new_file_name = file_name_pfx + 'rg ' + str(mat.rank()) + ' ' + file_name_inf + ' ' + str(idx) + ' variantas ' + file_name_ext 
    write_file(new_file_name, ntxt)

    idx +=1
