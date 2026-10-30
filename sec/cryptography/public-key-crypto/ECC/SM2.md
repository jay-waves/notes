
## SM2 公钥加密

注意 **SM2 和 ECC-Elgamal 的区别**:  

SM2生成 $C_{1}$, $C_{2}$, $C_{3}$三个密文:  
$C_{1}=[r]G$  
$C_{2}=M\oplus kdf(\ x \mid\mid y\ )$, $(x, y)=[r]Pk=[Sk][r]G$  
$C_{3}=hash(\ x\mid\mid M\mid\mid y\ )$, 用于验证

类似流密码, 加解密结构一致. 注意和 Elgamal 相比, SM2 不必将 M 类型转换为点, 也不限制其长度.

除此之外, SM2 还有较多类型转换的细节, 这里不再缀述.

<br>

## SM2 密钥协商


SM2 密钥协商基于 [ECDH](../diffie-hellman.md), 额外引入了随机数 $r$ 进行协商, 假设私钥 $d$, 公钥 $P$.

算法主要分为两部分, 第一部分计算共享椭圆曲线点U, 第二部分计算共享密钥$K$以及签名 $S_{1}$ 和 $S_{2}$.  流程图见 [SM2 流程图](../../../../attach/img/sec/sec-crypto-sm2-key-exchange-protocol.avif).

- 预计算: 用户标识和时变值等

用户标识包含*椭圆曲线参数*以及*身份标识 id* 的验证:  
$Z_{usr}=hash(id\_{len} \mid\mid id\mid\mid a\mid\mid b\mid\mid G\mid\mid P)$, 其中公钥$P=[d]G$, `id_len`占两字节

时变值  
$t = d+x'*r \pmod n$, 其中$n$为基点$G$的阶, x'是经过特殊处理后的$R$点$x$坐标

- 计算共享椭圆曲线点U/V:

$R_{B}=[r_{B}]G=(x_{2},\ y_{2})$  
$U=[h*t_{A}](P_{B}+[x_{2}']R_{B})=[h][d_{A}d_{B}+d_{A}r_{B}x_{2}'+d_{B}r_{A}x_{1}'+r_{A}r_{B}x_{1}'x_{2}']G$

$R_{A}=[r_{A}]G=(x_{1},\ y_{1})$  
$V=[h*t_{B}](P_{A}+[x_{1}']R_{A})=[h][d_{B}d_{A}+d_{B}r_{A}x_{1}'+d_{A}r_{B}x_{2}'+r_{A}r_{B}x_{1}'x_{2}']G=U$

- 计算共享密钥K, 签名$S_{1}, S_{2}$:

$K=kdf(\ U\mid\mid Z_{A}\mid\mid Z_{B}\ )$

$\_cat= y_{U}\mid\mid hash(\ x_{U}\mid\mid Z_{A}\mid\mid Z_{B}\mid\mid R_{A}\mid\mid R_{B}\ )$  
$S_{1}=hash(\ 0x02\mid\mid \_cat\ )$  
$S_{2}=hash(\ 0x03\mid\mid \_cat\ )$

其中$S_{1}$发送给Alice验证, $S_{2}$发送给Bob验证.

FAQ:
1. 为什么只生成一个$S_{1}$不行?

0x02开头的$S_{1}$那个是发送给Alice验证的, Bob证明了自己身份和密钥正确性. 0x03开头的$S_{2}$那个是发送给Bob验证的, Alice证明了自己身份和密钥正确性. 注意SM2基于DH, 本身还是不防御中间人攻击. 仍假设获取了对方真实公钥

2. 构建时是设计如何引入r的?

最初想法基于 [ECDH](ECC.md), 但复杂化私钥 $t=d+r$, 思路参考[ MTI 协议](../../security-protocols/认证的密钥协商协议/基于公钥的认证密钥协商.md).

临时私钥为 $t_{A}=d_{A}+r_{A}$  
公开 $R_{A}=[r_{A}]G$ 和 $P_{A}=[d_{A}]G$  
计算共享值 $[t_{A}](P_{B}+R_{B})=[d_{A}d_{B}+r_{A}d_{B}+d_{A}r_{B}+r_{A}r_{B}]G$

至于为什么后续又引入了$x'$, 猜测是为了使随机值r更隐蔽??

### SM2 公钥加密伪代码

```c++
Function Encrypt(m, klen, P):
	t <- 0;
	While t!= 0:
		r <- PRNG(1, n-1);
		c1 <- ECMul(k, G);
		(x2, y2) <- ECMul(k, P);
		t = KDF(x2 || y2, klen);
	c2 <- Xor(m, t);
	c3 <- Hash(x2 || M || y2);
	return c1 || c2 || c3

Function Decrypt(c, klen, d):
	(c1, c2, c3) <- c;
	If ! OnEC(c1) then:
		Error();
	
	(x2, y2) <- ECMul(d, c1);
	t = KDF(x2 || y2, klen);
	if t==0 then:
		Error();
	m <- Xor(c2, t);
	
	u <- Hash(x2 || M || y2);
	if u != c2 then:
		Error():
	return m
```

## SM2 数字签名
