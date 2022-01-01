file_ext = '.xml'
tmpl_file_name = 'template' + file_ext

tmpl = open(tmpl_file_name, 'r')
otxt = tmpl.read()
tmpl.close()

#---------------------------------------------------------------------
#the following parameters must be set-up before launching this script:
try:
    start
except NameError:
    start=0

try:
    poly_lst
except NameError:
    poly_lst = []
#---------------------------------------------------------------------
    
idx = start
for f, g, q, r, pt in poly_lst:

    ntxt = otxt    
    subs = {'$id$': str(idx), '$f$':latex(f), '$g$':latex(g), '$q$':latex(q), '$r$':latex(r), '$pt$':latex(pt), '$answ$': latex(r(pt))}
    for s in subs.keys():
        ntxt = ntxt.replace(s, subs[s])
    file_name_pfx = 'Dalyba kampu variantas 1a'
    outp = open(file_name_pfx + ' (' + str(idx) + ') ' + file_ext, 'w')
    outp.write(ntxt)
    outp.close()
    idx +=1
