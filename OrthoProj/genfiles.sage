file_name_pfx = str(num_rows)+'x'+str(num_cols) + ' '
file_name_inf = 'Projekcija ir statmuo'
file_name_ext = '.xml'

tmpl_file_name = 'template.xml'

tmpl = open(tmpl_file_name, 'r')
otxt = tmpl.read()
tmpl.close()

#start of the numbering
#start =1

idx = start
for nr in range(len(mat_lst)):
    mat = mat_lst[nr]
    ntxt = otxt
    rws = mat.rows()
    subs1 = {'$u'+str(j+1)+'$': latex(rws[j]) for j in range(num_rows)}
    subs2 = {'$v$': str(vec_lst[nr]), '$pr$': str(proj_lst[nr]), '$ort$': str(orth_lst[nr])}
    subs3 = {'$id$': str(idx)}
    subs = {**subs1, **subs2, **subs3}
     
    for s in subs.keys():
        ntxt = ntxt.replace(s, subs[s])
    outp = open(file_name_pfx + ' ' + file_name_inf + ' ' + str(idx) + ' variantas ' + file_name_ext, 'w')
    outp.write(ntxt)
    outp.close()
    idx +=1
