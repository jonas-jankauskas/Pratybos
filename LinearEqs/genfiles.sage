file_name_pfx = '4x4 rg '
file_name_inf = ' matrica '
file_name_ext = '.xml'

tmpl_file_name = 'template.xml'

tmpl = open(tmpl_file_name, 'r')
otxt = tmpl.read()
tmpl.close()

idx = start
for mat in mat_lst:
    ntxt = otxt    
    subs = {'$id$': str(idx), '$latex_formula$': latex(mat), '$answ$': str(mat.rank())}
    for s in subs.keys():
        ntxt = ntxt.replace(s, subs[s])
    outp = open(file_name_pfx + str(mat.rank()) + ' (' + str(idx) + ') ' + file_name_ext, 'w')
    outp.write(ntxt)
    outp.close()
    idx +=1
