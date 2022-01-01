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
for poly in poly_lst:

    polystr = str(poly[0]).replace('*', '')
    factorstr = str(factor(poly[0])).replace('*', '')
    ntxt = otxt    
    subs = {'$id$': str(idx), '$poly$':polystr, '$factors$': polystr+' = '+factorstr,'$answ$':str(poly[1])}
    for s in subs.keys():
        ntxt = ntxt.replace(s, subs[s])
    file_name_pfx = 'Racionali šaknis variantas 1'
    outp = open(file_name_pfx + ' (' + str(idx) + ') ' + file_ext, 'w')
    outp.write(ntxt)
    outp.close()
    idx +=1
