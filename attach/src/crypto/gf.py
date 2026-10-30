"""
+-* on finite field GF(2^8)
/mod on finite field GF(2)
注意： 
GF(2) 是数域{0， 1}; 
GF(2)[x]和R[x]类似, 是任意多项式; 
GF(2^8) 指的是GF(2)[x]/(irred_poly[x]), 指域上多项式
"""

irred_poly = 0b100011011

def add_or_sub(x_bin, y_bin):
    return x_bin ^ y_bin

def mul(x_bin, y_bin):
    '''x*y on the GF(2^8), with modulo irred_poly'''
    z_bin = 0
    for i in range(8):
        if y_bin & (1 << i):
            z_bin ^= x_bin << i
    # mod irreducible poly
    for i in range(14, 7, -1):
        if z_bin & (1 << i):
            z_bin ^= (irred_poly << (i - 8))
    return z_bin

def mod_div(x_bin, y_bin):
    '''x /mod y, return q, r. on the GF(2)[x]'''
    q = 0; r = x_bin
    r_deg = len(bin(r)) -3
    y_deg = len(bin(y_bin)) -3

    while y_deg <= r_deg:
        q = q ^ (1 << (r_deg-y_deg))
        r = r ^ (y_bin << (r_deg-y_deg))
        if y_bin and not r:
            #此情况，由于y=1的位数已经最低，所以r位数不可能更低了. r=0时退出即可
            break
        r_deg = len(bin(r)) -3 #自动去掉前缀0，即自动缩减到当前最高位
    return (q, r)

def fast_power(num, exp):
    '''num^exp , on the GF(2^8) with irred_poly 0b11b'''
    ans = 1
    base = num
    while exp != 0:
        if exp & 1 != 0:
            ans = mul(base, ans)
        base = mul(base, base)
        exp >>= 1
    _, r = mod_div(ans, irred_poly)
    return r

def egcd(x, y):
    '''return s, t, gcd, such that s*x + t*y = gcd'''
    d, s, t = y, 0, 1
    d1, s1, t1 = x, 1, 0
    while d != 0:
        q, r = mod_div(d1, d)
        d1, d = d, r
        s1, s = s, s1 ^ mul(q, s)
        t1, t = t, t1 ^ mul(q, t)

    return s1, t1, d1


def find_inverse(a, m):
    x, _, _ = egcd(a, m)  # 并没有检查两者是否互素
    return x

def mmul(A, B):
    '''矩阵乘法, A*B'''
    r = len(A)
    c = len(B[0])
    assert len(A[0]) == len(B), 'invalid matrix form'

    C = [[0 for j in range(c)] for i in range(r)] # 初始化C的内存
    for i in range(r):
        for j in range(c):
            for k in range(len(B)):
                C[i][j] = add_or_sub(C[i][j], mul(A[i][k], B[k][j]))
    return C
