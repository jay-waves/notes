#import "@local/ypst-template:0.1.0": template, sidenote

#show: template

#let bmat(..args) = $mat(delim: "[", ..args)$
#let vmat(..args) = $mat(delim: "|", ..args)$

= 数值积分

数值积分求积公式的一般形式为: $ integral_a^b f(x) upright(d) x approx sum_(k = 0)^n lambda_k f(x_k) $

求积节点 $x_i$ 满足: $a lt.eq x_0 < x_1 < dots.h < x_n lt.eq b$.

求积公式的截断误差为: $ R_n = integral_a^b f(x) upright(d) x - sum_(k = 0)^n lambda_k f(x_k) $

#strong[定义]: 当 $f(x)$ 为#strong[任何]次数不高于 $m$ 的多项式时, 求积公式 $R_n = 0$; 而当 $f(x)$ 为 $m + 1$ 次多项式时, $R_n eq.not 0$, 则称该数值积分公式具有 $m$ 次代数精度.

对于一个 $n$ 点求积公式, 含有 $n$ 个节点 $x_i$ 和 $n$ 个权 $A_i$, 共计 $2 n$ 个未知数. 要求它对多项式 $lr({1, x, x^2, dots.h, x^m})$ 都精准, 至少要满足 $m + 1$ 个独立方程. 也就是说, 至少 $m + 1 > 2 n$, 这限制了求积公式的最高代数精度.

== 插值型求积公式
用 #link("https://notes.jay-waves.cn/math/numerical/interpolation-and-approximation/")[Lagrange 插值系数]构造积分系数: $ lambda_k^(( n )) = integral_a^b L_k(x) upright(d) x = integral_a^b product_(i = 0 , i eq.not k)^n frac(x - x_i, x_k - x_i) upright(d) x $

此时, 原积分可表示为数值形式: $ integral_a^b f(x) thin d x approx integral_a^b sum_(i = 0)^n f(x_i) dot L_i(x) thin d x = sum_(i = 0)^n f(x_i) integral_a^b L_i(x) thin d x $

截断误差为: $ R_n = integral_a^b frac(f^(( n + 1 )) ( xi ), ( n + 1 ) !) product_(j = 0)^n(x - x_j) upright(d) x $, 其中, $xi = xi(x) in(a , b)$

=== Newton-Cotes 求积公式
令 $x = a + t h , thin h = frac(b - a, n)$, 此时由插值型积分公式, 有系数:

$ lambda_k^((n)) &= integral_a^b l_k(x) dif x = integral_a^b product_(j = 0)^n frac(x - x_j, x_k - x_j) dif x \ &= integral_0^n product_(j = 0)^n frac(t - j, k - j) h dif t \ &= frac((-1)^(n - k) h, k! (n - k)!) integral_0^n product_(j = 0, j eq.not k)^n(t - j) dif t = (b - a) c_k^((n)) quad (k = 0, 1, dots.h, n) $

$c_k^(( n ))$ 称为 Cotes 系数, 和被积函数 $f(x)$, 区间 $[ a , b ]$ 均无关. 可以直接查表.

记 Newton-Cotes 求积公式为: $ integral_a^b f(x) thin d x approx sum_(k = 0)^n lambda_k^(( n )) f (a + k thin frac(b - a, n)) $

其中, 截断误差为: $ R_n = integral_a^b frac(f^((n + 1))(xi), (n + 1)!) product_(j = 0)^n(x - x_j) dif x = frac(h^(n + 2), (n + 1)!) integral_0^n f^((n + 1))(xi) product_(j = 0)^n(t - j) dif x $

其中, $xi = xi(a + t h) in(a , b)$.

#strong[定理: 对任意 $n$, Newton-Cotes 求积公式具有数值稳定性的条件为:]

$ sum_(k = 0)^n | lambda_k^(( n )) | lt.eq K $

#strong[定理: 对于 $n$ 个求积节点的 New-Cotes 求积公式, 其代数精度为 $n - 1$]

=== 梯形积分 (n=1)
$ integral_a^b f(x) d x approx frac(b - a, 2) [f(a) + f(b)] $

误差项:

$ R_1 = - frac(( b - a )^3, 12) f''(eta) , quad eta in(a , b) $

=== Simpson 积分 (n=2)
$ integral_a^b f(x) thin d x approx frac(b - a, 6) thin [ f(x) + 4 f ( frac(alpha + b, 2) ) + f(b) ] $

$ R_2 = - frac((b - a)^5, 2880) f^((4))(eta), eta in(a, b) $

=== 3/8 Simpson 积分 (n=3)
$ integral_a^b f(x) thin d x approx frac(b - a, 8) [ f(a) + 3 f ( frac(2 a + b, 3) ) + 3 f ( frac(a + 2 b, 3) ) + f(b) ] $

$ R_3 = - frac(( b - a )^5, 6480) f^(( 4 )) ( eta ) , eta in(a , b) $

=== 复化梯形积分
将区间分为多个小区间, 每个小区间独立使用 New-Cotes 求积. #strong[这样能保证结果数值收敛.]

设 $[ a , b ]$ 区间内存在 $n + 1$ 个均匀分布的节点:

$ x_k = a + k h = a + k dot frac(b - a, n) ; quad k = 0 , 1 , dots.c , n $

以#emph[梯形复化求积公式]为例, 假设 $f(x)$ 在区间上二阶连续可导:

$ integral_a^b f(x) d x approx h / 2 [ f(a) + f(b) + 2 sum_(k = 1)^(n - 1) f(a + k h) ] $

复化梯形积分满足 $sum^n | lambda_k^(( n )) | = b - a$, 具有数值稳定性.

== Gauss 型积分公式
定义高斯求积: $ Q(f) = sum_(i = 0)^n A_i f(x_i) , quad A_i = integral_a^b rho(x) L_i(x) thin d x $ 其中 $x_i$ 是 $n$ 次正交多项式 $phi(x)$ 的互异实根. $L_i$ 是以 $x_i$ 为节点的拉格朗日基函数.

注意, $phi(x)$ 是定义在关于权函数 $rho(x)$ 的#link("https://notes.jay-waves.cn/math/calculus/orthogonal-polynomials/")[正交多项式系]上的: $ integral_a^b rho med phi_m phi_n thin d x = 0 , quad m eq.not n $

#strong[定理: Gauss 积分公式的代数精度为 $2 n - 1$, 是 $n$ 节点求积公式中的最高代数精度].

#strong[证明:]

- 首先证明: Gauss 求积的代数精度至少为 $2 n - 1$.

对任意多项式 $p(x) , quad deg p lt.eq 2 n - 1$, 对 $phi(x)$ 作带余除法: $ p(x) = q(x) phi(x) + r(x) , quad deg q lt.eq n - 1 , deg r lt.eq n - 1 $

于是 $ I(p) = integral rho med p = integral rho med q med phi + integral rho med r $

又因为 $phi(x)$ 与任意次数小于等于 $n - 1$ 次的多项式正交, 因此: $ integral_a^b rho(x) q(x) phi(x) thin d x = 0 $

从而 $ I(p) = integral rho med r = I(r) $

从另一面, $ Q(p) = Q(q med phi) + Q(r) $

因为所有求积节点 $x_i$ 都是 $phi$ 的实数根, 所以 $ Q(q phi) = sum_(i = 1)^n A_i q(x_i) dot phi(x_i) = 0 $

因为 $deg r lt.eq n - 1$, 所以普通插值求积公式即可满足精度 $n - 1$, 即 $ I(r) = Q(r) $

综上, $ Q(p) = 0 + Q(r) = I(r) = I(p) $ 这意味着 Gauss 求积公式的代数精度至少为 $2 n - 1$.

- 其次证明: Gauss 求积的代数精度不可能超过 $2 n - 1$.

举一个反例证明 Gauss 求积公式的精度不是 $2 n$ 的: $p(x) = ( phi(x) )^2$

此时 $Q(p) = 0$, 但是 $I(p) = integral rho(x) ( phi(x) )^2 thin d x > 0$. 显然 $Q(p) eq.not I(p)$.

$square.filled.medium$

=== Gauss 求积公式的误差
仍取 $w_n(x) = product_(i = 1)^n(x - x_i)$. 由于正交多项式的唯一性, $w_n(x)$ 应该和上述 $phi(x)$ 仅差一个常数因子.

$ R_n = I(f) - Q(f) = frac(f^(( 2 n )) ( xi ), ( 2 n ) !) integral_a^b rho(x) med ( w_n(x) )^2 thin d x $, 其中 $xi in(a , b)$

由误差可知: $deg f lt.eq 2 n - 1$ 时, $f^(( 2 n )) equiv 0$; $deg f = 2 n$ 时, $f^(( 2 n ))$ 为常数, $R_n eq.not 0$.

=== Gauss-Chebyshev 求积公式
- 区间：$[ - 1 , 1 ]$
- 权函数：$w(x) = 1 / sqrt(1 - x^2)$
- 节点$x_j$： $ x_j = cos frac(( 2 j + 1 ) pi, 2 n + 2) $
- 系数$A_j$： $ A_j = frac(pi, n + 1) $

=== Gauss-Legendre 求积公式
=== Gauss-Laguerre 求积公式
=== Gauss-Hermite 求积公式
== 蒙特卡洛积分






