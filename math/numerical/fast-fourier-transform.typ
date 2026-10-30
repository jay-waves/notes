#import "@local/ypst-template:0.1.0": template, sidenote

#show: template

#let bmat(..args) = $mat(delim: "[", ..args)$
#let vmat(..args) = $mat(delim: "|", ..args)$

#quote(block: true)[
参考: #link("https://www.bilibili.com/video/BV1za411F76U/?vd_source=389ad1f24e143504d05c538916c8c532")[Introduction to FFT, Reducible]
]

= 快速傅里叶变换

FFT 是以 O(nlogn) 复杂度计算多项式乘积的算法. 此前算法复杂度为 O(n^2)

FFT 有四个关键思想: - 估值和插值相互转换. - 在对称点进行估值. - 估值点选为 1 的 $n^(t h)$ 根. - 插值运算和估值运算相似性.

=== 估值和插值相互转换
对于多项式 $A(x) = a_0 + a_1 x + dots.h + a_n x^n$, 可以将其表示为系数序列 $arrow(A) = [ a_0 , a_1 , a_2 , dots.h , a_n ]$; 也可以用 n+1 个 $A(x)$ 上的点表示: $hat(A) = [ med ( x_0 , A(x_0) ) , med ( x_1 , A(x_1) ) , med dots.h , med ( x_n , A(x_n) ) med ]$.

要计算 $A(x) = a_0 + a_1 x + dots.h + a_n x^n$ 和 $B(x) = b_0 + b_1 x + dots.h + b_n x^n$ 的乘积 $C(x) = A(x) dot B(x)$. 除了用 O(n^2) 时间计算 $arrow(A) dot arrow(B)^T$, 还可以以 O(n) 计算 $hat(A) dot hat(B)$.

该方法的瓶颈在于, 如何用 $arrow(A)$ 计算 $hat(A)$ (估值运算); 求出 $hat(A)$ 后, 如何用 $hat(A)$ 计算 $arrow(A)$ (#link("https://notes.jay-waves.cn/math/numerical/interpolation-and-approximation/")[插值]操作): $arrow(A) , arrow(B) arrow.r hat(A) , hat(B) arrow.r hat(C) arrow.r arrow(C)$

=== 对称点估值
不妨设 n 是 $2^k$.

如果 $P(x)$ 是偶函数, 估值 $P(x)$, 那么立刻有在 -x 点的估值: $P(- x) = P(x)$.

同理, 若 $P(x)$ 是奇函数, 立刻有 $P(- x) = - P(x)$.

对于任意多项式 $P(x)$, 可分为一偶一奇两多项式. 将奇多项式提出一个 x, 商也是一个偶多项式. 分别记为 $P_1$ 和 $P_2$: $ P(x) = P_1(x) + x dot P_2(x) $

立刻有: $ P(- x) = P_1(x) - x dot P_2(x) $

也就是说, 计算一遍 $P_1(x)$ 和 $P_2(x)$, 就能求出 $P(x)$ 和 $P(- x)$. #strong[只需要在 n/2 个点上求 $P_1$ 和 $P_2$, 就能得到 n 个 $P(x)$ 估值:] $P(x_1) , P(- x_1) , dots.h , P ( x_(n / 2) ) , P ( - x_(n / 2) )$

=== 估值点选为 1 的 n 次根
观察到, $P_1$ 和 $P_2$ 都可以视作自变量为 $x^2$ 的函数: ${ P_1(x^2) , med P_2(x^2) }$. 记为 ${ P_1(y) , med P_2(y) }$. $P(y)$ 次数相对于 $P(x)$ 减少了一半.

单看 $P_1(y)$, 是否可通过 $P_11(y)$ 和 $P_12(y)$ 一次性求出 $P_1(y)$ 和 $P_1(- y)$? 递归这个过程, 最终只需要在一个点求 $P'_1 , P'_2$ 的估值, 就能求出 n 个 $P(x)$ 的估值. 计算过程类似二叉树, 复杂度为 O(nlogn).

上述问题在于, $y = x^2$, 是否存在 $x_1^2 = - x_2^2$? 存在, #strong[在复数域: $i^2 = - ( 1 )^2$]. 为了满足递归需求, 需要平方 $log(n)$ 次后, 也满足此性质. 此时需要使用#strong[复数域单位圆周:] $e^(i theta) = cos(theta) + i sin(theta)$. $omega = e^(2 i pi / n)$ 代表复数域的 $2 pi / n$ 角.

$- x , x$ 等价于 $omega^j , omega^(j + n / 2)$. 估值自变量集通过递归FFT, 不断减小:$[ 1 , omega , omega^2 , dots.h , omega^(n - 1) ] arrow.r [ 1 , omega^2 , omega^4 , dots.h , omega^(2 ( n / 2 - 1 )) ] arrow.r [ 1 ]$

#strong[总结一下 FFT 流程:]

调用 FFT, 开始在 $[ omega^0 , omega^1 , omega^2 , dots.h , omega^(n - 1) ]$ 上求 $P(x)$ 的估值, 其中 $omega = e^(2 i pi / n)$. 变换 $P(x) = P_1(x) + x P_2(x)$.

对于 $[ omega^0 , omega^2 , omega^4 , dots.h , omega^(2 ( frac(n, 2 - 1 ))) ]$ 上的 $P_1$ 和 $P_2$, 分别记为: $y_1 = [ P_1(omega^0) , P_1(omega^2) , dots.h , P_1 ( omega^(n - 2) ) ]$ 和 $y_2 = [ P_2(omega^0) , P_2(omega^2) , dots.h , P_2 ( omega^(n - 2) ) ]$.

那么有: $ P(omega^j) = y_1 [ j ] + omega^j dot y_2 [ j ] $ $ P ( omega^(j + n / 2) ) = y_1 [ j ] - omega^j dot y_2 [ j ] $ $ j in { 0 , 1 , dots.h , ( n / 2 - 1 ) } $

通过 n/2 次计算, 求出: $ y = [ P(omega^0) , P(omega^1) , dots.h , P ( omega^(n - 1) ) ] $

同时, 在 $P_1$ 和 $P_2$ 上也递归调用 FFT, 结束条件定为 n=1, $omega$ 符号伴随运算即可, #strong[最后可约掉吗?]

=== 插值和估值的相似性
#strong[估值, Evaluation]

$ mat(delim: "[", P(omega^0); P(omega^1); P(omega^2); dots.v; P ( omega^(n - 1) )) = mat(delim: "[", 1, 1, 1, dots.c, 1; 1, omega^1, omega^2, dots.h, w^(n - 1); 1, omega^2, omega^4, dots.h, omega^(2 ( n - 1 )); dots.v, , , dots.down, dots.v; 1, omega^(n - 1), omega^(2 ( n - 1 )), dots.h, omega^(( n - 1 )(n - 1))) dot mat(delim: "[", p_0; p_1; p_2; dots.v; p_(n - 1)) $

FFT 使用 $omega = e^(frac(2 i pi, n))$

$ mat(delim: "[", 1, 1, 1, dots.c, 1; 1, omega^1, omega^2, dots.h, w^(n - 1); 1, omega^2, omega^4, dots.h, omega^(2 ( n - 1 )); dots.v, , , dots.down, dots.v; 1, omega^(n - 1), omega^(2 ( n - 1 )), dots.h, omega^(( n - 1 )(n - 1)))^(- 1) dot mat(delim: "[", P(omega^0); P(omega^1); P(omega^2); dots.v; P ( omega^(n - 1) )) = mat(delim: "[", p_0; p_1; p_2; dots.v; p_(n - 1)) $

#strong[插值, Interpolation]

$ mat(delim: "[", p_0; p_1; p_2; dots.v; p_(n - 1)) = 1 / n dot mat(delim: "[", 1, 1, 1, dots.c, 1; 1, omega^(- 1), omega^(- 2), dots.h, w^(- ( n - 1 )); 1, omega^(- 2), omega^(- 4), dots.h, omega^(- 2 ( n - 1 )); dots.v, , , dots.down, dots.v; 1, omega^(- ( n - 1 )), omega^(- 2 ( n - 1 )), dots.h, omega^(- ( n - 1 )(n - 1))) dot mat(delim: "[", P(omega^0); P(omega^1); P(omega^2); dots.v; P ( omega^(n - 1) )) $

IFFT 等价于 FFT 使用 $omega = 1 / n dot e^(frac(- 2 i pi, n))$

下面是#emph[伪代码]. ==不确定是否要真算e==

```python
def FFT(P):
    # P – [p_0, p_1, ..., p_{n-1}] coeff rep
    n = len(P) # n is power of 2 !!
    if n == 1:
        return P
    Omega = e^((2i*Pi)/n)
    Pe, Po = P[::2], P[1::2]
    ye, yo = FFT(Pe), FFT(Po)
    y = [0] * n
    for j in range(n/2):
        y[j] = ye[j] + Omega^j * yo[j]
        y[j+n/2] = ye[j] - Omega^j * yo[j]
    return y

def IFFT(P):
    # P – [P(w^0), P(w^1), ..., P(w^{n-1})] value rep
    n = len(P) # n is power of 2 !!
    if n == 1:
        return P
    Omega = (1/n) * e^((-2i*Pi)/n) # 仅此一行差异 !!
    Pe, Po = P[::2], P[1::2]
    ye, yo = IFFT(Pe), IFFT(Po)
    y = [0] * n
    for j in range(n/2):
        y[j] = ye[j] + Omega^j * yo[j]
        y[j+n/2] = ye[j] - Omega^j * yo[j]
    return y
```





