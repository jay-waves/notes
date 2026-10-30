---
code:
  - src/cryptography/aes.py
  - src/cryptography/aes_constant.py
  - src/cryptography/aes_key.py
---

AES (Advanced Encryption Standard) 是 NIST 于2001年选定的, 用于替代 DES 的算法.

AES 以 **Rijndael 迭代型密码算法**为基础, 但**分组长度固定为 `128bits`**, 仅允许密钥长度可变 (`128bits`, `192bits`, `256bits`). 和 DES 以比特为处理单位不同, AES 处理单位是字节, 用 $GF(2^{8})$ 上元素表示.

<img src="../../../../attach/img/sec/crypto-aes.avif" alt="" width="250">

## AES 构造

**长度**:  
word, 字, 32`bits`   
state, 内部状态:
```
state={
	byte1, byte5, byte9,  byte13, // word1
	byte2, byte6, byte10, byte14,
	byte3, byte7, byte11, byte15,
	byte4, byte8, byte12, byte16
}
```

**常数**:  
`Nb`: 分组字长度, AES 中固定为 4, Rijndael 中可变.  
`Nk`: 密钥字长度, 可为 4/6/8. 随着密钥长度变化, 密钥扩展算法略有不同.  
`Nr`: 轮数, Rijndael 建议 10 以上. AES 标准中, 密钥字长度 4/6/8 对应轮数 10/12/14.

### 1 单轮结构

AES 是迭代型结构, 每轮结构如下:
```
Round{
	SubBytes( State ) // S盒变换
	ShiftRows( State ) // 行移位
	MixColumns( State ) // 列混淆
	AddRoundKey( State, RoundKey ) // 轮密钥加
}
```

#### 1.1 字节替换

见 [AES-SBox](AES-SBox.md)

#### 1.2 行移位 `ShiftRows`
线性变换
$$
State=
\begin{bmatrix}
B_{00} & B_{01} & B_{02} & B_{03} \\
B_{10} & B_{11} & B_{12} & B_{13} \\
B_{20} & B_{21} & B_{22} & B_{23} \\
B_{30} & B_{31} & B_{32} & B_{33}
\end{bmatrix}
\longrightarrow
\begin{bmatrix}
B_{00} & B_{01} & B_{02} & B_{03} \\
B_{11} & B_{12} & B_{13} & B_{10} \\
B_{22} & B_{23} & B_{20} & B_{21} \\
B_{33} & B_{30} & B_{31} & B_{32}
\end{bmatrix}
\begin{matrix}
 & \\
\Leftarrow &\text{ring shift left 1}\\
\Leftarrow &\text{ring shift left 2} \\
\Leftarrow & \text{ring shift left 3} 
\end{matrix}
$$

#### 1.3 列混淆 `MixColumns`
$$
\begin{bmatrix}
0x02 & 0x03 & 0x01 & 0x01 \\
0x01 & 0x02 & 0x03 & 0x01 \\
0x01 & 0x01 & 0x02 & 0x03 \\
0x03 & 0x01 & 0x01 & 0x02
\end{bmatrix}\cdot
State=State'
$$
注意, 运算定义在 $GF(2^8)$上.
对于逆运算:
$$
\begin{bmatrix}
0x02 & 0x03 & 0x01 & 0x01 \\
0x01 & 0x02 & 0x03 & 0x01 \\
0x01 & 0x01 & 0x02 & 0x03 \\
0x03 & 0x01 & 0x01 & 0x02
\end{bmatrix}^{-1}
=
\begin{bmatrix}
0x0E & 0x0B & 0x0D & 0x09 \\
0x09 & 0x0E & 0x0B & 0x0D \\
0x0D & 0x09 & 0x0E & 0x0B \\
0x0B & 0x0D & 0x09 & 0x0E
\end{bmatrix}
$$

<br>

另一种理解方式: 将状态列视为 ${} GF(2^{32})\simeq GF(2^{8})[x]/(x^{4}+1) {}$ 上的多项式 $c(x)$, 则结果 $c(x)=b(x)\cdot a(x)\pmod{x^{4}+1}$, $a(x)=03x^{3}+01x^{2}+01x+02$.

AES 以字节为单位处理数据, 即处理单位为 $GF(2^{8})[x]/(x^{8}+x^{4}+x^{3}+1)$ 上的多项式元素, 编码为一个二进制字节, 每一位代表 $GF(2)$ 上的一个系数. 

下面是 $GF(2^{32})$ 有限域上有系数多项式乘法的演示, ${} c_{i}\in GF(2^{8}) {}$: 

$c\left(x\right)\\=a(x)*b(x)\\=c_6x^6+c_5x^5+c_4x^4+c_3x^3+c_2x^2+c_1x+c_0$

$\begin{cases}c_0=a_0\ast b_0\\ c_6=a_3\ast b_3\\ c_1=a_1\ast b_0\oplus a_0\ast b_1\\c_5=a_3\ast b_2\oplus a_2\ast b_3\\c_2=a_2\ast b_0\oplus a_1\ast b_1\oplus a_0\ast b_2\\ c_4=a_3\ast b_1\oplus a_2\ast b_2\oplus a_1\ast b_3\\ c_3=a_3\ast b_0\oplus a_2\ast b_1\oplus a_1\ast b_2\oplus a_0\ast b_3\end{cases}$

因为 $x^{4}\equiv -1\equiv 1\pmod{x^{4}+1}$, 所以: 

$d\left(x\right)\\=c\left(x\right)\pmod{x^4+1}\\=c_3x^3+\left(c_6\oplus c_2\right)x^2+\left(c_5\oplus c_1\right)x+\left(c_4\oplus c_0\right)$

即, 对多项式: $p_1=a_0+a_1x+a_2x^2+a_3x^3$ 和 $p_2=b_0+b_1x+b_2x^2+b_3x^3$, 
若 $p_1\otimes p_2=c_0+c_1x+c_2x^2+c_3x^3$, 则有: $$\begin{bmatrix}
c_{0}\\c_{1}\\c_{2}\\c_{3}\end{bmatrix}=\begin{bmatrix}
a_{0}&a_{3}&a_{2}&a_{1}\\a_{1}&a_{0} & a_{3} & a_{2}\\a_{2} & a_{2} & a_{0} & a_{3}\\a_{3} & a_{2} & a_{1} & a_{0}\end{bmatrix}\cdot \begin{bmatrix}
b_{0}\\ b_{1}\\ b_{2} \\b_{3}\end{bmatrix}$$

> 注意, 列混淆是SP网络中的**代换 (S)** 操作. 但是作用是**扩散**

#### 1.4 轮密钥加 `AddRoundKey`

密钥填入顺序:
$$
InitKey=
\begin{bmatrix}
B_{0} & B_{4} & B_{8} & B_{12} \\
B_{1} & B_{5} & B_{9} & B_{13} \\
B_{2} & B_{6} & B_{10} & B_{14} \\
B_{3} & B_{7} & B_{11} & B_{15}
\end{bmatrix}
=
\begin{pmatrix}
w_{1} & w_{2} & w_{3} & w_{4}
\end{pmatrix}
$$

轮密钥加:
$$
State \oplus RoundKey_{i} = 
\begin{pmatrix}
sw_{1}\oplus kw_{1}, & sw_{2}\oplus kw_{2}, & sw_{3}\oplus kw_{3}, & sw_{4}\oplus kw_{4}
\end{pmatrix}
$$

### 2 Rijndael 整体结构

加密结构:
```
Rijndal( State, Key ){
	RoundKey <- KeyExpansion( Key );
	AddRoundKey( State, RoundKey[0] );
	For i from 1 to Nr-1:
		SubBytes( State );
		ShiftRow( State );
		MixColumn( State );
		AddRoundKey( State, RoundKey[i] );
	EndFor
	SubBytes( State );
	ShiftRow( State );
	AddRoundKey( State, RoundKey[r] );
}
```

解密结构:
```
Rijndal( State, Key ){
	RoundKey <- KeyExpansion( Key )
	AddRoundKey( State, RoundKey[r] )
	InvShiftRow( State )
	InvSubBytes( State )
	For i from 1 to Nr-1:
		AddRoundKey( State, RoundKey[r-i] )
		InvMixColumn( State )
		InvShiftRow( State )
		InvSubBytes( State )
	EndFor
	AddRoundKey( State, RoundKey[0] )
}
```

等效解密结构: **为了让加解密结构更加类似, AES 最后一轮没有 `MixColumns`.** 原理一见[代换置换网络](sp-network.md), 即 `MixColumn` 和 `AddRoundKey` 可在线性变换条件下互换位置; 二需理解 `SubBytes` 和 `ShiftRows` 结构可互换位置, 因为 `ShiftRows` 不改动字节内部值.

```
Rijndal( State, Key ){
	RoundKey <- KeyExpansion( Key )
	AddRoundKey( State, InvMixColumn(RouKey[r]))
	For i from 1 to Nr-1:
		InvSubBytes( State )
		InvShiftRow( State )
		InvMixColumn( State )
		AddPermutateRoundKey( State, RoundKey[r-i] )
	EndFor
	InvSubBytes( State )
	InvShiftRow( State )
	AddPermutateRoundKey( State, RoundKey[0] )
}
```

### 3 密钥扩展

`Nk=4` 时密钥扩展步骤如下, `Nk` 增长时, 会有些许变化, 详见 AES 标准. 每轮密钥长度皆为 $N_{b}$, 那么共需要 $N_{b}(N_{r}+1)$ 长度的密钥.

<img src="../../../../attach/img/sec/crypto-aes-key-extend.avif" alt="" width="550">

变换 $g$ 详情如:
1. 循环左移一字节
2. 用 [Sbox](AES-SBox.md) 进行字节替代
3. 与轮常数 `Rcon[i]` 异或.   
其中, $Rcon[i]=(RC[i], 0x00, 0x00, 0x00)$, $RC[i]=2^{i-1}$.

## AES 分析

Rijndael算法高性能, 高效率, 高伸缩性, 存储要求低. 缺点是加解密区别较大, 硬件重用较困难.  AES 雪崩效应比 DES 佳, 因此轮数也少, 10 轮AES安全性已非常高, 最有效破解方案是密钥穷举.

字节扩散效果:
<img src="../../../../attach/img/sec/crypto-aes-avalanche.avif" alt="" width="450">

比特扩散效果:  
...
