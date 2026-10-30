"""
AES 密钥扩展模块
"""

'''might be more natural to use OO of key word'''
from aes_constant import s_box, Rcon, Nk, Nr, Nb

def sub_word(w):
	return [s_box[b>>4][b&0xF] for b in w]

def rot_word(w):
	'''cyclic shift'''
    return w[1:] + w[:1]

def xor_word(w1, w2):
    return [b1^b2 for b1, b2 in zip(w1, w2)]

def g(w, rcon):
	w = rot_word(w)
	w = subword(w)
	w = xor_word(w, rcon)
	return w

def key_expansion(in_key):
    '''
    AES key expansion for round keys
    Input:
        in_key: input initial key 4*Nk bytes, split as byte
    Output:
        round_key: Nb*(Nr+1) bytes for 4 bytes as a w, split as word(4 bytes)
    '''
    # bytes -> key state: {kw1, kw2, kw3, kw4}
    words = [in_key[4*i:4*(i+1)] for i in range(Nk)]

    for i in range(Nk, Nb * (Nr+1)): 
	    # byte by byte
        w = words[i-1][:]
        if (i % Nk) == 0:
	        w = g(w, Rcon[i//Nk-1])
        elif (Nk > 6) and (i % Nk == 4): 
	        # backword compatibility
            w = sub_word(w)
        words.append(xor_word(w, words[i-Nk]  ))
        
    return words
