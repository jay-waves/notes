from math import sqrt
from random import randint
from typing import Iterable

def power_mod(num, exp, mod):
    '''平方乘算法：更接近c的写法，位运算'''
    ans = 1
    base = num
    while exp != 0:
        if exp & 1 != 0:
            ans = (base * ans) % mod
        base = (base * base) % mod
        exp >>= 1
    return ans % mod

def egcd(a, b):
    '''扩展欧几里得求最大公因子算法, 允许a和b为负'''
    a_orig, b_orig = a, b
    a = -a if a<0 else a
    b = -b if b<0 else b

    #matrix calculation
    r, s, t = a, 1, 0
    r1, s1, t1 = b, 0, 1
    #gcd
    while r1 != 0:
        q = r // r1
        tmp1, tmp2, tmp3 = r - r1 * q, s - s1 * q, t - t1 * q
        r, s, t = r1, s1, t1
        r1, s1, t1 = tmp1, tmp2, tmp3
    gcd = r
    assert gcd > 0, "gcd error"
    assert s * a + t * b == gcd, "s*a+t*b==gcd error"

    s = -s if a_orig < 0 else s
    t = -s if b_orig < 0 else t
    return s, t, gcd
    
def gcd (num1, num2):
    '''简单求两数最大公因子'''
    if num1 < num2: #调整大小顺序
        num1, num2 = num2, num1
    else:
        pass
    while num2 != 0: #辗转相除
        num1, num2 = num2, num1 % num2
    return num1

def lcm(a, b):
    '''简单求两数最小公倍数'''
    _,_,gcd = egcd(a, b)
    return a*b//gcd

def lcm_list(nums):
    '''求多个数最小公倍数'''
    if len(nums) == 0:
        raise ValueError('列表为空')
    x = nums[0]
    for num in nums:
        x = lcm(x, num)
    return x

def find_inv(a, p):
    '''欧几里得方法计算逆元'''
    b, _, gcd = egcd(a, p)
    assert gcd == 1, "error, p and a is not coprime"
    return b % p

def crt(a, m):
	'''中国剩余定理 chinese_remainder_theorem'''
    # 这个是a都为0情况, x应为所有m的最大公倍数. 其实就是结果不互素的特例.
    for a_i in a:
        if a_i == 0:
            return lcm_list(m)
    M = 1
    for m_i in m:
        M *= m_i
    x = 0
    for m_i, a_i in zip(m, a):
        M_i = M // m_i
        x += a_i * M_i * find_inv(M_i, m_i)
    return x % M

def find_prime_factors(n):
    '''找到整数n的所有素因子'''
    factors = set()
    while not n%2:
	    factors.add(2)
	    n //= 2
	for i in range(3, int(sqrt(n))+1, 2):
		while not n%i: 	  
			factors.add(i)
			n //= i
	if n>2:
		factors.add(n)
	return sorted(list(factors))

def bitlen(x):
    '''
    Calculates the bitlength of x
    '''
    assert x >= 0
    n = 0
    while x > 0:
        n = n+1
        x = x>>1
    return n
    
def isqrt(n):
    '''
    Calculates the integer square root
    for arbitrary large nonnegative integers
    '''
    assert n>=0, "square root not defined for negative numbers"
    
    if n == 0:
        return 0
    # use built-in divmod (a, b): (a//b, a%b)
    a, b = divmod(bitlen(n), 2)
    x = 2**(a+b)
    while True:
        y = (x + n//x)//2
        if y >= x:
            return x
        x = y
        
def is_perfect_square(n):
    '''
    If n is a perfect square it returns sqrt(n),
    otherwise returns -1
    '''
    h = n & 0xF; #last hexadecimal "digit"

    if h > 9:
        return -1 # return immediately in 6 cases out of 16.

    # Take advantage of Boolean short-circuit evaluation
    if ( h != 2 and h != 3 and h != 5 and h != 6 and h != 7 and h != 8 ):
        # take square root if you must
        t = isqrt(n)
        if t*t == n:
            return t
        else:
            return -1
    return -1

'''<--- 以下是素数运算 --->'''

def gen_prime(nbits):
	'''
	Generates a prime of b bits using the
	miller_rabin_test. 2^b <= n < 2^(b+1)-1
	'''
	while True:
		p = random.getrandbits(nbits)
		#force p to have nbits and be odd
		p |= 2**nbits | 1
		if is_prime(p):
			return p

def get_prime_in(start, stop):
	'''
	Generates a prime within the given range
	using the miller_rabin_test
	'''
	while True:
		p = random.randrange(start,stop-1)
		p |= 1
		if is_prime(p):
			return p

def next_prime(n):
    '''求下一个素数'''
    n = (n + 1) | 1 # 考虑2
    while not is_prime(n):
        n += 2
    return n

def is_coprime(nums: Iterable):
    '''判断多个整数是否互素'''
    for i in range(0, len(nums)):
        for j in range(i + 1, len(nums)):
            *_, gcd = egcd(nums[i], nums[j])
            if gcd != 1:
                return False
    return True

def get_coprime(num, length):
    '''选出和参数num互素的一个数'''
    rand = randint(2**(length - 1), 2**(length) - 1)
    while is_coprime([rand, num]) != True:
        rand = next_prime(rand)
    return rand

def is_prime(n, k=5):
    """Check if n is prime using the Miller-Rabin primality test."""
    if n == 2 or n == 3:
        return True
    if n <= 1 or n % 2 == 0:
        return False

    # Find d and r such that n-1 = 2^r * d
    d = n - 1
    r = 0
    while d % 2 == 0:
        d //= 2
        r += 1

    # Repeat k times
    for _ in range(k):
        a = randint(2, n - 2)
        x = power_mod(a, d, n)
        if x == 1 or x == n - 1:
            continue
        for _ in range(r - 1):
            x = power_mod(x, 2, n)
            if x == n - 1:
                break
        else:
            return False
    return True


'''<--以下为矩阵运算-->'''
def invert_matrix(A):
    '''求矩阵A_{n*n}逆元, 返回逆矩阵A^-1'''
    n = len(A)
    # 判断矩阵是否可逆, 即检查行列式是否为0
    if not is_invertible(A):
        raise ValueError('Matrix is not invertible.')

    # 构造单位矩阵
    I = [[1.0 if i == j else 0.0 for j in range(n)] for i in range(n)]
    # 将 A 和 I 进行拼接
    AI = [row_A + row_I for row_A, row_I in zip(A, I)]

    # 高斯-约旦消元
    for i in range(n):
        max_row = i
        for j in range(i, n):
            if abs(AI[j][i]) > abs(AI[max_row][i]):
                max_row = j
        if max_row != i:
            AI[i], AI[max_row] = AI[max_row], AI[i]

        # 对第 i 行进行归一化
        pivot = AI[i][i]
        for j in range(2 * n):
            AI[i][j] /= pivot
        # 对其他行进行消元操作
        for j in range(n):
            if i != j:
                ratio = AI[j][i]
                for k in range(2 * n):
                    AI[j][k] -= ratio * AI[i][k]

    # 取出右边的部分作为逆矩阵
    A_inv = [row[n:] for row in AI]
    return A_inv

def is_invertible(A):
    '''
    判断一个矩阵 A_{n*n} 是否可逆
    '''
    if len(A) != len(A[0]):
        # 矩阵 A 不是方阵，不可逆
        return False

    n = len(A)
    if n == 1:
        # 矩阵 A 是1x1的，可逆
        return True
    if n == 2:
        # 矩阵 A 是2x2的，套公式，直接计算行列式因子
        det_A = A[0][0]*A[1][1] - A[0][1]*A[1][0]
        return det_A != 0

    # 矩阵 A 是大于2x2的，使用高斯消元法，排查列秩row_rank
    for j in range(n):
        # 将第 j 列以下的元素中绝对值最大的行交换到第 j 行
        max_row = j
        for i in range(j, n):
            if abs(A[i][j]) > abs(A[max_row][j]):
                max_row = i
        if max_row != j:
            A[j], A[max_row] = A[max_row], A[j]

        if A[j][j] == 0:
            # 第 j 列以下所有行的第 j 个元素都是0，矩阵 A 不可逆
            return False

        # 将第 j 列以下的所有行都消成0
        for i in range(j+1, n):
            ratio = A[i][j] / A[j][j]
            for k in range(j+1, n):
                A[i][k] -= ratio * A[j][k]
            A[i][j] = 0

    return True

def mul_matrix(A, B):
    '''矩阵乘法, A*B'''
    assert len(A[0]) == len(B), 'Matrix A\'s column number must be equal to Matrix B\'s row number.'

    C = [[0 for j in range(len(B[0]))] for i in range(len(A))] # 初始化C的内存
    for i in range(len(A)):
        for j in range(len(B[0])):
            for k in range(len(B)):
                C[i][j] += A[i][k]*B[k][j]
    return C

def solve_multi_equals(m):
    '''解多元一次方程，以矩阵形式表示
    return: 解列表
    注意：不检查是否存在解，需要额外验证是否满秩'''
    n = len(m[0])-1 # 元数
    # 系数列进行高斯消元，能够保证前n行*前n列是单位矩阵（解矩阵）
    for i in range(n):
        # 将该列最大值所在行调换上来，保证前i列满秩
        max_row = i
        for j in range(i, n):
            if abs(m[j][i]) > abs(m[max_row][i]):
                max_row = j
        if max_row != i:
            m[i], m[max_row] = m[max_row], m[i]

        # 对第 i 行进行归一化
        pivot = m[i][i]
        for j in range(n+1):
            m[i][j] /= pivot
        # 对其他行进行消元操作
        for j in range(n):
            if i != j:
                ratio = m[j][i]
                for k in range(n+1):
                    m[j][k] -= ratio * m[i][k]
    return [m[i][n] for i in range(n)]

'''
def pos_egcd(a, b):
    egcd, 最小正整系数, 请保证a和b大于零
    :return (s, t, gcd) for s*a + t*b = gcd

    # normal egcd
    r, s, t = a, 1, 0
    r1, s1, t1 = b, 0, 1
    while r1 != 0:
        q = r // r1
        r, r1 = r1, r - q * r1
        s, s1 = s1, s - q * s1
        t, t1 = t1, t - q * t1
    gcd = r

    # lowest positive coefficient x, x*a + y*b = gcd + 0 * lcm(a*b//gcd)
    # general solution for x is 'x_0 + (b/gcd)*n', while y is 'y_0 - (a/gcd)*n'
    # so k >= y_0//a//gcd, while k <= -x_0//b//gcd
    x_0, y_0 = s, t

    k_min = 1+ (-x_0)//(b//gcd)
    k_max = y_0//(a//gcd)
    k = k_min
    if k <= k_max:
        x = x_0 + k*(b//gcd)
        y = y_0 - k*(a//gcd)
    return x, y, gcd
    该函数有一些问题，要保证一定有双正整数解，必须要在环上进行求逆元。整数域上，若gcd较小，一定会有负数系数
    '''

