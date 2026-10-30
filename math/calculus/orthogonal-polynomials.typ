#import "@local/ypst-template:0.1.0": template, sidenote

#show: template

#let bmat(..args) = $mat(delim: "[", ..args)$
#let vmat(..args) = $mat(delim: "|", ..args)$

== 正交多项式
正交函数系 $lr({phi_0(x), phi_1(x), dots.h, phi_n(x)})$, 满足: $ ( phi_i , phi_j ) = integral_a^b phi_i(x) phi_j(x) d x = cases(delim: "{", 0 , quad & j eq.not j, a_i > 0 , quad & i = j) $

如果 $phi_k(x)$ 是 $k$ 次多项式, 则称 $lr({phi_i(x)})$ 为正交多项系.

对 $f , g in C [ a , b ]$ , $( f , g ) = integral_a^b rho(x) f(x) g(x) thin d x$ 是一种#link("https://notes.jay-waves.cn/math/linalg/vectors/inner-product/")[内积关系]. 其中 $rho(x)$ 是权函数, 大概性质是: 非负, 可积, 没有连续零点.

=== 性质
正交多项式系 $lr({phi_i(x)})$ 是线性无关的函数系.

正交多项式系是一个次数依次递增的多项式系.

#strong[$phi_i(x)$ 对应的首一多项式是唯一的].

=== 定理
#strong[定理: 多项式系 ${ phi_0(x) , phi_1(x) , dots.h , phi_k(x) }$ 是正交多项式系 ($ phi_i(x) $ 是 $i$ 次多项式), 充要条件为, 对任何次数不高于 $k - 1$ 的多项式 $q(x)$, 总有:] $ integral_a^b q(x) phi_k(x) d x = 0 $

=== 三项递推公式
对于任意一族首一正交多项式系 ${ phi_i(x) }$:

$ phi_(n + 1)(x) = ( x - alpha_n ) phi_n(x) - beta_n phi_(n - 1)(x) $

#strong[证明:]

将 $x phi_n(x)$ 在 $lr({phi_0(x), phi_1(x), dots.h, phi_n(x), phi_(n + 1)(x)})$ 基下展开: $ x phi_n(x) = sum_(i = n - 1)^(n + 1) c_i phi_i(x) , quad c_(n + 1) = 1 $

两边与 $phi_k(x)$ 取内积, 由于正交性: $ chevron.l x phi_n , phi_k chevron.r = c_k chevron.l phi_k , phi_k chevron.r $

取 $k = n$ 得到: $ a_n = c_n = frac((x phi_n, phi_n), (phi_n, phi_n)) $

取 $k = n - 1$ 得到 $ 0 = chevron.l x phi_n , phi_(n - 1) chevron.r - beta_n chevron.l phi_(n - 1) , phi_(n - 1) chevron.r $

由内积的对称性: $ chevron.l x phi_n , phi_(n - 1) chevron.r = chevron.l phi_n , x phi_(n - 1) chevron.r = chevron.l phi_n , phi_n + alpha_(n - 1) phi_(n - 1) + beta_(n - 1) phi_(n - 2) chevron.r = chevron.l phi_n , phi_n chevron.r $

带入得到 $ beta_n = frac((phi_n, phi_n), (phi_(n - 1), phi_(n - 1))) $

$square.filled.medium$

== Legendre 多项式
$ {L_0(x) equiv 1\
L_n(x) = frac(1, 2^n n !) dot frac(d^n, d x^n) [ ( x^2 - 1 )^n ] quad (n = 1 , 2 , dots.h) $

勒让德多项式系 $lr({L_n(x)})$ 是区间 $[ - 1 , 1 ]$ 上的正交多项式系.

== Hermite 多项式
$ H_n(x) = ( - 1 )^n e^(x^2) frac(d^n ( e^(- x^2) ), d x^n) $

$H_n(x)$ 是 $n$ 次多项式, 最高次项系数为 $a_n = 2^n$. Hermite 多项式系是 $( - oo , oo )$ 上带权 $e^(- x^2)$ 的正交多项式系.

$ integral_(- oo)^oo e^(- x^2) H_m(x) H_n(x) thin d x = cases(delim: "{", 0 , & m eq.not n, 2^n n ! sqrt(pi) , & m = n) $

== Chebyshev 多项式





