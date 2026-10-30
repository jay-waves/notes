"""密钥扩展模块 key.py"""
import des_table
from des_table import permutate

def PC1(key_64b):
    '''
    PC1置换
    input: 初始密钥 key_64b 
    return: 置换压缩后-初始轮密钥 rkey0_56b
    '''
    return permutate(table.key_PC_1, key_64b, 64)

def PC2(LK_28b, RK_28b):
    '''
    PC2置换
    input: 左移位后的左右轮密钥 2*28b
    return: 本轮Feistel子密钥 rKi_48b
    '''
    return permutate(table.key_PC_2, (LK_28b<<28) + RK_28b, 56)

def round(LK_28b, RK_28b, cnt):
    '''
    单轮子密钥生成
    input: 上一轮左右轮密钥 2*28b, 当前轮数 cnt
    return: 新一轮左右轮密钥 2*28b, 本轮Feistel子密钥 rKi_48b
    '''
    left_shift_bin = table.key_left_shift_schedule[cnt]
    LK_28b = ((LK_28b << left_shift_bin) & 0xFFFFFFF) | (LK_28b >> (28-left_shift_bin))
    RK_28b = ((RK_28b << left_shift_bin) & 0xFFFFFFF) | (RK_28b >> (28-left_shift_bin))
    # 采用int类型存储数据，不能使用截取
    return LK_28b, RK_28b, PC2(LK_28b, RK_28b)

def rk_gen(K):
    '''
    16轮密钥生成
    return 16轮密钥数组
    '''
    K = PC1(K)
    LK = K >> 28
    RK = K & 0xFFF_FFFF
    rks = [0 for _ in range(16)]
    for i in range(16):
        LK, RK, rks[i] = round(LK, RK, i)
    return rks

