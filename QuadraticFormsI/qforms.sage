
strip_dict = {'{':'', '}': '', '_': '', ' ': '',  '*': ''}
space_dict = {'=': ' = ', '+': ' + ', '-': ' - '}

def trans(s, tab):
    t = str(s)
    for c in tab.keys():
        t = t.replace(c, tab[c])
    return t

def reformat(s):
    return trans(trans(s, strip_dict), space_dict)


formlist = {
'a)': [1, -4, -2, 11, 88, 256],
'b)': [-1, 2, 6, -5, -54, -158],
'c)': [1, -4, 6, -1, 48, -173],
'd)': [1, 2, 8, -1, -12, -31]
}

for vr in formlist.keys():
    print('#--------------------------------------------------------#')
    print('#                       3 užd. '+vr+'                        #')
    print('#--------------------------------------------------------#')

    qf = QuadraticForm(QQ, 3, formlist[vr])
    fm  = qf.matrix()/2
    fp = qf.polynomial('x1,x2,x3')
    print(fp)
    nf, T = qf.rational_diagonal_form(return_matrix=True)
    D = nf.matrix()/2
    C = T.transpose() 

    print('D=\n'+str(D))
    print('C=\n'+str(C))
    print('C^(-1)=\n'+str(C.inverse()))
    print('C*A*C^t=\n'+str(C*fm*(C.transpose())))

    np = nf.polynomial('y1,y2,y3')
    print(reformat(str(np)))

    R = PolynomialRing(QQ, 6, names='x1,x2,x3,y1,y2,y3')
    X = vector(R, 3, R.gens()[:3])
    Y = vector(R, 3, R.gens()[3:])

    latex_eqs = [str(latex(X[i])+'='+latex((Y*C)[i])) for i in range(len(X))]

    dic1 = {'{':'', '}': '', '_': '', ' ': ''}
    dic2 = {'=': ' = ', '+': ' + ', '-': ' - '}
    
    for eq in latex_eqs:
        print(reformat(eq))
