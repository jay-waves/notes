"""
AES
"""


import gf # 有限域 GF(GF(2^{8})^{4})
import aes_key
import aes_constant as Con

def add_round_key(state, key):
    '''add round key'''
    for w in range(Con.Nb):
        for byte in range(4):
            state[w][byte] ^= key[w][byte]

def sub_bytes(state, sbox=Con.s_box):
    '''substitute bytes'''
	for w in range(Con.Nb):
		for byte in range(4):
			idxx = state[w][byte]>>4
			idxy=state[w][byte]&0xF
			state[w][byte] = sbox[idxx][idxy]

def shift_rows(state):
    '''shift rows'''
    for r in range(1, 4):        # go through row, not word of state
        for _ in range(r):       # cyclic shift num of bits 
             for i in range(3):  # just cyclic shift
                state[i][r], state[i+1][r] = state[i+1][r], state[i][r]

def inv_shift_rows(state):
	for r in range(1, 4):
		for _ in range(r):
			for i in range(3, 0, -1):
				state[i][r], state[i-1][r] = state[i-1][r], state[i][r]

def mix_columns(state, op=1):
    '''mix columns'''
    state[:] = gf.mmul(state, Con.mix_matrix)  
    # use slice to visit original address

def inv_mix_columns(state):
	'''mix columns'''
	state[:] = gf.mmul(state, Con.inv_mix_matrix) 

def dec(in_block, rkey):
    '''
    decryption for in_block data
    Input:
        in_block: list of 4*Nb bytes, split as byte
        rkey: list of (Nr+1)*Nb*4 bytes from key_expansion, split as word
    Output:
        out_block: list of 4*Nb bytes
    '''
    # 4*Nb bytes -> state: w0, w1, w2, w3
    state = [[0] * 4 for _ in range(Con.Nb)]
    for w in range(Con.Nb):
        for byte in range(4):
            state[w][byte] = in_block[4*w + byte]

    add_round_key(state, rkey[Con.Nr * Con.Nb:])
    for round in range(Con.Nr-1, 0, -1):
        sub_bytes(state, sbox=Con.inv_s_box)
        inv_shift_rows(state)
        add_round_key(state, rkey[round*Con.Nb: (round+1)*Con.Nb])
        inv_mix_columns(state)
    # last round
    sub_bytes(state, sbox=Con.inv_s_box)
    inv_shift_rows(state)
    add_round_key(state, rkey[:Con.Nb])

	# state -> 4*Nb bytes
    out_block = [0] * 4 * Con.Nb
    for w in range(Con.Nb):
        for b in range(4):
            out_block[w*4+b] = state[w][b]
    return out_block

def enc(in_block, rkey):
    '''
    encryption for in_block data
    Input:
        in_block: list of 4*Nb bytes, split as byte
        rkey: list of (Nr+1)*Nb*4 bytes from key_expansion, split as word
    Output:
        out_block: list of 4*Nb bytes
    '''
    # state: w0, w1, w2, w3
    state = [[0] * 4 for _ in range(Con.Nb)]
    for w in range(Con.Nb):
        for byte in range(4):
            state[w][byte] = in_block[4*w + byte]

    add_round_key(state, rkey[0: Con.Nb])
    for round in range(1, Con.Nr):
        sub_bytes(state)
        shift_rows(state)
        mix_columns(state)
        add_round_key(state, rkey[round*Con.Nb: (round+1)*Con.Nb])
    # last round
    sub_bytes(state)
    shift_rows(state)
    add_round_key(state, rkey[Con.Nr * Con.Nb:])

    out_block = [0] * 4 * Con.Nb
    for w in range(Con.Nb):
        for b in range(4):
            out_block[w*4+b] = state[w][b]
    return out_block


