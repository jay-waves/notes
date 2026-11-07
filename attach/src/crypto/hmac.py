hash = sha1
digest_size = 20 # sha1

block_size = 64
opad = b'\x5c' * block_size 
ipad = b'\x36' * block_size 


def _xor(x: bytes, y: bytes)->bytes:
    return bytes(x^y for x, y in zip(x, y))

def hmac(k: bytes, msg: bytes)->bytes:
    # test length of k, then padding
    if len(k) > block_size:
        k = hash_funct(k)
    while len(k) != block_size:
        k += b'\x00'
    
    # inside hash
    inside = hash(_xor(k, ipad) + msg)
    
    # outside hash
    outside = hash(_xor(k, opad) + inside)

    return outside
