## LFSR

常见 PRNG 驱动子系统为 Linear Feedback Shift Register. 换言之, LFSR 是同步序列密码常用乱源, 用递推关系产生**周期长, 线性复杂度高, 统计特性好**的乱数序列. LFSR 是构造流密码的基础, 它负责更新系统内部状态, 并输出中间结果交付 [PRNG 非线性部分](prng-nonlinear-components.md).

LFSR 由其反馈逻辑函数定义: $s_{n+1}=f(s_{1},\ s_{2},\ \dots,\ s_{n})=c_{1}s_{n}+c_{2}s_{n-1}+\dots+c_{n}s_{1}$, 递推式是布尔函数, 也是时序电路. 其中 $c_{i}\in GF(2)$, 加法定义为 "$\oplus$". LFSR 内部状态 $(s_{n},\ s_{n-1},\dots,s_{n-k})$ 在每个时钟移位迭代, 左侧接收 $s_{n+1}$, 右侧输出 $s_{n-k-1}$. 初始状态 $\mathrm{s}$ 可能由初始密钥决定.

<img src="/attach/img/sec/sec-crypto-lfsr-state-diagram.avif" alt="" width="450">

可使用列向量 $\mathbf{s}_{k}$ 来表示 LFSR 内部状态: 

$$\mathbf{s}_k = \begin{bmatrix} s_k \\ s_{k+1} \\ \vdots \\ s_{k+n-1} \end{bmatrix}$$

LFSR 的状态更新表示为: ${} \mathbf{s}_{k+1} = A\cdot\mathbf{s}_k {}$, 其中 $A$ 是状态转移矩阵, 定义为: $$A_{n} = \begin{bmatrix} 0 & 1 & 0 & \dots & 0 \\ 0 & 0 & 1 & \dots & 0 \\ \vdots & \vdots & \ddots & \ddots & \vdots \\ 0 & 0 & \dots & 0 & 1 \\ c_n & c_{n-1} & \dots & c_2 & c_1 \end{bmatrix}$$

其中 $c_1, c_2, \dots, c_n$ 是 LFSR 的反馈系数.

定义特征多项式为: $$P(x) = \det(xI - A)=\left|\begin{matrix} x & -1 & 0 & \dots & 0 \\ 0 & x & -1 & \dots & 0 \\ \vdots & \vdots & \ddots & \ddots & \vdots \\ 0 & 0 & \dots & x & -1 \\ -c_n & -c_{n-1} & \dots & -c_2 & x - c_1 \end{matrix}\right|$$

递归展开行列式: $$\det(xI-A)_{n}=x\cdot \det(xI-A)_{n-1}-(-1)^{n}\left| \begin{array}{ccc} -1 & 0 & \dots \\ \vdots & \ddots & \\ -c_n & \dots & x - c_1 \end{array} \right|$$

最终得到 $GF(2^{n})$ 上定义的特征多项式 (级联多项式) 如下, $n$ 代表了内部存在的状态数: $$P(x)=x^n - c_1 x^{n-1} - c_2 x^{n-2} - \dots - c_{n-1} x - c_n$$

例子:  
<img src="../../../attach/img/sec/lfsr-characteristic-polynomial-example.avif" alt="" width="500">

### 生成函数

将 $LFSR$ 的输出序列 $\{s_{i}\}$ 定义为幂级数形式的系数:

$$S(x)=s_{0}+s_{1}x+s_{2}x^{2}+s_{3}x^{3}+\dots$$


由 LFSR 的递推关系: $$s_{k+n} = c_1 s_{k+n-1} + c_2 s_{k+n-2} + \dots + c_n s_k$$

左右同乘 $x^{k}$, 然后求级数: $$\sum_{k=0}^{\infty}s_{k+n}x^{k}=c_{1}\sum_{k=0}^{\infty}s_{k+n-1}x^{k}+c_{2}\sum_{k=0}^{\infty}s_{k+n-2}x^{k}+\cdots+c_{n}\sum_{k=0}^{\infty}s_{k}x^{k}$$

左侧化简: $$L=\sum_{k=0}^\infty s_{k+n} x^{k} = x^{-n} \sum_{k=0}^\infty s_{k+n} x^{k+n} = x^{-n} \left( S(x) - s_0 - s_1 x - \dots - s_{n-1} x^{n-1} \right)$$

将初始状态设为: $$S_{0}(x) = s_0 + s_1 x + \dots + s_{n-1} x^{n-1}$$, 因此左侧化为: $$L=x^{-n} \left( S(x) - S_{0}(x) \right)$$

右侧每一项: $$R_{i}=c_{i}\sum_{k=0}^\infty s_{k+n-i} x^{k} = x^{-(n - i)} \left( S(x) - s_0 - s_1 x - \dots - s_{n - i -1} x^{n - i -1} \right)=c_{i}x^{-(n-i)}(S(x)-S_{0}(x))$$

所有含 $S(x)$ 项移到左边, 再同乘 $x^{n}$: $$\left( 1 - c_1 x - c_2 x^2 - \dots - c_n x^n \right) S(x) = S_{0}(x) - \left( c_1 x + c_2 x^2 + \dots + c_n x^n \right) S_{0}(x)$$

取 $P(x)$ 的互反多项式 (reciprocal polynomial): 
$$P^*(x) = x^n P\left(\frac{1}{x}\right) = 1-c_{1}x-c_{2}x^{2}-\dots-c_{n-1}x^{n-1}-c_{n}x^{n}$$

设 $R(x)=S_{0}(x) - \left( c_1 x + c_2 x^2 + \dots + c_n x^n \right) S_{0}(x)$, 等式化简为: $$P(x)^{*}\times S(x)=R(x)$$

两侧同乘 $x^{n}$, 得到: $$x^{n}S(x)=P(x)S(x)+x^{n}R(x)$$, 由于 $x^{n}S(x)$ 已经在 $P(x)S(x)$ 之中, 最终关系式是: $P(x)S(x)=R(x)$

<br>

**$P(x)$ 是 $GF(2^{n})$ 上的多项式, 其生成的循环群的阶构成了 LFSR 输出序列的周期 $T$. 如果 $P(x)$ 是 $GF(2^{n})$ 上的原初多项式, 那么其可以生成整个有限域 (除了零), 此时输出序列周期为: $T=2^{n}-1$, 被称为 m 序列. 即 $P(x)$ 可以生成一个 m 序列和一个全零序列.**

同一个 LFSR 序列可能有多个生成特征多项式 $f$, 其中次数最小的称为**极小多项式**.???

***

### A5 算法

> 参考 [A5 和 RC4 算法介绍](https://zhuanlan.zhihu.com/p/367447046)

A5 流密码算法由 **3 个 m 序列 LFSR 构成**, **级数分别为 19, 22, 23**. 其特征多项式分别为: 

- LFSR1: $g_1(x)=x^{19}+x^{18}+x^{17}+x^{14}+1$
- LFSR2: $g_2(x)=x^{22}+x^{21}+x^{17}+x^{13}+1$
- LFSR3: $g_3(x)=x^{23}+x^{22}+x^{19}+x^{18}+1$

..
