
## 椭圆曲线密码学 ECC

对于给定曲线, 选定曲线上基点 $G$. 基点 $G$ 是曲线点集群的某个子群的生成元, 当其阶 $n$ ($[n]G=\mathcal{O}$) 足够大时, 存在[**椭圆曲线群上的离散对数困难问题 (ECDLP)**](https://notes.jay-waves.cn/math/algebra/%E6%A4%AD%E5%9C%86%E6%9B%B2%E7%BA%BF/%E6%A4%AD%E5%9C%86%E6%9B%B2%E7%BA%BF/). ECC 是建立在 ECDLP 上的公钥密码体制. 换言之, 该公钥密码的单陷门函数为: $P=[d]G$, 给定公钥 $G,P$, 求出私钥 $d$ 是困难的.

### ECC 公钥加密

常见 ECC 加密算法为 [ECElGamal](ECElGamal.md), 基于 [ElGamal](../el-gamal.md), 两者同属于循环群上的离散对数困难问题.

### ECC 密钥交换

ECDH (Elliptic Curve Diffie-Hellman Protocol) 基于 ECC 实现的 [DH 密钥交换](../diffie-hellman.md)体系.  

公开信道获取 $[d_{B}]G$, 私钥 $d_{A}$, 获得共享密钥 $[d_{B}\ d_{A}]G$

### ECC 数字签名

[ECDSA](ECDSA.md)


### 与 RSA 对比

160/256 位的 ECC 安全性和 1024/2048 位的 RSA 安全性相当. 所以 ECC 计算量效率更高, 同时占用的存储空间和带宽较少.

ECC 缺点是相对较新, 应用和部署不如 RSA 广泛, 某些环境中 ECC 兼容性可能不佳;  
另外 ECC 计算和实现相对 RSA 复杂, 其具体性能依赖于实现方法. 

而 RSA 作为最早的公钥加密算法之一, 被广泛使用和研究, 使用范围更广泛.  
由于公钥加密算法更多用于密钥交换环节, 直接用于加密的比较少, 所以 RSA 比 ECC 消耗更多资源通常是可接受的.
