## Merkle-Damgard 结构

迭代型散列函数, 也称为 Merkle-Damgard 结构.

<img src="../../../../attach/img/sec/sec-crypto-iterated-hash-function.avif" alt="" width="550">

### 预处理


$y=x\mid\mid pad(x)=y_{1}\mid\mid y_{2}\mid\mid\dots\mid\mid y_{r}$

1. 填充: $pad(x)$, 填充值一般是若干 `0`, 然后附加*消息 x 长度*
2. 分组: $\mid y_{i}\mid =n$

### 迭代

初始向量$H_{0}=IV$, 重复使用压缩函数 $f$,   
计算 $H_{i}=f(H_{i-1}\mid\mid y_{i})$

Merkle 和 Damgard 证明如果压缩函数 $f$ 是无碰撞的, 则 $hash$ 也是无碰撞的.  但 $f$ 是**压缩**的, 根据鸽巢原理, 一定存在碰撞. 因此变通为: **找出 $f$ 的碰撞在计算上是不可行的**

### 输出变换

公开函数 $g: {0,1}^{m}\rightarrow{0,1}^{n}$, 令 $hash(x)=g(H_{r})$

输出变换, 标志着迭代结束, 可防御 [length-extension-attack](length-extension-attack.md).

## 压缩函数$f$

典型设计方法有:  
...

## HAIFA 结构

是对 Merkel-Damgard 构造的改进, 用于 BLAKE 系列算法中.

## HAVAL 结构
