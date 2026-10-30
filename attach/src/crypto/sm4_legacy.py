'''constant for SM4'''

# 系统参数FK
FK = (0XA3B1BAC6, 0X56AA3350, 0X677D9197, 0XB27022DC)

# 固定参数CK
CK = (0X00070E15, 0X1C232A31, 0X383F464D, 0X545B6269,
      0X70777E85, 0X8C939AA1, 0XA8AFB6BD, 0XC4CBD2D9,
      0XE0E7EEF5, 0XFC030A11, 0X181F262D, 0X343B4249,
      0X50575E65, 0X6C737A81, 0X888F969D, 0XA4ABB2B9,
      0XC0C7CED5, 0XDCE3EAF1, 0XF8FF060D, 0X141B2229,
      0X30373E45, 0X4C535A61, 0X686F767D, 0X848B9299,
      0XA0A7AEB5, 0XBCC3CAD1, 0XD8DFE6ED, 0XF4FB0209,
      0X10171E25, 0X2C333A41, 0X484F565D, 0X646B7279)

# S盒
S_BOX = {
    0X00: 0XD6, 0X01: 0X90, 0X02: 0XE9, 0X03: 0XFE, 0X04: 0XCC, 0X05: 0XE1, 0X06: 0X3D, 0X07: 0XB7,
    0X08: 0X16, 0X09: 0XB6, 0X0A: 0X14, 0X0B: 0XC2, 0X0C: 0X28, 0X0D: 0XFB, 0X0E: 0X2C, 0X0F: 0X05,
    0X10: 0X2B, 0X11: 0X67, 0X12: 0X9A, 0X13: 0X76, 0X14: 0X2A, 0X15: 0XBE, 0X16: 0X04, 0X17: 0XC3,
    0X18: 0XAA, 0X19: 0X44, 0X1A: 0X13, 0X1B: 0X26, 0X1C: 0X49, 0X1D: 0X86, 0X1E: 0X06, 0X1F: 0X99,
    0X20: 0X9C, 0X21: 0X42, 0X22: 0X50, 0X23: 0XF4, 0X24: 0X91, 0X25: 0XEF, 0X26: 0X98, 0X27: 0X7A,
    0X28: 0X33, 0X29: 0X54, 0X2A: 0X0B, 0X2B: 0X43, 0X2C: 0XED, 0X2D: 0XCF, 0X2E: 0XAC, 0X2F: 0X62,
    0X30: 0XE4, 0X31: 0XB3, 0X32: 0X1C, 0X33: 0XA9, 0X34: 0XC9, 0X35: 0X08, 0X36: 0XE8, 0X37: 0X95,
    0X38: 0X80, 0X39: 0XDF, 0X3A: 0X94, 0X3B: 0XFA, 0X3C: 0X75, 0X3D: 0X8F, 0X3E: 0X3F, 0X3F: 0XA6,
    0X40: 0X47, 0X41: 0X07, 0X42: 0XA7, 0X43: 0XFC, 0X44: 0XF3, 0X45: 0X73, 0X46: 0X17, 0X47: 0XBA,
    0X48: 0X83, 0X49: 0X59, 0X4A: 0X3C, 0X4B: 0X19, 0X4C: 0XE6, 0X4D: 0X85, 0X4E: 0X4F, 0X4F: 0XA8,
    0X50: 0X68, 0X51: 0X6B, 0X52: 0X81, 0X53: 0XB2, 0X54: 0X71, 0X55: 0X64, 0X56: 0XDA, 0X57: 0X8B,
    0X58: 0XF8, 0X59: 0XEB, 0X5A: 0X0F, 0X5B: 0X4B, 0X5C: 0X70, 0X5D: 0X56, 0X5E: 0X9D, 0X5F: 0X35,
    0X60: 0X1E, 0X61: 0X24, 0X62: 0X0E, 0X63: 0X5E, 0X64: 0X63, 0X65: 0X58, 0X66: 0XD1, 0X67: 0XA2,
    0X68: 0X25, 0X69: 0X22, 0X6A: 0X7C, 0X6B: 0X3B, 0X6C: 0X01, 0X6D: 0X21, 0X6E: 0X78, 0X6F: 0X87,
    0X70: 0XD4, 0X71: 0X00, 0X72: 0X46, 0X73: 0X57, 0X74: 0X9F, 0X75: 0XD3, 0X76: 0X27, 0X77: 0X52,
    0X78: 0X4C, 0X79: 0X36, 0X7A: 0X02, 0X7B: 0XE7, 0X7C: 0XA0, 0X7D: 0XC4, 0X7E: 0XC8, 0X7F: 0X9E,
    0X80: 0XEA, 0X81: 0XBF, 0X82: 0X8A, 0X83: 0XD2, 0X84: 0X40, 0X85: 0XC7, 0X86: 0X38, 0X87: 0XB5,
    0X88: 0XA3, 0X89: 0XF7, 0X8A: 0XF2, 0X8B: 0XCE, 0X8C: 0XF9, 0X8D: 0X61, 0X8E: 0X15, 0X8F: 0XA1,
    0X90: 0XE0, 0X91: 0XAE, 0X92: 0X5D, 0X93: 0XA4, 0X94: 0X9B, 0X95: 0X34, 0X96: 0X1A, 0X97: 0X55,
    0X98: 0XAD, 0X99: 0X93, 0X9A: 0X32, 0X9B: 0X30, 0X9C: 0XF5, 0X9D: 0X8C, 0X9E: 0XB1, 0X9F: 0XE3,
    0XA0: 0X1D, 0XA1: 0XF6, 0XA2: 0XE2, 0XA3: 0X2E, 0XA4: 0X82, 0XA5: 0X66, 0XA6: 0XCA, 0XA7: 0X60,
    0XA8: 0XC0, 0XA9: 0X29, 0XAA: 0X23, 0XAB: 0XAB, 0XAC: 0X0D, 0XAD: 0X53, 0XAE: 0X4E, 0XAF: 0X6F,
    0XB0: 0XD5, 0XB1: 0XDB, 0XB2: 0X37, 0XB3: 0X45, 0XB4: 0XDE, 0XB5: 0XFD, 0XB6: 0X8E, 0XB7: 0X2F,
    0XB8: 0X03, 0XB9: 0XFF, 0XBA: 0X6A, 0XBB: 0X72, 0XBC: 0X6D, 0XBD: 0X6C, 0XBE: 0X5B, 0XBF: 0X51,
    0XC0: 0X8D, 0XC1: 0X1B, 0XC2: 0XAF, 0XC3: 0X92, 0XC4: 0XBB, 0XC5: 0XDD, 0XC6: 0XBC, 0XC7: 0X7F,
    0XC8: 0X11, 0XC9: 0XD9, 0XCA: 0X5C, 0XCB: 0X41, 0XCC: 0X1F, 0XCD: 0X10, 0XCE: 0X5A, 0XCF: 0XD8,
    0XD0: 0X0A, 0XD1: 0XC1, 0XD2: 0X31, 0XD3: 0X88, 0XD4: 0XA5, 0XD5: 0XCD, 0XD6: 0X7B, 0XD7: 0XBD,
    0XD8: 0X2D, 0XD9: 0X74, 0XDA: 0XD0, 0XDB: 0X12, 0XDC: 0XB8, 0XDD: 0XE5, 0XDE: 0XB4, 0XDF: 0XB0,
    0XE0: 0X89, 0XE1: 0X69, 0XE2: 0X97, 0XE3: 0X4A, 0XE4: 0X0C, 0XE5: 0X96, 0XE6: 0X77, 0XE7: 0X7E,
    0XE8: 0X65, 0XE9: 0XB9, 0XEA: 0XF1, 0XEB: 0X09, 0XEC: 0XC5, 0XED: 0X6E, 0XEE: 0XC6, 0XEF: 0X84,
    0XF0: 0X18, 0XF1: 0XF0, 0XF2: 0X7D, 0XF3: 0XEC, 0XF4: 0X3A, 0XF5: 0XDC, 0XF6: 0X4D, 0XF7: 0X20,
    0XF8: 0X79, 0XF9: 0XEE, 0XFA: 0X5F, 0XFB: 0X3E, 0XFC: 0XD7, 0XFD: 0XCB, 0XFE: 0X39, 0XFF: 0X48
}

"""
basic.py, 负责数据格式转换和打包
"""

def pack(array, split_width=8):
    '''pack tuple of int into big int'''
    cnt = len(array)
    num = 0
    for i in range(cnt):
        num = (num << split_width) | array[i]
    return num

def unpack(num, full_width=32, split_width=8):
    '''unpack big int to int tuple, by bit width'''
    # 要求输出full_width ，是因为对输出元组元素的个数有对齐要求， 
    # 比如含多前缀0的整型有时需拆解为(0,0,num1,num2)
    mask = (1 << split_width) - 1
    cnt = full_width // split_width
    array = []
    for _ in range(cnt):
        array.append(num & mask)
        num = num >> split_width
    array.reverse()
    return tuple(array)

'''rk generation for SM4'''
import constant as Con

# 轮密钥缓存
_rk_cache = {}

def _non_linear_map(word):
    """
    非线性变换t, b_i = Sbox(a_i)
    input: 1 word
    ouput: 1 word, after sbox
    """
    _s_box = lambda byte: Con.S_BOX.get(byte)

    a0, a1, a2, a3 = unpack(word)
    B = (_s_box(a0), _s_box(a1), _s_box(a2), _s_box(a3))
    return pack(B)

def _linear_map(word):
    """
    线性变换L'
    L'(B) = B ^ (B <<< 13) ^ (B <<< 23)
    input: 1 word
    ouput: 1 word
    """
    _loop_left_shift = lambda num, base: ((num << base) & 0xFFFFFFFF) | (num >> (32-base))
    schedule = (13, 23)

    tmp = word
    for i in schedule:
        tmp ^= _loop_left_shift(word, i)
    return tmp


def _round_f(word_array, ck):
    '''
    轮函数(线性+非线性变换)
    rk_i = K_{i+4} = Ki ^ T'(Ki+1 ^ Ki+2 ^ Ki+3 ^ CKi) 
    '''
    k0, k1, k2, k3 = word_array
    k4 = _non_linear_map(k1 ^ k2 ^ k3 ^ ck)
    k4 = _linear_map(k4)
    return k0 ^ k4


def rks_gen(mk):
    """
    密钥扩展, 生成轮密钥
    :param mk: 加密密钥, 16bytes
    :return list
    """
    # try to read rks from cache
    rks = _rk_cache.get(mk)
    if rks is None:
        mk0, mk1, mk2, mk3 = unpack(mk, full_width=128, split_width=32)
        # k0, k1, k2, k3 = MK ^ FK
        keys = [mk0 ^ Con.FK[0], mk1 ^ Con.FK[1], mk2 ^ Con.FK[2], mk3 ^ Con.FK[3]]

        for i in range(32):
            rk = _round_f(keys[i:i+4], Con.CK[i]) 
            keys.append(rk)
        rks = keys[4:]

        # 加入轮密钥缓存中
        _rk_cache[mk] = rks
    return rks

'''
主模块
byte: 8bit int, 
word: 32bit int,
byte_array: 4*8bit int array, (a0, a1, a2, a3)
'''

import key_expansion as key
import constant as Con

SM4_ENCRYPT = 1
SM4_DECRYPT = 0

def _non_linear_map(word):
    """
    非线性变换t, b_i = Sbox(a_i)
    input: 1 word
    ouput: 1 word, after sbox
    """
    _s_box = lambda byte: Con.S_BOX.get(byte)

    a0, a1, a2, a3 = unpack(word)
    B = (_s_box(a0), _s_box(a1), _s_box(a2), _s_box(a3))
    return pack(B)

def _linear_map(word):
    """
    线性变换L
    L(B) = B ^ (B <<< 2) ^ (B <<< 10) ^ (B <<< 18) ^ (B <<< 24)
    input: 1 word
    ouput: 1 word
    """
    _loop_left_shift = lambda num, base: ((num << base) & 0xFFFFFFFF) | (num >> (32-base))
    schedule = (2, 10, 18, 24)

    tmp = word
    for i in schedule:
        tmp ^= _loop_left_shift(word, i)
    return tmp

def _round_f(word_array, rk):
    """
    轮函数变换
    F(X0, X1, X2, X3, rk) = X0 ^ T(X1 ^ X2 ^ X3 ^ rk)
    :param word_array: word per (X0, X1, X2, X3)
    :param rk: round keys 4bytes
    """
    x0, x1, x2, x3 = word_array
    x4 = _non_linear_map(x1 ^ x2 ^ x3 ^ rk)
    x4 = _linear_map(x4)
    return x0 ^ x4

def crypt(num, mk, mode=SM4_ENCRYPT):
    """
    SM4加密和解密
    :param num: 密文或明文 16bytes=4words, int
    :param mk:  密钥 16bytes, int
    :param mode: 轮密钥顺序, 加密或解密
    """
    x = list( unpack(num, full_width=128, split_width=32))
    rks = key.rks_gen(mk)
    if mode == SM4_DECRYPT:
        # 解密则轮密钥顺序相反
        rks = rks[::-1]

    #轮函数
    for i in range(32):
        x.append( _round_f(x[i:i + 4], rks[i]))

    # 反序变换R
    return pack( x[-4:][::-1], split_width=32)
