

# This file was *autogenerated* from the file genpoly.sage
from sage.all_cmdline import *   # import sage library

_sage_const_8 = Integer(8); _sage_const_10 = Integer(10); _sage_const_3 = Integer(3); _sage_const_1 = Integer(1); _sage_const_0 = Integer(0); _sage_const_2 = Integer(2); _sage_const_4 = Integer(4)#the following parameters must be set-up before launching this script:

try: h_max
except NameError: h_max = _sage_const_8 

try: poly_num
except NameError: poly_num = _sage_const_10 

R = ZZ['x']; (x,) = R._first_ngens(1)

poly_lst = []
pts_lst = []
val_lst = []

while len(poly_lst) < poly_num:

    cofs = random_vector(ZZ, _sage_const_3 , -h_max+_sage_const_1 , h_max).list()
    if _sage_const_0  not in cofs:

        poly = R(cofs)

        pts = sample([-_sage_const_3 , -_sage_const_2 , -_sage_const_1 , _sage_const_1 , _sage_const_2 , _sage_const_3 ], _sage_const_4 )
        pt0 = choice(pts)
        pts.remove(pt0)
        pts.sort()
        pts.insert(_sage_const_0 , pt0)

        vls = [poly(t) for t in pts]
        vl0 = vls[_sage_const_0 ]

        if _sage_const_0  not in vls:
            pts_lst.append([pt0]+pts)
            val_lst.append([vl0]+vls)
            poly_lst.append(poly)
            print('f(x)=', latex(poly))
            print('x=', pts)
            print('y=', vls)
            print('f('+str(pt0)+')='+str(vl0))

print(poly_lst)
print(pts_lst)
print(val_lst)
