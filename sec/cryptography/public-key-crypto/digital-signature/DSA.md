## DSA 数字签名

DSA 数字签名算法, 是一种基于公钥密码的*带附录数字签名方式*. 用于 NIST 提出的美国国家标准 [DSS (Digital Signature Standard) 数字签名标准](https://csrc.nist.gov/pubs/fips/186-5/final), DSS 还包括 ECDSA 和 RSA.

DSA 算法是 Elgamal 签名的变种, 同样基于有限域上离散对数问题. 但它比 ElGamal 的效率更高, 签名更短. DSA 和 [ElGamal 签名](../el-gamal.md) 有一样的安全问题, 即随机数 k 不能重复使用.

DSA 安全性依赖于 $\mathbb{Z}_{p}$ 的 q 阶子群上的 DLP 问题. 这种*大群的小阶子群*的思想来源于 Schnorr.

### 密钥生成

1. 选取素数 $p$, 比特长 $512\sim 1024$
2. 选取素数 $q$, $q\vert p-1$, 比特长 $159\sim 160$ [^1]
3. 选取有限域 $\mathbb{GF}(p)$ 的 $q$ 阶子群的生成元 $g=h^{(p-1)/q}\pmod{p}$, $h\neq 0$, $h^{(p-1)/q}\neq 1\pmod{p}$ 
4. 选取随机数 $0<x<q$, 作为私钥
5. $(p, q, g)$ 为公钥

[^1]: 24 年推荐标准为 256 位

### 签名

$r=[g^{k} \pmod p] \pmod q$, $k$ 为随机数   
$s=[k^{-1}(Hash(M)+xr)]\pmod q$

### 验签

收到签名 $\{s, r\}$ 与原消息 $M$:

$m=Hash(M)$  
$u_{1}=[m*s^{-1}]\pmod q$  
$u_{2}=r*s^{-1}\pmod q$  
$v=[g^{u_{1}}*y^{u_{2}}\pmod p]\pmod q$

接下来验证 $v\equiv r$, 因为 $v=[g^{[m+xr]*s^{-1}}\pmod p]\pmod q$

### 随机数重用漏洞

DSA 中随机数 $k$ 不能使用常数. 否则攻击流程如下: 

设 $k$ 被用于两次不同消息 $M_{1},M_{2}$ 的签名:
$$\begin{array}{l l}{{s_{1}=k^{-1}(m_{1}+x r)}}&{\pmod q}\\ {{s_{2}=k^{-1}(m_{2}+x r)}}&{\pmod{q}}\end{array}$$

由于 $k$ 不变, $r$ 也是相同的, 这里不再列出. 将两式相减: $$k(s_{1}-s_{2})=m_{1}-m_{2}{\pmod{q}}$$

$$k={\frac{m_{1}-m_{2}}{s_{1}-s_{2}}}\pmod{q}$$

利用 $k$ 破译私钥 $x$: 

$$x={\frac{s_{1}k-m_{1}}{r}}\pmod{q}$$