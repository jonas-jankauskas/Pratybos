file_name_pfx = 'Lagranžo '
file_name_inf = ' polinomas '
file_name_ext = '.xml'

tmpl_file_name = 'template.xml'

tmpl = open(tmpl_file_name, 'r')
otxt = tmpl.read()
tmpl.close()

idx = start
for i in range(len(poly_lst)):
    poly = poly_lst[i]
    ntxt = otxt
    dicx = {'$x'+str(j)+'$': str(pts_lst[i][j]) for j in range(4)}
    dicy = {'$y'+str(j)+'$': str(val_lst[i][j]) for j in range(4)}    
    dics = {'$file_no$': str(idx), '$poly$': latex(poly), '$answ$': str(val_lst[i][0])}
    subs = {**dics, **dicx, **dicy}
    for s in subs.keys():
        ntxt = ntxt.replace(s, subs[s])
    outp = open(file_name_pfx + 'd' + str(poly.degree()) + ' (' + str(idx) + ') ' + file_name_ext, 'w')
    outp.write(ntxt)
    outp.close()
    idx +=1
