reset()

#the following parameters must be set-up before launching this script:

#degree of polynomial
deg=4
#bounds on height of initial and shifted polynomials
h_max = 5
c_max = 300
#bounds on the size of the shift
s_max=10
#number of zeros allowed
z_max=1
#number of tries
num_tries=10000
#number of tests
num_probs = 20

load('genTaylor.sage')
load('genfiles.sage')

reset()
