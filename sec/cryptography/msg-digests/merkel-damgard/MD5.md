MD-5 消息摘要算法由 Ronald Linn Rivest 于 1992 年公开, 输出 `128b`, 分组长度为 `512b`, 速度较快 (比 sha1 快), 2004 年被王小云院士证明无法抵抗碰撞攻击, MD-5 摘要长度较短, 易受[第二类生日攻击](../birthday-attack.md). 

MD-5 不限定输入数据长度, 如果输入长度高于 $2^{64}$ 位, 就只用其低 $2^{64}$ 位. 后续哈希函数考虑安全性, 为输入设定了上限.

MD-5 遵循 [Merkle-Damgard 结构](md-hash.md), 结构大致如下:

```python
def md5(msg: bytes) -> int:
	msg <- padding(msg)                 # 填充消息
	chunks <- divide(msg)               # 分组为 512b 块
	regs <- IV                       # 初始化寄存器
	for chunk in chunks:                # 迭代, 更新寄存器
		process_chunk(msg, regs)        
	return cat(regs)
	
# md5 标准输出为 128b 二进制数, 但通常表示为 32 字符的十六进制串, 
# 如空串 "" 的杂凑值为: d41d8cd98f00b204e9800998ecf8427e
# regs 为全局杂凑值寄存器, 每轮迭代都会更新它. 面向对象方式的实现中, 杂凑值不会立即输出, 而是维护在内部 regs 内, 允许不断添加新数据不断迭代.
```

### 填充

1. 输入消息长度 $k$, 消息 $msg$
2. 若 $k\pmod{512}<448$, 填充 $msg$ 单比特 `1`, 再填充 `0` 至新长度 $k'\pmod{512}\equiv 448$
3. 若 $k\pmod{512} > 448$, 填充 $msg$ 单比特 `1`, 再填充 `0` 满当前块, 再继续填充 `0` 至新长度 $k'\pmod{512}\equiv 448$
4. 将消息长度 $k$ 转换为 `64b` 二进制串 $k\_len$. 若 $k\_len>64$, 仅截取后 `64b`

*注意, MD-5 使用小端存储字节, 数字向二进制串转化时, 需要调整端序为大端.* 端序不会影响安全性. 比特0的填充长度 $t$, 满足 $k+1+t\equiv 448\pmod{512}$, 由此可简化.

```python
def padding(msg: bytes):
	'''use `Blen` as byte len; `blen` as bit len; `pdd` as padding.'''
	Blen_m = len(msg)
	blen_m = Blen_m * 8 
	Blen_pdd = (56-(Blen_m%64))%64
	pdd_zero = b'\x80' + b'\x00' * (Blen_pdd-1)
	pdd_mlen = blen_m.to_bytes(8, byteorder='little')
	return msg + pdd_zero + pdd_mlen
```

### 单轮迭代结构

单轮结构:
<img src="../../../../attach/img/sec/sec-crypto-md5-round-structure.avif" alt="图源wiki" width="250">

```python
'''input: msg: bytes'''
from math import floor, sin

# r specifies the per-round shift amounts
r = (
    7, 12, 17, 22, 7, 12, 17, 22, 7, 12, 17, 22, 7, 12, 17, 22,
    5, 9, 14, 20, 5, 9, 14, 20, 5, 9, 14, 20, 5, 9, 14, 20,
    4, 11, 16, 23, 4, 11, 16, 23, 4, 11, 16, 23, 4, 11, 16, 23,
    6, 10, 15, 21, 6, 10, 15, 21, 6, 10, 15, 21, 6, 10, 15, 21
)

# all vars are unsigned 32 bits and wrap modulo 2^32 
mask = 0xffffffff

# init global registers with IV
h0, h1, h2, h3 = 0x67452301, 0xEFCDAB89, 0x98BADCFE, 0x10325476

# use binary integer part of sin(1..64) as key constants:
k = []
for i from 0 to 63:
	k.append( floor(abs(sin(i+1))) << 32 )

def left_rotate(x, c):
    return ((x << c) | (x >> (32 - c))) & mask


# for each 512b chunk
def md5_chunk(w: list):
	'''w: words of one chunk, using little endian'''
    global h0, h1, h2, h3
    a, b, c, d = h0, h1, h2, h3
    for i in range(64):
        if 0 <= i <= 15:
            f = (b & c) | (~b & d)
            g = i
        elif 16 <= i <= 31:
            f = (d & b) | (~d & c)
            g = (5*i + 1) % 16
        elif 32 <= i <= 47:
            f = b ^ c ^ d
            g = (3*i + 5) % 16
        elif 48 <= i <= 63:
            f = c ^ (b | ~d)
            g = (7*i) % 16
        
        temp = d
        d = c
        c = b
        b += left_rotate((a + f + k[i] + w[g]), r[i])
        a = temp

    # update global registers
    h0 = (h0 + a) & mask
    h1 = (h1 + b) & mask
    h2 = (h2 + c) & mask
    h3 = (h3 + d) & mask

'''the following is not important''''

# main
msg = padding(msg)
chunks = msg_to_chunks(msg)
for chunk in chunks:
	words = chunk_to_words(chunk)
	md5_chunk(words)
digest()

# data process, just ignore
def chunk_to_words(chunk: bytes):
	'''use little endian, divide one chunk to 16 words(int)'''
	assert len(chunk)==64
	words = []
	for i in range(0, 64, 4):
		word = (chunk[i] |
				(chunk[i+1] << 8)  |
				(chunk[i+2] << 16) |
				(chunk[i+3] << 24))
		words.append(word)
	return words

def msg_to_chunks(msg: bytes):
	assert len(msg)%64 == 0
	chunks = []
	chunk_size = 64
	for i in range(0, len(msg), chunk_size):
		chunks.append(msg[i:i+chunk_size])
	return chunks

def digest():
	pass
```

