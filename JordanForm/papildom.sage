def papildom_poerdviai(W, V):
    """Gražina tiesinės erdvės V poerdvio W papildinio iki V bazę.
        Kitaip sakant, randa tokį poerdvį U, kad V yra W ir U tiesioginė
         suma ir gražina jo bazę.
    """
    Q, pi, lift = V.quotient_abstract(W)
    Basis = [lift(v) for v in Q.basis()]
    return Basis
    # pi   yra projekcijos atvaizdis iš erdvės V į faktorerdvę V/W: pi(v) = v + W.
    # lift yra "atvirkštinis" atvaizdis iš faktorerdvės Q = V/W  į  erdvę V, tenkinantis13 # lygybę pi(lift(u)) = u  su visais u iš Q.
        
def papildom(vec, V):
    """
        Tiesinės erdvės V vektorių šeimą vec papildo vektoriais v1,..., vn iki
        erdvės V bazės ir gražina papildytus vektorius v1,..., vn.
    """
    return papildom_poerdviai(V.span(vec), V)
