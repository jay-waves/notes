#import "@local/ypst-template:0.1.0": template, sidenote

#show: template

#let bmat(..args) = $mat(delim: "[", ..args)$
#let vmat(..args) = $mat(delim: "|", ..args)$

== 调和级数
$ H = sum_(k = 1)^oo 1 / k . $

调和级数是发散的, 发散速度等价于 $ln(n)$.

$ H_n tilde.op ln n + gamma , quad n arrow.r oo $, 其中 $gamma$ 是欧拉 - 马歇罗尼常数.

=== 黎曼级数
Riemann Zeta Series

$ zeta(s) = sum_(n = 1)^oo 1 / n^s , quad s > 1 $

当 $s > 1$ 时级数收敛. 特殊值如 $zeta(2) = pi^2 / 6$

== 几何级数
#strong[几何级数]也叫等比级数.

$ S = a + a r + a r^2 + a r^3 + dots.c + a r^(n - 1) $

其中:

- $a$ 是首项;
- $r$ 是公比 (每一项与前一项的比值)
- $n$ 是项数;

当 $| r | < 1$ 时, 几何级数收敛, 求和公式为: $ S_n = a dot frac(1 - r^n, 1 - r) = frac(a, 1 - r) $

在数学中, 除了几何级数, 还有许多经典级数具有重要的理论和实际应用价值. 以下列出了几种经典级数及其重要性质:

== 幂级数
Power Series .

$ S(x) = sum_(n = 0)^oo a_n x^n = a_0 + a_1 x + a_2 x^2 + a_3 x^3 + dots.c $

- $a_n$ 是系数, 可能依赖于 $n$.
- $x$ 是变量.

+ #strong[收敛性]: 幂级数在某个区间内可能收敛. 以 $| x | < R$ 的形式定义收敛半径 $R$:

  $ R = frac(1, limsup_(n arrow.r oo) root(n, | a_n |)) . $

常见幂级数见 #link("https://notes.jay-waves.cn/math/calculus/taylor-series/")[泰勒级数].

如 对数函数: $ln(1 + x) = sum_(n = 1)^oo(- 1)^(n + 1) x^n / n , quad | x | < 1$

#line(length: 100%)

== 二项级数
Binomial Series,

$ ( 1 + x )^k = sum_(n = 0)^oo binom(k, n) x^n , quad | x | < 1 $

在 $| x | < 1$ 处收敛, 当 $k = n$ 时是二项式定理的展开形式.





