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
    int_pairs
except NameError:
    int_pairs = []
#---------------------------------------------------------------------
    
idx = start
for pair in int_pairs:
    a, b = pair
    dbd, u, v = xgcd(a, b)
    ntxt = otxt    
    subs = {'$id$': str(idx), '$a$':str(a), '$b$':str(b),'$dbd$': str(dbd),'$u$':str(u), '$v$':str(v)}
    for s in subs.keys():
        ntxt = ntxt.replace(s, subs[s])
    file_name_pfx = 'DBD(' + str(a) + ',' + str(b)+ ')'
    outp = open(file_name_pfx + ' (' + str(idx) + ') ' + file_ext, 'w')
    outp.write(ntxt)
    outp.close()
    idx +=1
