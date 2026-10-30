#import "@local/ypst-template:0.1.0": template, theorem, proof

#show: template

= 代数基本定理

#theorem[
  $n$ 次多项式可被分解为 $bb(C)$ 上一次多项式的乘积:
  $
  P(x) = a_n (x - r_1) (x - r_2) dots.c (x - r_n)
  $
]

其中:
- $a_n$ 是最高次项的系数
- $r_i in bb(C)$ 是多项式的根, 可能重复.

= 其他多项式表示方法

== 系数法

$
P(x) = a_n x^n + a_(n - 1) x^(n - 1) + dots.c + a_1 x + a_0
$

== 点值法

$
(x_1, P(x_1)), (x_2, P(x_2)), dots.c, (x_m, P(x_m))
$

== 离散傅里叶变换形式

$
P(x) = sum_(k = 0)^(n - 1) a_k dot exp(2 pi i k x \/ n)
$

== 拉格朗日插值形式

见#link("https://notes.jay-waves.cn/math/numerical/interpolation-and-approximation/")[插值与多项式逼近].

$
P(x) = sum_(i = 1)^n P(x_i) product_(j != i) frac(x - x_j, x_i - x_j)
$

== 范德蒙矩阵形式

设有 $n$ 次多项式:
$
P(x) = a_0 + a_1 x + a_2 x^2 + dots.c + a_n x^n
$

对于点集 $(x_0, x_1, dots.c, x_n)$, 有多项式值集 $bold(b) = V_(n + 1) dot bold(a)$, 其中 $V$ 是#link("https://notes.jay-waves.cn/math/linalg/determinant/")[范德蒙行列式].

$
bold(b) = mat(delim: "(", P(x_0); P(x_1); dots.v; P(x_n))
$

系数向量为:
$
bold(a) = mat(delim: "(", a_0; a_1; dots.v; a_n)
$

如果 $x_1, x_2, dots.c, x_n$ 互不相同, 可知
$
|V| = product_(1 <= i < j <= n) (x_j - x_i) != 0
$
此时 $V$ 是可逆的, 可以唯一确定多项式系数 $bold(a) = V^(-1) bold(b)$.

= 不可约多项式

#theorem[
  upright("Eisenstein") 判别法: 对于有理数域 $bb(Q)$ 上的多项式
  $
  f(x) = a_n x^n + a_(n - 1) x^(n - 1) + dots.c + a_1 x + a_0,
  $
  如果存在素数 $p$, 满足:
  1. $p divides a_n$
  2. $p divides a_(n - 1), a_(n - 2), dots.c, a_1, a_0$
  3. $p^2$ 不整除 $a_0$

  那么 $f(x)$ 在有理数域 $bb(Q)$ 上不可约.
]

#proof[
  首先明确, 准则只是一个充分条件.

  ...
]

$upright("GF")(2)$ 上多项式:
$
P(x) = x^n - c_1 x^(n - 1) - c_2 x^(n - 2) - dots.c - c_(n - 1) x - c_n
$

其互反多项式为:
$
P^*(x) = x^n P(1 \/ x) = a_0 x^n + a_1 x^(n - 1) + dots.c + a_(n - 1) x + a_n
$
