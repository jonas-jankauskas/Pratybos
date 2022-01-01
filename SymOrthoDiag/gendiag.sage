import random as rnd

load('../matrix_utils.sage')

#check if the list of matrices has been prepared

sym_mat_dict = load('../Data/sym_mat_unique')

s_mat_lst = [rnd.choice(sym_mat_dict[ev]) for ev in list(sym_mat_dict.keys()) if len(ev) == 3]

dq_mat_lst = []
for mat in s_mat_lst:
    D, Q = nice_orthodiagonalization(mat)
    dq_mat_lst.append((D, Q))

for vr, mat in enumerate(s_mat_lst):
	print('----------- Užd.'+ str(vr+1)+'. -----------------')    
	print('S=')
	print('ATS.:') 
	print(mat)
	print('D=')
	print(dq_mat_lst[vr][0])
	print('Q=')
	print(dq_mat_lst[vr][1])

save(s_mat_lst, '../Data/s_mat_lst')
save(dq_mat_lst, '../Data/dq_mat_lst')
