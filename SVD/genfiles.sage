load('../text_utils.sage')

file_name_pfx = 'svd '
file_name_inf = str(nrows)+'x'+str(ncols)+ '-r'+str(rg)
file_name_ext = '.xml'

tmpl_file_name = 'template'

tmpl = open(tmpl_file_name, 'r')
otxt = tmpl.read()
tmpl.close()

for nr, sv_pair in enumerate(svd_dict):

    S, U, V = svd_dict[sv_pair]
    
    subs = {'$A$': latex(U*S*(V.T)),'$S$': latex(S), '$U$': latex(U), '$V$': latex(V), '$id$': str(nr+1)}

    ntxt = make_subs(otxt, subs)

    new_file_name = file_name_pfx + file_name_inf + ' ' + str(nr+1) + ' variantas' + file_name_ext 
    write_file(new_file_name, ntxt)
