## 教科书式RSA实现

def egcd(a, b):
    '''扩展欧几里得求最大公因子算法
    :return (s, t, gcd) for s*a + t*b = gcd'''

    r, s, t = a, 1, 0
    r1, s1, t1 = b, 0, 1
    while r1 != 0:
        q = r // r1
        r, r1 = r1, r - q * r1
        s, s1 = s1, s - q * s1
        t, t1 = t1, t - q * t1
    return s, t, r

def find_inv(a, p):
    '''欧几里得方法计算逆元'''
    b, _, gcd = egcd(a, p)
    assert gcd == 1, "error, not coprime"
    return b % p


def init_key(p, q, e):
    '''RSA密钥生成函数
    :return (pub_k, pri_k, N)'''

    N = p * q
    phi = (p - 1) * (q - 1)
    d = find_inv(e, phi)

    return e, d, N

def crypt(data, key, N):
    '''encrypt or decrypto'''
    data = pow(data, key, N)
    return data

def key_gen(safe_params: int =1024):
	'''
	key generation for RSA
	input:
			safe_params: 安全参数, 即有限域大小, n的比特位数
	ouput: 
			dict[n, e, d]
	'''
	# generate p/q
	p_len = safe_params//2 + 4
	p = get_prime(p_len)
	while not is_prime((p-1)//2):
			# 选取p为安全素数，这个效率很低，就选一个意思意思吧
			p = next_prime(p)
	q = get_prime(safe_params-p_len)  # 位数不同，和p拉开大小差距。
	n = p * q

	# generate d/e
	phi = (p - 1) * (q - 1)
	d = randint(max(p, q), phi - 1)
	if not is_prime(d):  
			'''
			需保证d要大于p、q，并且接近phi，并且是安全素数。
			同时保证了d足够大 (大于N**0.25), 并且和phi互素
			'''
			d = next_prime(d)
	e = find_inv(d, phi)

	# test
	assert e != 1 and e != 2, "error, e is too small, try again"
	assert is_coprime([d, phi])
	msg = 12345678
	assert pow(pow(msg, e, n), d, n) == msg, "invalid key, cipher similar to msg"

	return {'n': n, 'e': e, 'd': d, 'safe_params': safe_params}

