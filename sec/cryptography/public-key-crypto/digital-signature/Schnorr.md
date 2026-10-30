## Schnorr 数字签名

Schnorr 也是基于离散对数困难问题设计的, 其首先提出了 $g^{k}\pmod p$ 可以预计算 (即随机数提前选取计算). 是一种*带附录签名方式*

Schnorr 签名选择了模 $\varphi(p)=p-1$ 的一个循环子群 $\mathbb{Z}_{q}$ 进行计算, 从而减少计算量和签名长度, 速度比 ElGamal 更快, 但相应安全性更低. 

此外, Schnorr 算法没有 [ElGamal 签名](../el-gamal.md)长度膨胀两倍的缺点.

### 密钥生成

1. 选素数 $p, q$, 使得 $q$ 是 $p-1$ 的素因子.
2. 选择整数 $g$, 使得 $g^{q}=1\pmod p$, 即 $o(g)= q$
3. 选择随机数 $x$, 计算 $y=g^{-x}\pmod p$

公钥为 $\{y,\ g,\ p,\ q\}$, 私钥为 $\{x\}$

### 签名

1. 选随机数 $k$, 计算 $r=g^{k}\pmod p$
2. $e=Hash(m\ \Vert\ r)$, m 为待加密消息. 添加后置 $r$ 可以防止 [length-extension-attack](../../msg-digests/merkel-damgard/length-extension-attack.md).
3. $s=k+xe\pmod q$

签名为 $(e,\ s)$

### 验签

1. 计算 $r'=g^{s}y^{e}\pmod p$
2. 验证 $Hash(m\ \Vert\ r')\equiv e$

其中 $r'\equiv g^{s}y^{e}\equiv g^{k+xe-xe}\equiv g^{k}\pmod p$

> 验签过程中, ElGamal 体制验证的是能否复原 m,  
> Schnorr 体制验证的则是能否复原 r
