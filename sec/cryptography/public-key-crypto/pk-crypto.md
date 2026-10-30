## 单向陷门函数

**单向陷门函数 $f$ 满足条件**:  
1. 计算 ${} \forall x,\quad y=f(x) {}$ 容易
2. 给定 $y$, 计算 ${} x=f^{-1}(y)$, 是计算上不可行的.
3. 存在 $\delta$, 若 $\delta$ 已知, 则计算第 $2$ 条件是容易的.

满足第 $1$ 和第 $2$ 条件, 称为**单向函数**.

第 $3$ 条件称为**陷门性**, $\delta$ 称为*陷门信息*

## 公钥密码体制

公钥密码特征为:
- 生成密钥对的算法较容易
- 用公钥加密明文的算法较容易
- 用密钥解密密文的算法较容易
- 由公钥很难得到对应私钥
- 由密文和公钥很难得到对应的明文
- 公钥私钥可交换, 即 $K\cdot K^{-1}=K^{-1}\cdot K$

满足上述要求, 实质就找到了一个**单陷门函数** $f: X\to Y$. 

**公钥密码体制基于数学困难问题, 但其难度不难于基于的数学问题, 两者困难性不等价**. 攻击者利用密码体制的设计弱点, 而不是攻击数学问题本身, 也能够成功攻击公钥密码体制. 因此, 如 [DiffieHellman 协议问题](diffie-hellman.md)的困难性弱于[离散对数问题](../../../math/numth/欧拉定理.md); 换言之, DiffieHellman 问题可[归约](../../../math/tcs/reduction.md)到 DLP 问题 ($DH\leq DLP$)

## 公钥密码算法

- [DH](./diffie-hellman.md), 基于有限域离散对数困难问题.
- [RSA](./rsa/RSA.md), 基于大整数分解困难问题.
- [ElGamal](./el-gamal.md), 基于有限域离散对数困难问题.
- [ECC](./ecc/ECC.md), 基于椭圆曲线上有限域离散对数困难问题.
- Lattice

## DLP 公钥密码性能优化

基于有限域离散对数困难问题的公钥算法, 其加解密操作中**最耗时**的基础操作为:
- 模乘 $a\times b \pmod{n}$. 取决于 $n$ 的二进制位数, 复杂度为 $\mathcal{O}(n^{2})$.
- 模幂 $a^{b}\pmod{n}$, 取决于模乘.
- 模逆 $a^{-1}\pmod{n}$, 用[扩展欧几里得算法](../../../math/numth/欧几里得算法.md), 复杂度为 $\mathcal{O}(n^{2})$

优化方法:
1. 大整数乘法 FFT, Karatsuba, 蒙哥马利乘 算法, 模乘复杂度降至 $\mathcal{O}(n\log n)$.
3. 巴雷特约减 (Barret Reduction)
4. 模幂运算: [快速模幂算法](../../../math/numth/快速模幂算法.md), [非邻接形式整数 NAF 快速幂算法](../../../math/numth/非邻接形式整数.md)

> 可参考: [Elliptic curve point multiplication - Wikipedia](https://en.wikipedia.org/wiki/Elliptic_curve_point_multiplication#Point_doubling) 
