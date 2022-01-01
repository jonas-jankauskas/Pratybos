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
    mat_lst
except NameError:
    mat_lst = []
#---------------------------------------------------------------------
    
idx = start
for mat in mat_lst:
    ntxt = otxt    
    subs = {'$id$': str(idx), '$matrix$': latex(mat), '$echform$': latex(mat.echelon_form()), '$answ$': str(mat.rank())}
    for s in subs.keys():
        ntxt = ntxt.replace(s, subs[s])
    file_name_pfx = 'Matrica ' + str(mat.nrows()) + 'x' + str(mat.ncols())+ ' r'+ str(mat.rank())
    outp = open(file_name_pfx + ' (' + str(idx) + ') ' + file_ext, 'w')
    outp.write(ntxt)
    outp.close()
    idx +=1
