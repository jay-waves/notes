---
code:
  - src/cryptography/des.py
  - src/cryptography/des_acceleration.py.md
  - src/cryptography/des_key.py
  - src/cryptography/des_table.py
---

DES, Data Encryption Standard, 是 1977 年颁布的美帝标准加密算法, 源于 IBM 的 Lucifer 算法.

### 1 整体结构

DES 共 16 轮迭代, 每轮有独立派生的子密钥. 输入 64 位明文, 输入 64 位密钥 (有效位数为 56 位), 输出 64 位密文. 

<img src="../../../../attach/img/sec/crypto-des-diagram.avif" alt="" width="350">

解密可复用整个加密结构, 同时逆序输入轮密钥. 为了对称性, 最后一轮的 Feistel 结构并不完整, $L,R$ 没有交换顺序.

### 2 密钥扩展

DES密钥长度虽然是56位, 但实现中DES加上了8位校验位, 共64位. `Permuted Choice 1` 在置换同时, 去掉了这8位校验位.

循环左移 `LCS` 操作的*移动比特数*遵循**轮次左移调度表** $\{1,1,2,2,2,2,2,2,1,2,2,2,2,2,2,1\}$, 16轮后正好左移 `28bits` 回到初态.

<img src="../../../../attach/img/sec/crypto-des-diagram2.avif" alt="" width="500">

PC-2 盒的置换, 也是分为左右 `28 bits` 进行压缩, 互不相干. 即左 `28 bits` 压缩为 前 `24 bits`, 后 `28bits` 压缩为后 `24 bits`.

DES 密钥扩展中仅有置换 `Permuted Choice` 和循环移位 `LCS`, 无非线性运算(如代换), 这导致其存在弱密钥. 例如全零/全一/间或零一, 都是典型弱密钥.

### 3 单轮结构

DES采用单轮 [Feistel 迭代结构](Feistel.md), 共16轮. 加密流程如下:

1. $L_{0}R_{0}\leftarrow IP(m)$
2. $For\ i=1\to 16:$  
	$\quad L_{i}\leftarrow R_{i-1}$  
	$\quad R_{i}\leftarrow L_{i-1}\oplus P(\ S[\ E(R_{i-1})\oplus rk_{i}\ ]\ )$
3. $IP^{-1}(R_{16}L_{16})$

<img src="../../../../attach/img/sec/crypto-des-1round.avif" alt="" width="350">

> 这个IP有什么用? 为了加解密结构相同还必须在末尾加上逆IP.

#### 3.1 ES变换

扩展盒作用如下, 两侧为新添位, 输出扩展为 48 位.
```
32 | 01 02 03 04 | 05
04 | 05 06 07 08 | 09
08 | 09 10 11 12 | 13
12 | 13 14 15 16 | 17
16 | 17 18 19 20 | 21
20 | 21 22 23 24 | 25
24 | 25 26 27 28 | 29
28 | 29 30 31 32 | 01
```

DES 有 8 个不同 S 盒, 每个 S 盒 `6bits` 输入, `4bits` 输出. 对于输入 $(b_{1}, b_{2}, b_{3}, b_{4},b_{5},b_{6})$, $b_{1}b_{6}$ 确定行, $b_{2}b_{3}b_{4}b_{5}$ 确定列, 得到 `4bits` 替换输出. DES 代换盒的设计标准未被公布, 但意外有良好的抗差分析攻击性质. 学者独立发现密码差分分析方法, 之后才曝光出早期 IBM 设计者已经知晓该法, 同期其他密码算法大都无法抵抗该攻击.

不难发现, $b_{1}b_{6}$ 就是 E 盒扩展的部分 (加上轮密钥), E 盒和 S 盒是关系密切的, 合并可省去程序比特切分和组合, [使 DES 加速](../../../../attach/src/crypto/des_acceleration.py.md).

> DES一大缺点是**按比特置换**, 这导致其软件编程麻烦; AES 则以字节为单位置换.

### 4 安全性

DES 结构很美很简洁, 但也降低了算法破译的难度.

#### 互补特性

对于输入 $m$, 记 $\overline{m}$ 为其补, 那么可以证明: (原理是 $\overline{A}\oplus \overline{B}=\overline{A\oplus B}$, 结合结构分析即可)

$$\mathrm{DES}_{\overline{k}}(\overline{m})=\overline{\mathrm{DES}_k(m)}$$

因此在穷举攻击时, 复杂度可以减少一半. 假设使用已知明文攻击的攻击者, 选取明密文对 $(M, C)$ 和 $(\overline{M}, C^{*})$, 那么其只需遍历 $2^{55}$  对互补的 $(k, \overline{k})$ 密钥对, 如果 $DES_{k}(M)=C$ 或 $DES_{k}(M)=\overline{C^{*}}$, 就可以破译出密钥.

#### 弱密钥与半弱密钥

DES 中一些密钥是很危险的, 原因是 DES 的子密钥派生算法仅是循环移位. 若使密钥的加密与解密循环移位结果相同, 就构成了弱密钥, 用其加密两次就变成明文; 如果循环移位过程只会产生两种不同的子密钥, 每一个使用8次, 就构成了半弱密钥.

弱密钥 $w$ 指: $$Enc_{w}(m)=Dec_{w}(m)$$

半弱密钥 $w_{1}, w_{2}$ 指: $$Enc_{w_{1}}(Enc_{w_{2}}(m))=m$$

56位密钥中, 共有4个弱密钥, 6对半弱密钥:
```c
// OpenSSL 中对弱密钥的检查
 static const DES_cblock weak_keys[NUM_WEAK_KEY]={
     /* weak keys */
     {0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01},
     {0xFE,0xFE,0xFE,0xFE,0xFE,0xFE,0xFE,0xFE},
     {0x1F,0x1F,0x1F,0x1F,0x0E,0x0E,0x0E,0x0E},
     {0xE0,0xE0,0xE0,0xE0,0xF1,0xF1,0xF1,0xF1},
     /* semi-weak keys */
     {0x01,0xFE,0x01,0xFE,0x01,0xFE,0x01,0xFE},
     {0xFE,0x01,0xFE,0x01,0xFE,0x01,0xFE,0x01},
     {0x1F,0xE0,0x1F,0xE0,0x0E,0xF1,0x0E,0xF1},
     {0xE0,0x1F,0xE0,0x1F,0xF1,0x0E,0xF1,0x0E},
     {0x01,0xE0,0x01,0xE0,0x01,0xF1,0x01,0xF1},
     {0xE0,0x01,0xE0,0x01,0xF1,0x01,0xF1,0x01},
     {0x1F,0xFE,0x1F,0xFE,0x0E,0xFE,0x0E,0xFE},
     {0xFE,0x1F,0xFE,0x1F,0xFE,0x0E,0xFE,0x0E},
     {0x01,0x1F,0x01,0x1F,0x01,0x0E,0x01,0x0E},
     {0x1F,0x01,0x1F,0x01,0x0E,0x01,0x0E,0x01},
     {0xE0,0xFE,0xE0,0xFE,0xF1,0xFE,0xF1,0xFE},
     {0xFE,0xE0,0xFE,0xE0,0xFE,0xF1,0xFE,0xF1}
  };
```
