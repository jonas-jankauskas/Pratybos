#the following parameters must be set-up before launching this script:

try: h_max
except NameError: h_max = 8

try: poly_num
except NameError: poly_num = 10

R.<x> = ZZ['x']

poly_lst = []
pts_lst = []
val_lst = []

while len(poly_lst) < poly_num:

    cofs = random_vector(ZZ, 3, -h_max+1, h_max).list()
    if 0 not in cofs:

        poly = R(cofs)

        pts = sample([-3, -2, -1, 1, 2, 3], 4)
        pt0 = choice(pts)
        pts.remove(pt0)
        pts.sort()
        pts.insert(0, pt0)

        vls = [poly(t) for t in pts]
        vl0 = vls[0]

        if 0 not in vls:
            pts_lst.append(pts)
            val_lst.append(vls)
            poly_lst.append(poly)
            print('f(x)=', latex(poly))
            print('x=', pts)
            print('y=', vls)
            print('f('+str(pt0)+')='+str(vl0))

print(poly_lst)
print(pts_lst)
print(val_lst)
