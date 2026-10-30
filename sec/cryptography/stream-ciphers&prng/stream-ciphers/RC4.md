## RC4 算法

RC4, Rivest Cipher 4, 是一种 [**流密码**](../stream-ciphers&prng.md) 算法, 由 Ron Rivest 设计. 简单高效, 但近年来发现一些安全漏洞. 其在速度上比较 AES 已不占优.

RC4 用一 S 表生成序列密钥, 主要步骤一是**密钥调度算法** (KSA), 使用初始密钥生成 S 表; 二是**伪随机数生成算法** (PRGA), 利用 S 表生成伪随机数序列.

### 1 密钥调度算法

KSA, Key Scheduling Algorithm, 使用初始密钥完成 S 表初始化. 

初始密钥长度应小于等于 256 字节, KSA 算法将其扩展为调度表 (S 表), S 表是 256 维向量, 分量长 1 字节. 实现过程如下:

0. 初始化两计数器 $i=0$, $j=0$
1. $S[i]=i,\ 0\leq i\lt 255$, 线性填充
2. $For\quad i\ = 0\ \to 255:$  
	$\quad j=j+S[i]+K[i\pmod{256}]\pmod{256}$, K 为字节串初始密钥.  
	$\quad Swap(\ S[i],\ S[j]\ )$

### 2 伪随机数生成算法

PRGA, Pseudo-Random Generation Algorithm, 生成和明文等长**字节密钥流**.

1. 初始化计数器 $i=0$, $j=0$
2. 如下生成随机字节:  
	- $i=i+1\pmod{256}$  
	- $j=j+S[i]\pmod{256}$  
	- $Swap(\ S[i],\ S[j]\ )$  
	- $t=S[i]+S[j]\pmod{256}$  
	- $Ks=S[t]$, 输出字节.

### 代码实现

```python
import sys
import io

class RC4:
	def __init__(self, key: bytes) -> None:
	    """
		Initialize the RC4 cipher.
		"""
		self.S = self.KSA(key) # throw key after using
		self.i = 0
		self.j = 0
	
	def KSA(self, key) -> list:
		"""
		Key Scheduling Algorithm
		"""
		key_length = len(key)
		S = list(range(256))
		j = 0
		for i in range(256):
		j = (j + S[i] + key[i % key_length]) % 256
		S[i], S[j] = S[j], S[i]
		return S
	
	def PRGA(self) -> int:
		"""
		Pseudo-Random Generation Algorithm (PRGA)
		:yield: Ks (1B)
		"""
		while True:
			i = (self.i + 1) % 256
			j = (self.j + self.S[i]) % 256
			self.S[i], self.S[j] = self.S[j], self.S[i]
			
			t = (self.S[i] + self.S[j]) % 256
			Ks = self.S[t]
			
			self.i, self.j = i, j
			yield Ks

	def encrypt(self, stream, chunk_size=64):
		prng = self.PRGA()
		buffer = bytearray()
		while True:
			data = stream.read(1)
			if not data:
				break
			buffer.append(data[0] ^ next(prng))
			if len(buffer) == chunk_size:
				yield buffer
				buffer.clear()
		if buffer:
			yield buffer


if __name__ == '__main__':
	key = b'...'
    rc4 = RC4(key)
    for line in sys.stdin:
	    input_stream = io.BytesIO(line.encode())
		for cihper in rc4.encrypt(input_stream):
			...
    
```
