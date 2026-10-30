代换-置换网络 (SPN, substitution-permutation), 使用多次**迭代** (非幂等算法) 和**算法乘积**提高安全性. 和 Feistel 结构相比, SP 网络扩散更快, 但加解密结构区别较大.

**单轮流程**:
<img src="/attach/img/sec/substitution-permutation-structure.avif" alt="" width="300">

**多轮流程**:

加密: ($\oplus$ 为轮密钥加, 数据定义在 $GF(2^{8})$, 因此等价于二进制异或)  $$\oplus \to [S\to P \to \oplus]\to [S\to P\to \oplus]\to [S\to P \to \oplus]\to\dots$$

解密:  $$[\oplus \to P^{-1}\to S^{-1}] \to [\oplus\to P^{-1}\to S^{-1}]\to [\oplus\to P^{-1}\to S^{-1}]\to\dots$$

等效解密: (此处输入 $\oplus$ 的密钥应为 $P^{-1}(K)$) $$P^{-1}\to\oplus\to[S^{-1}\to P^{-1}\to \oplus]\to [S^{-1}\to P^{-1}\to \oplus]\to S^{-1}\to \dots$$ 

$P$ 是应为[有限域](../../../../math/algebra/域/有限域.md)上的线性变换, 满足加法同态性: $P(K\oplus X)=P(K)\oplus P(x)$, 其逆变换 $P^{-1}$ 同理. 

**等效解密的结构和加密结构更加类似.** 当然, 由于逆运算和原运算区别也较大, 结构相同不代表代码容易复用.

### 幂等密码体制

幂等密码 $S$, 指 $S^{2}=S$, 自己嵌套自己不能增加安全性. 如: 移位, 代换, 乘法, 仿射, 置换, 维吉尼亚, 希尔密码都是幂等的. 

通常用两不同幂等密码的乘积 $S_{1}\times S_{2}$ 来构造 *非幂等密码*, 但需保证两者不可交换. 参见[EDE](../feistel/EDE.md)
