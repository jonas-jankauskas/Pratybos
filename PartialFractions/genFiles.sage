reset()
load('../text_utils.sage')

#---------------------------------------------------------------------
#the following parameters must be set-up before launching this script:

#number of tests to make
num_probs=20
#data file location
data_path='../Data/'
data_name = 'partial-fraction'
full_data_path=data_path+data_name
#test file name location and naming
test_name='Paprastosios trupmenos'
test_path='ProblemSet/'
test_ext='.xml'

#---------------------------------------------------------------------
#set up polynomial rings
R.<A,B,C, D, E, F, G, H> = QQ[]
K.<x>=R[]

#load the earlier generated data
try:
    poly_data = load(full_data_path)
except:
    poly_data = []

#load the template text
try:
    tmpl_file_name
except:
    tmpl_file_name = 'template'

tmpl = open(tmpl_file_name, 'r')
otxt = tmpl.read()
tmpl.close()

#sample uniformly  pfd type
#root_data = {f: f.roots(QQ,multiplicities=False)[0] for f in poly_data}
#rep_root = set(root_data.values())
#candidates = {r: [f for f in poly_data if root_data[f] == r] for r in rep_root}
#sample the data for the required number of problems
#numreq = ceil(num_probs/ len(rep_root))
#select = sum([rnd.sample(candidates[r], numreq) for r in rep_root],[])
problem_data = sample(poly_data, num_probs);

print('------------------------ Test data ------------------------')

for nr,poly in enumerate(problem_data):

    whole, parts= poly.partial_fraction_decomposition()
    
    poly_str = '\\frac{' + latex(poly.numerator()) + '}{' + latex(factor(poly.denominator()))+'}'

    cof = [A,B,C,D,E,F,G,H]

    cfS = {}
    cfN = {}
    degSum = 0
    formula_str = ""

    for part in parts:
        degD = (part.denominator().factor())[0][0].degree()
        degN = part.numerator().degree()
        lstD = cof[degSum:degSum+degD]; lstD.reverse() #SAGE lists polynomial in reversed order; reverse it back
        cfS[part] = lstD
        difDeg = degD-1-degN #degree difference between symbolic formula and true coefficients
        lstN = part.numerator().list()+[0]*(difDeg); #append zeros in place of 'missing' coefficients
        cfN[part] = lstN
        degSum += degD
        formula_str += ' '.join([' + \\frac{', latex(K(cfS[part])), '}{', latex(part.denominator().factor()), '}'])

    formula_str = formula_str[3:]
    matches = sum([[tp for tp in zip(cfS[part],cfN[part])] for part in parts],[]) #match symbolic coefficients and their values and store in a list
   
    subCOF={'$'+str(tp[0])+'$':str(tp[1]) for tp in matches} #write matched substitutions
    subPOL = {'$poly$': poly_str, '$formula$': formula_str, '$id$': str(nr+1), '$sol$': latex(SR(poly).partial_fraction())}
    subs = {**subCOF, **subPOL}
    ntxt = make_subs(otxt, subs)
    
    full_test_path = test_path+test_name+' '+str(nr+1)+' variantas'+test_ext
    write_file(full_test_path, ntxt)
    
    #test printout
    print(poly_str, '=', SR(poly).partial_fraction())
