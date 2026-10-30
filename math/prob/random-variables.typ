#import "@local/ypst-template:0.1.0": template, sidenote

#show: template

#let bmat(..args) = $mat(delim: "[", ..args)$
#let vmat(..args) = $mat(delim: "|", ..args)$

随机试验的每个可能结果称为#strong[样本点] $omega$, 由一个样本点构成的事件称为#strong[基本事件]. #strong[样本空间,即基本事件空间]由全体样本点构成, 称为 $Omega = lr({omega})$. #strong[随机事件]由若干个样本点构成, 是 $Omega$ 的子集, 一定发生的事件称为#strong[必然事件], 称为 $Omega$; 不可能发生的事件称为#strong[不可能事件], 称为 $nothing$.

注意 $nothing$ 定义并不在 $Omega$ 内, 即不可能事件不在样本空间之内. 骰子样本空间为 $lr({1, 2, 3, 4, 5, 6})$, 事件 $7$ 就是不可能事件. 样本空间内的事件概率可能为 0, 不在样本空间内的事件概率一定为 0.

=== 概率的公理化定义
设随机试验的样本空间为 $Omega$, 如果对每个事件都有确定实数 $P(A)$, 且事件函数 $P(dot)$ 满足: 1. 非负性: $P(A) gt.eq 0$ 2. 规范性: $P(Omega) = 1$ 3. 可列可加性: 对于任意可列个两两不相容的事件 $A_1 , A_2 , dots.c , A_n , dots.c$, 有: $ P ( union.big_(i = 1) A_i ) = sum_(i = 1) P(A_i) $

则称 $P(dot)$ 为#strong[概率].

=== 事件之间关系
设事件 $A , B$, 有如下关系:

#table(
    columns: (16.88%, 37.66%, 45.45%),
    align: (auto,auto,auto,),
    table.header([名称], [记号], [解释],),
    table.hline(),
    [和 (并)], [$A + B$], [两事件至少有一个发生],
    [相容], [$A B eq.not nothing$], [两事件可能同时发生],
    [互斥 (不相容)], [$A B = nothing$], [两事件不可能同时发生],
    [包含], [$A subset B$], [事件 A 必然导致事件 B, 即 B 包含 A.],
    [相等], [$A subset B$, 且 $B subset A$], [],
    [交 (积)], [$A B$], [两事件同时发生],
    [差], [$A - B$], [事件 A 发生, 而事件 B 不发生],
    [逆 (对立)], [$overline(A)$], [事件 A 不发生],
  )

事件概率的#emph[常见运算]规则有:

$P(Omega) = 1 , P(nothing) = 0$.

上式反之不成立, 即 $P(A) = 0$ 时, A 不一定为 $nothing$; 比如连续实数区间上, 点是不可列的, 每个点概率 $P lr({X = a}) = 0$ 都是 0, 即连续样本空间内的任意一点测度皆为 0, 但其概率函数不一定为 0, 整个事件域上的概率和为 1, 所以并不是不可能事件.

$P(A) = 1 - P ( overline(A) )$

$P(A - B) = P(A) - P(A B) = P ( A overline(B) )$

$ P(A | B) = frac(P(A B), P(B)) $

$P(A_1 A_2 A_3 dots.c) = P(A_1) dot P(A_2 | A_1) dot P(A_3 | A_2 A_1) dots.c$

#link("https://notes.jay-waves.cn/math/prob/bayes/")[贝叶斯公式与全概率公式]

== 古典概型
样本空间满足: 1. 有限个样本点 2. 每个样本点的可能性一样

设事件 $A$ 包含 $k$ 个基本事件, 概率: $ P(A) = k / n $

== 几何概型
样本空间 $Omega$ 满足: 1. $Omega$ 是一个可度量的有界区域 $S$. 2. 每个样本点的可能性一样, 即样本点概率在 $S$ 上均匀分布.

概率形如: $ P(A) = S_A / S $

== 事件独立性
两个事件 $A , B$, 互相独立时满足: $ P(A B) = P(A) dot P(B) $

三个事件 $A , B , C$ 可能两两独立, 而不互相独立. 即可能 $P(A B) = P(A) dot P(B)$, 而不满足 $P(A B C) = P(A) dot P(B) dot P(C)$.

事件 $A , B$ 相互独立, 等价于 $A , overline(B)$ 相互独立, 等价于 $overline(A) , overline(B)$ 相互独立. 不可能事件和必然事件与任意事件独立. #strong[注意事件相独立与事件不相容是两个不同概念].

== 随机变量
随机试验 $E$ 的样本空间 $Omega = lr({omega})$, 对于每个基本事件 $omega$, 都有函数将其映射到实数上 $X(omega)$, 则称该函数为定义在 $Omega$ 上的随机变量 $X$.

对于随机变量 $X$, 其分布函数为 $F(x) = P lr({X lt.eq x}), x in bb(R)$, 记为 $X tilde.op F(x)$. 其定义的#emph[充要条件]为: 1. $F(x)$ 为单调不减函数 2. #strong[$F(x)$ 为右连续函数, 即 $lim_(x arrow.r x_0^(+)) = F(x_0 + 0) - F(x_0)$] 3. $F(- oo) = 0 , F(+ oo) = 1$

讨论 $F(x)$ 时, 习惯使用 $( a , b ]$ 区间. 考虑到如下情况: 1. 连续型概率分布 $F(x)$ 在 $x = b$ 处有跳跃间断点, $F(b) = F_(+)(b) eq.not F_(-)(b)$ 2. 离散型概率分布在 $x = b$ 处有概率分布 $p$, 此时直觉上 $F(b) - F_(-)(b) = p$

=== 离散型随机变量的概率分布
对于离散分布的 $x$ 值, 有: $ P lr({X = x_i}) = p_i, i = 1, 2, dots.h $

那么 $X$ 的分布函数为: $ F(x) = P lr({X lt.eq x}) = sum_(x_i lt.eq x) P lr({X = x_i}) $

=== 连续性随机变量的概率分布
设 $f(x)$ 为非负可积函数, 当 $X$ 为连续性随机变量时, 其分布函数可表示为 $ F(x) = integral_(- oo)^x f(t) d t , med x in bb(R) $

$f(x)$ 称为概率密度函数, 据可积定义, 其可以有有限个间断点.






