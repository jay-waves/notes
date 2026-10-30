---
code: https://datatracker.ietf.org/doc/html/rfc2104
---

# HMAC
  
HMAC (Keyed-Hashing for MAC) 是一种基于杂凑算法的 MAC 实现方式, 定义于 [(RFC2104, 1997)](https://datatracker.ietf.org/doc/html/rfc2104) . 其设计目标为: 直接调用现有散列函数, 且镶嵌的散列函数可不断更新替换; 保留散列函数原始性能, 并以简单方式处理和使用密钥; 在对镶嵌散列函数合理假设的基础上, 易于分析 HMAC 用于认证时的密码强度. 基于不同杂凑算法, 有 `HMAC-MD5`, `HMAC-SHA1`, `HMAC-SHA256`

HMAC 在哈希函数的**完整性**安全需求之上, 通过共享密钥保证了**真实性**安全需求.

<br>

$$HMAC=Hash[\quad(K^{+}\oplus opad)\ \Vert\ Hash[\quad(K^{+}\oplus ipad)\ \Vert\ Msg\quad]\quad]$$

其中 
- Hash: 杂凑算法, 比如 (MD5, SHA-1, SHA-256)
- B: 块字节的长度, 取 B=64
- L: 杂凑算法结果字节长度 (L=16 for MD5, L=20 for SHA-1)
- K：共享密钥. 若 `len(k)>B`, 则先执行 `Hash(k)`; 若 `len(k)<B`, 则填充 `0x00` 至 B 长, 变为 $K^{+}$.
- Msg: 要认证的消息 
- opad：外部填充常量, 是 0x5C 重复 B 次
- ipad: 内部填充常量, 是 0x36 重复 B 次

```

		       +--------------------------------+
		       |    k  (padding if needed)      |
		       +--------------------------------+
		                     |
	    +--------------------+----------------------+
		|                                           |
		|      ipad                      opad       |
		|        |                         |        |
		|        V                         V        |
		+-----> XOR                       XOR <-----+
		         |        msg              |         
		         |         |               |
		         V         V               V
		   +-----------+-------+      +-----------+ 
		   |   inner   |  msg  |      |   outer   |
		   +-----------+-------+      +-----------+
		             |                     |   
		             V                     |
		            HASH                   |
		             |                     |
		             +----------+----------+
		                        |
		                        V
		                       HASH
		                        |
			                    V
		                       HMAC
```

*加速方式*: 预先计算 $f(IV, (K^{+}\oplus ipad))$ 和 $f(IV, (K^{+}\oplus opad))$ 两个值. 其中 $f(cv, block)$ 是散列函数的迭代压缩函数, 此二值视为新 $IV'$, 替代原哈希函数 $IV$. 该法缺点是增加了 HMAC 算法和哈希算法的耦合度. 该法也揭示出迭代型压缩函数的一些弱点, 见 [length-extension-attack](../merkel-damgard/length-extension-attack.md).

> opad 和 ipad 选择的原因见 [HMAC ipad and opad choice - Stack Exchange](https://crypto.stackexchange.com/questions/20695/hmac-ipad-and-opad-choice), 和 [What do the magic numbers 0x5c and 0x36 in HMAC do - Stack Exchange](https://crypto.stackexchange.com/questions/3005/what-do-the-magic-numbers-0x5c-and-0x36-in-the-opad-ipad-calc-in-hmac-do?rq=1).   
> 简单来讲, 需要从 $K^{+}$ 派生两个密钥, 且内层密钥 $K^{+}\oplus ipad$ 和外层密钥 $K^{+}\oplus opad$ 需相对独立. 雪崩效应要求对 n 长字符串, 雪崩后 [汉明距离](../../../../math/infoth/hamming-code.md) 为 $\frac{n}{2}$, opad 和 ipad 汉明距离为 4 保证了内外层 hash 使用的密钥有所区别. 如果汉明距离为 8, 那么 $opad\approx \neg ipad$, 两者联系相反更强.

### HMAC 安全性

HMAC 算法的强度和嵌入的散列函数的强度之间的确切关系, 已证明*对 HMAC 的攻击*等价于对内嵌散列函数的下述两种攻击之一:  
1. 攻击者能够计算压缩函数的一个输出, 即使 IV 是随机/秘密的。
2. 攻击者能够找出散列函数的碰撞, 即使 IV 是随机/秘密的

#### Q1 HMAC-MD5 安全吗?

安全. 对比 [birthday-attack](../birthday-attack.md), HMAC 使用 MD5 时, 其 $IV$, 实际上变为了 $f(K^{+}\oplus opad, IV)$, 这导致敌手无法离线构造 HMAC, 而必须在信道截获真实 HMAC. 这样做效率极低, 且容易被发现 (导致密钥更换).

#### Q2 HMAC 为什么需要使用两次 hash 函数?

这个问题等价于: **[为什么 $Hash(k\ \Vert\ x)$ 不是一个安全的MAC构造?](https://crypto.stackexchange.com/questions/1070/why-is-hk-mathbin-vert-x-not-a-secure-mac-construction)** 准确来说, 使用基于迭代结构的 $Hash$ 函数 构造的 $MAC=Hash(k\ \Vert\ x)$ 不是安全的. 存在一种 [*长度延长*攻击](../merkel-damgard/length-extension-attack.md), 使得敌手在不知道共享密钥的情况下, 可以得到 $Hash(k\ \Vert\ x\ \Vert\ pad_{x}\Vert\ x')$.

而使用 HMAC 的嵌套结构, 可以....

> 基于 [Keccak结构的SHA-3杂凑算法](KMAC.md), 没有 [*长度可延长*弱点](../merkel-damgard/length-extension-attack.md), 所以构造 MAC 时只需一次杂凑. 

#### Q3 为什么 HMAC 比 $Hash(k_{1}\Vert m\Vert k_{2})$ 更安全?

$Hash(k_{1}\Vert m\Vert k_{2})$ 在 $m$ 未填充时, 弱于 HMAC.  
$m$ 正常填充时, 安全性和 HMAC 类似, 都防御前后的 [length-extension-attack](../merkel-damgard/length-extension-attack.md)

> [How is $HMAC(m,k)$ more secure than $Hash(k1+m+k2)$? - Stack Exchange](https://crypto.stackexchange.com/questions/15131/how-is-hmacmessage-key-more-secure-than-hashkey1messagekey2?noredirect=1&lq=1)

### HMAC 的应用

HMAC 用于用户身份验证:

1. 客户端发出登录请求 (比如浏览器 GET 请求) 
2. 服务器返回一个随机值 $r$ ，并在会话中记录 $r$ 
3. 客户端使用 $r$ 和 *用户密码*, 计算 $HMAC_{user}$, 提交给服务器
4. 服务器从数据库读取 *用户密码* 和 $r$, 计算 $HMAC_{server}$. 
5. 比对 $HMAC_{server}\equiv HMAC_{user}$, 若结果一致则用户合法.

敌手截获*随机值*与*用户发送 hmac*结果, 无法获得用户密码. 引入随机值, 仅在当前会话有效, 避免*重放*攻击.
