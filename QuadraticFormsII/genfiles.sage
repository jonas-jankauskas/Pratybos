load('../text_utils.sage')

file_name_pfx = str(ndim)+ ' kintamųjų '
file_name_inf = ' kv. formos suvedimas prie ašių'
file_name_ext = '.xml'

tmpl_file_name = 'template'

tmpl = open(tmpl_file_name, 'r')
otxt = tmpl.read()
tmpl.close()

try:
    F_lst, G_lst, eqs_lst
except NameError:
    F_lst=[]; G_lst=[]; eqs_lst=[]

for nr in range(len(F_lst)):

    subs1 = {'$F$': F_lst[nr], '$G$': G_lst[nr], '$dim$': str(ndim), '$nr$': str(nr+1)}
    subs2 = {'$x'+str(j+1)+'$': eqs_lst[nr][j] for j in range(len(eqs_lst[nr]))}
    subs = {**subs1, **subs2} 

    ntxt = make_subs(otxt, subs)

    new_file_name = file_name_pfx + file_name_inf + ' ' + str(nr+1) + ' variantas' + file_name_ext 
    write_file(new_file_name, ntxt)
