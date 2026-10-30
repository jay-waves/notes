---
code:
  - src/cryptography/gf.py
  - src/cryptography/rsa_classic.py
revised: 24-12-17
---

## RSA 密码体系

RSA, Rivest-Shamir-Adleman 公钥体系基于大数分解的 NPC 困难问题 (FAC), 被广泛部署使用

### 加解密

构造原理为:

对于大数 $N=p\times q$, 其中 $p,q$ 为素数, 存在 $gcd(e,\ \phi(N))=1$, $d\equiv e^{-1}\pmod{\phi(N)}$,   

那么 $x^{e}\equiv c \pmod{N}$ 有解 $$x\equiv x\cdot 1^{h}\equiv x\cdot (x^{\phi(N)})^{h}\equiv x^{1+h\cdot \phi(N)}\equiv x^{d\cdot e}\equiv c^{d}\pmod{N}$$

0. [密钥生成](RSA-key-gen.md)
1. 加密算法: $C=M^{e}\pmod n$, 其中 $(e,n)$ 为公钥
2. 解密算法: $M=C^{d}\pmod n$, 其中 $d$ 为私钥

#### 利用 $p,q$ 加速解密

RSA 比 DES 吞吐量慢 100 倍以上, 一般不用于直接加密数据, 而用于安全传输密钥.

利用已知 $p$ 和 $q$ 加速算法解密速度. 一般 RSA 的私钥 $d$ 比公钥 $e$ 大很多, 所以解密成本更高.  

优化步骤:

1. 利用 $N=p\times q$, 将 $m \equiv c^{d}\pmod{N}$ 化为方程组, 并用费马定理化简指数:

$$\begin{align}
c^{d}\pmod{N} &\iff  \begin{cases}V_{p}\equiv c^{d}\pmod{p}\\ \\ V_{q}\equiv c^{d}\pmod{q}\end{cases} \\ \\
 &\iff \begin{cases}V_{p}\equiv (c\ \bmod p )^{d \pmod{p-1}}\pmod{p}\\ \\ V_{q}\equiv (c \bmod q)^{d\pmod{q-1}}\pmod{q}\end{cases}
\end{align}$$

2. 利用[中国剩余定理](../../../../math/numth/中国剩余定理.md)计算上述方程组

定义: 

$$\begin{align}
X_{p} & =q*(q^{-1}\pmod p) \\
X_{q} & =p*(p^{-1}\pmod q)
\end{align}$$ 

由中国剩余定理, 得到同余解为: $$m=V_{p}X_{p}+V_{q}X_{q}\pmod n$$

显然, $d\pmod{p-1}$ 和 $X_p$ 等都可以预先计算, 用于加速. 上述方法以牺牲安全性为代价.

### 数字签名

见 [RSA 签名](RSA-sig.md)

**公钥加密, 私钥解密, 私钥签名, 公钥验签**

### 安全性分析

2010 年, RSA 建议的安全参数 $N$ 位数为 `1024b`, 大素数 $p,q$ 位数应接近 `512b`. 2020 年, RSA 建议的安全参数升至 `2048b`.

RSA 问题基于以下的安全性保证:
- 知晓模数 ${} N=pq {}$, 难以求解其欧拉函数 $\varphi(N)$, 难以求出其分解 $p,q$[^2]. 即大整数素数分解难题.
- 知晓密文 $C=M^{d}$, 难以直接开方得 $M$, 也难以求其私钥 $d$. 即[离散对数困难性难题](../../../../math/numth/欧拉定理.md).

#### 参数选择弱点

RSA 的各个参数 $p,q,N,e,d$ 选择皆有安全性要求, 详见 [RSA 密钥生成](RSA-key-gen.md).

#### 选择密文攻击

教科书式 RSA 不安全, 对 CPA 和 CCA 都不安全, 其数学性质易被利用, 见 [选择密文攻击 (CCA)](RSA-weakness/RSA%20CCA%20Attack.md).

#### 侧信道攻击

RSA 时序攻击 [^1] 利用电路中比特 `1` 处理时间比 `0` 长的特点 (如快速幂算法), 可快速推测出密钥 $d$. 

### RSA 实践

详见 [PKCS#1](PKCS1.md).

[^1]: Remote Timing Attacks are Practical -- Dan Boneh, David Brumley.
