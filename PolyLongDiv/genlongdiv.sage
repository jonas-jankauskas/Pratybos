#---------------------------------------------------------------------
#the following parameters must be set-up before launching this script:

try:
    h_max
except NameError:
    h_max = 8

try:
    v_max
except NameError:
    v_max = 50

try:
    hi_cfs
except NameError:
    hi_cfs = 20

try:
    f_deg
except NameError:
    f_deg = 4

try:
    g_deg
except:
    g_deg = 2

try:
    poly_num
except NameError:
    poly_num = 20

try:
    try_max
except NameError:
    try_max = 1000

#---------------------------------------------------------------------
R.<x> = ZZ['x']

poly_lst = []
pts_lst = [-3, -2, -1, 1, 2, 3]

num_try = 0

while (len(poly_lst) < poly_num) and (num_try < try_max):
   
    f = R.random_element(f_deg, x=-h_max, y=h_max+1)
    if f.list()[-1] < 0:
        f = -f
    
    g = x^g_deg + R.random_element(g_deg-1, x=-h_max, y=h_max+1)

    q, r = f.quo_rem(g)
        
    f_cnt0 = f.list().count(0)
    g_cnt0 = g.list().count(0)
    q_cnt0 = q.list().count(0)
    r_cnt0 = r.list().count(0)
    
    cnt0 = max([f_cnt0, g_cnt0, q_cnt0,  r_cnt0])
            
    maxc = max([q.norm(infinity), r.norm(infinity)])

    pt = choice(pts_lst)
    vl = r(pt)
    
    if (cnt0 == 0) and (maxc < hi_cfs) and (abs(vl) < v_max) and (f(pt) != vl):
        poly_lst.append((f, g, q, r, pt))
        print(latex(f)+'=('+latex(g)+')('+latex(q)+') + '+latex(r)+' r('+latex(pt)+')='+latex(vl))

    num_try += 1
