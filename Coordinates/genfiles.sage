#---------------------------------------------------------------------
#the following parameters must be set-up before launching this script:
try:
    mat_lst
except NameError:
    mat_lst = []
try:
    vec_lst
except NameError:
    vec_lst = []
try:
    answ_lst
except NameError:
    answ_lst = []
#---------------------------------------------------------------------
try:
    start
except NameError:
    start = 0
#---------------------------------------------------------------------
#Read template text
file_ext = '.xml'
tmpl_file_name = 'template' + file_ext

tmpl = open(tmpl_file_name, 'r')
otxt = tmpl.read()
tmpl.close()

#---------------------------------------------------------------------
#Produce quiz files

n = min(len(mat_lst), len(vec_lst), len(answ_lst))

#Symbols to strip
rems = {' ': '', '(': '', ')': ''}

for i in range(n):

    mat = mat_lst[i]
    vec = vec_lst[i]
    ans = answ_lst[i]

    ndim = mat.ncols()

    #strip vector answer string from spaces and parantheses
    answ_txt = str(ans)
    for s in rems.keys():
        answ_txt = answ_txt.replace(s, rems[s])

    #template text substitutions
    subs1 = {'$v'+str(j)+'$': str(mat.columns()[j-1]) for j in range(1, ndim+1)}
    subs2 = {'$id$': str(i+start), '$matrix$': latex(mat), '$inverse$': latex(mat.inverse()),'$v$': str(vec), '$answ$': answ_txt, '$answ_vec$': str(ans)}
    subs = {**subs1, **subs2}

    ntxt = otxt 
    for s in subs.keys():
        ntxt = ntxt.replace(s, subs[s])
    
    file_name_pfx = 'Koordinatės ' + str(vec) + ' ' + str(ndim) + 'd bazėje'
    outp = open(file_name_pfx + ' (' + str(i+start) + ') ' + file_ext, 'w')
    outp.write(ntxt)
    outp.close()
