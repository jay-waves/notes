# [PKCS#1](/Security/密码学/公钥密码/RSA/PKCS1.md) v2.0 中描述的 RSA 加密及填充算法:

from hashlib import sha1
import rsa

hash = lambda m: sha1(m).digest()
hlen: int = sha1.digest_size

i2osp = lambda num, length: num.to_bytes(length, 'big')
os2ip = lambda bstr: int.from_bytes(bstr, 'big')
read_hex_bstr = lambda : bytes.fromhex(input().strip()[2:])
xor = lambdadata, mask: bytes(a^b for a,b in zip(data, mask))

def mgf1(z: bytes, l: int) -> bytes:
    assert l <= (hlen << 32), "mask too long"

    t: bytes = b''
    cnt = 0
    while len(t) < l:
        c = i2osp(cnt, 4)
        t += hash(z + c)
        cnt += 1
    return t[:l]


def encode(m: bytes, k: int, label: bytes, seed: bytes) -> bytes:
    m_len = len(m)
    assert m_len <= k - 2*hlen - 2, "message too long"

    ps = b'\x00' * (k - m_len - 2 * hlen - 2)

    assert len(label) < 2**61, "label too long"
    label_hash = hash(label)

    db = label_hash + ps + b'\x01' + m
    assert len(db) == k-hlen-1, "wrong db length"

    db_mask = mgf1(seed, k - hlen - 1)
    masked_db = xor(db, db_mask)
    seed_mask = mgf1(masked_db, hlen)
    masked_seed = xor(seed, seed_mask)

    return b'\x00' + masked_seed + masked_db 


def decode(em: bytes, k: int, label: bytes) -> bytes:
    assert em[0] == 0, "begin of em should be 0x00"
    assert len(em) == k
    assert k >= 2*hlen+2, "not enough length of k"
    
    #unpack
    masked_seed, masked_db = em[1:1 + hlen], em[1 + hlen:] 

    seed_mask = mgf1(masked_db, hlen)
    seed = xor(masked_seed, seed_mask)
    db_mask = mgf1(seed, k - hlen - 1)
    db = xor(masked_db, db_mask)

    # verify
    assert len(label) < 2**61, "label too long"
    label_hash = hash(label)
    rcvd_label_hash = db[:hlen] # newly received label
    assert label_hash == rcvd_label_hash, "Label hashes are different"

    # 从 ps 一直读到分界符 0x01
    ps_len = 0
    for i in range(hlen, len(db)):
        if (db[i] == 1):
            break
        elif (db[i] != 0 ):
            raise ValueError("Padding string should be only zeros")
        ps_len += 1

    assert ps_len != len(db)-hlen, "separator 0x01 not found"
    sep = db[hlen + ps_len] # separator
    assert sep == 1, "Separator between SP and M should be 0x01"

    m = db[hlen + ps_len + 1:]
    return m

K=1024 # RSA 安全参数
def encrypt(e, n, data: bytes, seed: bytes, label: bytes=b'0x'):
	try:
		em = encode(data, K, label, seed)
	except Exception:
		...
	else:
		em = os2ip(em)
		return rsa(em, e, n)


def decrypt(d, n, data, seed, label=b'0x'):
	try:
		assert len(data) == K, "invalid length of c"
		cphr = os2ip(data)
		assert c <= n, "c > n, invalid c"
		msg = rsa(cphr, e, n)
		em = i2osp(msg, k)
		# unpadding
		m = decode(em, k, label)
	except Exception:
		...
	else:
		return m.hex()
