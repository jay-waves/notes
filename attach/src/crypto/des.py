"""
我这拿整型实现真是贱呐，给自己没事找事

- P: permutate
- C: compress
- S: substitute
- LK: left_key_28b
- RK: right_key_28b
- rK: round_key_48b
"""

import des_table
from des_table import permutate
import des_key

def F_Sbox(data_48b):
    '''
    Sbox代换
    input: 扩展并和Ki异或后的数据 data_48b
    return: 经S盒代换后的数据 data_32b
    '''
    data_32b = 0
    for i in range(8):
        data = (data_48b >> (6*(7-i))) & 0x3F
        row = (data & 0x20) >> 4 | (data & 0x01) #取出首尾位
        col = (data & 0x1E) >> 1 #取出中间四位
        data_32b = (data_32b << 4) | table.Sbox[i][row][col]
    return data_32b

def F_IP(data_64b):
    '''
    IP置换
    input: 初始数据 64b
    return: 经IP置换后的数据 64b
    '''
    return permutate(table.IP, data_64b, 64)

def F_IP_inv(data_64b):
    '''
    IP置换
    input: 轮加密后数据 64b
    return: 经IP逆置换后的数据 64b
    '''
    return permutate(table.IP_inv, data_64b, 64)

def F_E(R_32b):
    '''
    E扩展置换
    input: 上轮加密后R 32b
    return: 经E扩展置换后的数据 48b
    '''
    return permutate(table.extension, R_32b, 32)
    
def F_P(data_32b):
    '''
    Pbox置换
    input: S盒代换压缩后的数据 32b
    return: 经Pbox置换后的数据 32b
    '''
    return permutate(table.Pbox, data_32b, 32)

def F_round(cnt, rk, L_32b, R_32b):
    '''
    Feistel轮加密主体
    input: 
        cnt: 轮数 
        rk: 轮密钥 上
        L_32b: 上一轮左半部分 32b
        R_32b: 上一轮右半部分 32b           
    return: 
        下一轮 左半部分32b, 右半部分32b
    '''
    data_48b = F_E(R_32b)
    data_48b = rk ^ data_48b
    data_32b = F_Sbox(data_48b)
    data_32b = F_P(data_32b)
    data_32b = data_32b ^ L_32b
    return R_32b, data_32b

def DES(k, data, is_enc=True)->int:
    '''
    input:
        k: 初始密钥
        data: 待加密/解密数据
        op: 模式, 1代表加密, 0代表解密
    return:
        (int)加密/解密后的数据
    '''
    #16轮密钥生成
    K = key.rk_gen(k)

    #初始化数据
    data0 = F_IP(data)
    L = data0 >>32
    R = data0 & 0xFFFF_FFFF
    
	for cnt in range(16):
		i = cnt if is_enc else (15-cnt)
		L, R = F_round(cnt, K[i], L, R)
    
    data_64b = (R<<32) | L
    cipher = F_IP_inv(data_64b)
    return cipher

