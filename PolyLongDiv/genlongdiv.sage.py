

# This file was *autogenerated* from the file genlongdiv.sage
from sage.all_cmdline import *   # import sage library

_sage_const_8 = Integer(8); _sage_const_50 = Integer(50); _sage_const_20 = Integer(20); _sage_const_4 = Integer(4); _sage_const_2 = Integer(2); _sage_const_1000 = Integer(1000); _sage_const_3 = Integer(3); _sage_const_1 = Integer(1); _sage_const_0 = Integer(0)#---------------------------------------------------------------------
#the following parameters must be set-up before launching this script:


try:
    h_max
except NameError:
    h_max = _sage_const_8 

try:
    v_max
except NameError:
    v_max = _sage_const_50 

try:
    hi_cfs
except NameError:
    hi_cfs = _sage_const_20 

try:
    f_deg
except NameError:
    f_deg = _sage_const_4 

try:
    g_deg
except:
    g_deg = _sage_const_2 

try:
    poly_num
except NameError:
    poly_num = _sage_const_20 

try:
    try_max
except NameError:
    try_max = _sage_const_1000 


R = ZZ['x']; (x,) = R._first_ngens(1)

#---------------------------------------------------------------------

poly_lst = []
pts_lst = [-_sage_const_3 , -_sage_const_2 , -_sage_const_1 , _sage_const_1 , _sage_const_2 , _sage_const_3 ]

num_try = _sage_const_0 

while (len(poly_lst) < poly_num) and (num_try < try_max):
   
    f = R.random_element(f_deg, x=-h_max, y=h_max+_sage_const_1 )
    if f.list()[-_sage_const_1 ] < _sage_const_0 :
        f = -f
    
    g = x**g_deg + R.random_element(g_deg-_sage_const_1 , x=-h_max, y=h_max+_sage_const_1 )

    q, r = f.quo_rem(g)
        
    f_cnt0 = f.list().count(_sage_const_0 )
    g_cnt0 = g.list().count(_sage_const_0 )
    q_cnt0 = q.list().count(_sage_const_0 )
    r_cnt0 = r.list().count(_sage_const_0 )
    
    cnt0 = max([f_cnt0, g_cnt0, q_cnt0,  r_cnt0])
            
    maxc = max([q.norm(infinity), r.norm(infinity)])

    pt = choice(pts_lst)
    vl = r(pt)
    
    if (cnt0 == _sage_const_0 ) and (maxc < hi_cfs) and (abs(vl) < v_max) and (f(pt) != vl):
        poly_lst.append((f, g, q, r, pt))
        print(str(f)+'=('+latex(g)+')('+latex(q)+') + '+latex(r)+' r('+latex(pt)+')='+latex(vl))

    num_try += _sage_const_1 
