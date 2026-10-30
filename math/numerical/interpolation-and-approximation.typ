#import "@local/ypst-template:0.1.0": template, sidenote

#show: template

#let bmat(..args) = $mat(delim: "[", ..args)$
#let vmat(..args) = $mat(delim: "|", ..args)$

= 插值与多项式逼近问题

== 多项式友矩阵
$f(lambda) = lambda^n + a_(n - 1) lambda^(n - 1) + dots.h + a_1 lambda + a_0$

定义 $f(lambda)$ 的#emph[友矩阵]为: $ A = mat(delim: "[", 0, 1, 0, dots.h, 0; 0, 0, 1, dots.h, 0; dots.v, dots.v, dots.v, dots.down; 0, 0, 0, dots.h, 1; - a_0, - a_1, - a_2, dots.h, - a_(n - 1)) $

或者: $ A = mat(delim: "[", 0, 0, dots.h, 0, - a_0; 1, 0, dots.h, 0, - a_1; 0, 1, dots.h, 0, - a_2; dots.v, dots.v, dots.h, dots.v; 0, 0, dots.h, 1, - a_(n - 1)) $

== 多项式插值
多项式插值 (Polynomial interpolation) 是寻找通过点 $lr({(x_0, y_0), (x_1, y_1), (x_2, y_2), dots.h, (x_n, y_n)})$ 的最低次多项式曲线: $ P_n(x) = a_0 + a_1 x + a_2 x^2 + dots.c + a_n x^n $ 使得 $P(x_i) = y_i$. 对于 $n$ 次多项式 $P_n(x)$, 根据#link("https://notes.jay-waves.cn/math/linalg/linear-systems/linear-system-solutions/")[线性方程组]理论, 至少需要 $n + 1$ 个点 $( x_i , y_i )$ 来确定#strong[唯一]解:

$ P_n(x_0) = y_0 \ P_n(x_1) = y_1 \ dots.v \ P_n(x_n) = y_n $

可以通过矩阵直接求解系数 (#link("https://notes.jay-waves.cn/math/algebra/%E7%8E%AF/%E5%A4%9A%E9%A1%B9%E5%BC%8F%E7%8E%AF/")[范德蒙方法]), 也可以通过拉格朗日插值法和牛顿插值法.

#strong[插值是函数的相反操作], 函数通过曲线确定点, 插值通过点寻找曲线. #strong[插值是级数拟合的一种方式], 其他方式还有: #link("https://notes.jay-waves.cn/robo/cybernetics/fourier-series/")[fourier-series], #link("https://notes.jay-waves.cn/math/calculus/taylor-series/")[泰勒级数], 幂级数和函数, 线性回归.

=== 拉格朗日插值
对于一系列互异点 $lr({(x_0, y_0), (x_1, y_1), (x_2, y_2), dots.h, (x_n, y_n)})$, 拉格朗日插值 (Lagrange Interpolation) 给出的拟合曲线为:

$ P(x) = sum_(i = 0)^n y_i dot L_i(x) $

$ L_i(x) = product_(0 lt.eq j lt.eq n , med j eq.not i) frac(x - x_j, x_i - x_j) $

每个拉格朗日算子 $L_i(x)$ 是 $n$ 阶多项式, 并且满足: $ L_i(x_j) = cases(0 & i eq.not j, 1 & i = j) $

=== 牛顿插值
牛顿插值 (Newton Interpolation) 公式:

$ P(x) = a_0 + a_1(x - x_0) + a_2(x - x_0) ( x - x_1 ) + dots.h + a_n(x - x_0) dots.h ( x - x_(n - 1) ) $

其中 $a_i$ 被称为差商 (divided differences), 可以递推计算:

- 0 阶差商: $f [ x_i ] = f(x_i)$
- 1 阶差商: $ f [ x_i , x_(i + 1) ] = frac(f ( x_(i + 1) ) - f(x_i), x_(i + 1) - x_i) $
- 2 阶差商: $ f [ x_i , x_(i + 1) , x_(i + 2) ] = frac(f [ x_(i + 1) , x_(i + 2) ] - f [ x_i , x_(i + 1) ], x_(i + 2) - x_i) $
- n 阶差商: $ f [ x_0 , x_1 , dots.h , x_n ] = frac(f [ x_1 , dots.h , x_n ] - f [ x_0 , dots.h , x_(n - 1) ], x_n - x_0) $

定义 $a_i = f [ x_0 , x_1 , dots.h , x_i ]$

#link("../../assets/math/math-numerical-divided-difference-table.avif")[差商表]

牛顿插值的优点是: 已用 $n$ 个点求出插值公式后, 有新的点加入, 只需计算新项 $a_(n + 1)$ 即可, 不需要重新计算所有系数.

==== 误差
$R_n(x) = f(x) - p_n(x)$

记 $w_(n + 1)(x) = ( x - x_0 ) ( x - x_1 ) dots.h(x - x_n)$, 而 $I_x$ 为包含所有 $x_i$ 的最小闭区间. $f(t)$ 在 $I_x$ 上有 $n + 1$ 阶导数.

那么插值误差为: $ R_n(x) = frac(f^(( n + 1 )) ( xi ), ( n + 1 ) !) w_(n + 1)(x) $ 其中 $ xi in hat(I)_x $ 且依赖于 $x$.

#strong[证明]:

当 $x = x_i$ (插值点) 时, $R_n equiv 0$ .

当 $x eq.not x_i$ 时, 取辅助函数 $ F(t) = [ f(t) - p_n(t) ] - [ f(x) - p_n(x) ] frac(w_(n + 1)(t), w_(n + 1)(x)) $

$F(x) = 0$, $F(x_i) = 0$, 因此 $ F(t) $ 在 $I_x$ 内有 $ n + 2 $ 个零点. 由罗尔定理可知, $F^(( n + 1 )) ( t )$ 在 $I_x$ 开区间内有 $1$ 个零点:

$ F(xi) = 0 = f^(( n + 1 )) ( xi ) - [ f(x) - p_n(x) ] frac(( n + 1 ) !, w_(n + 1)(x)) $

那么: $ R_n(x) = f(x) - p_n(x) = frac(f^(( n + 1 )) ( xi ), ( n + 1 ) !) w_(n + 1)(x) $

$square.filled.medium$

==== 卡尔龙格现象
Runge Phenomenon (Carl Runge) 发现高次多项式插值并不稳定, 数据点之间出现了显著震荡和偏差, 尤其是区间端点附近.

Runge 函数: $ f(x) = frac(1, 1 + 25 x^2) $

该函数在 $[ - 1 , 1 ]$ 上连续光滑, 取该区间的等距间断点: - 当插值阶数较小时 ($n = 5$), 插值多项式较好逼近了原函数. - 当插值阶数增大时 ($n = 10$), 区间两端出现了明显震荡, 阶数越高震荡越剧烈.

=== 埃尔米特插值 (Hermite)
给定 $n + 1$ 个点 $x_0 dots.c x_i$, 并给定其中 $m + 1$ 个点的导数 (总的坐标集合仍为 $ n + 1 $), 构建最多 $m + n + 1$ 阶多项式:

$ H(x) = sum_(j = 0)^(m + n + 1) a_j x^j $

使其能够满足 Hermite 多项式:

$ {H(x_i) = y_i\
H' ( x_(i_k) ) = y'_(i_k) $

构造时, 先利用 $x_0 , x_1 dots.h , x_n$ 求 $P_n(x)$, 然后构造: $ H(x) = P_n(x) + Q_m(x) omega_(n + 1)(x) $

求导, 并整理:

$ Q_m ( x_(j_k) ) = frac(y'_(j_k) - P'_n ( x_(j_k) ), omega'_(n + 1) ( x_(j_k) )) $

Hermite 多项式的余项 (误差):

$ R(x) = frac(f^(( n + m + 2 )) ( epsilon ), ( n + m + 2 ) !) omega_(n + 1)(x) product_(k = 0)^m ( x - x_(i_k) ) $

=== 平方逼近
设 $phi_i(x)$ 皆是 $[ a , b ]$ 上的连续函数, 且在 $[ a , b ]$ 上线性无关. 它们张成空间 $H_n = upright("span") lr({phi_0, phi_1, dots.h, phi_n})$, $H_n$ 是 $C [ a , b ]$ 的子空间. 对于任意 $p(x) in H_n$, 有 $p(x) = sum_(j = 0)^n c_j phi_j(x)$

在 $C [ a , b ]$ 上, 定义两个函数的内积为: $ ( f , g ) = integral_a^b f(x) g(x) thin d x $

==== 定义-最佳平方逼近
#strong[给定函数 $f(x) in C [ a , b ]$, 若 $p^(*)(x) in H_n$ 满足: $ ( f - p^(*) , f - p^(*) ) = min_(p in H_n)(f - p , f - p) $ 则称 $p^(*)$ 为子空间 $H_n$ 对于 $f(x)$ 的最佳平方逼近元]

==== 定理1
#strong[$p^(*)(x)$ 是 $f(x)$ 的最佳平方逼近元的充要条件为: $ ( f - p^(*) , phi_j ) = 0 quad (j = 0 , 1 , dots.h , n) $]

推论, $forall p(x) in H_n$, 总有: $( f - p^(*) , p ) = 0$.

设 $ p^(*)(x) = sum_(k = 0)^n c_k^(*) phi_k(x) $, 因为 $ ( f - p^(*) , phi_j ) = ( f , phi_j ) - sum_(k = 0)^n c_k^(*)(phi_k , phi_j) $, 所以 $ sum_(k = 0)^n c_k^(*)(phi_k , phi_j) = ( f , phi_j ) quad (j = 0 , 1 , dots.h , n) $ 这个 n+1 阶方程的解存在且唯一.

==== 定理2
#strong[对于 $f(x)$, 最佳平方逼近元 $p^(*)(x)$ 是唯一的].

==== 定义-最佳平方逼近误差
#strong[记 $delta = ( f - p^(*) , f - p^(*) )$ 为最佳平方逼近误差]. 因为 $( f - p^(*) , p^(*) ) = 0$, 所以 $ delta = ( f - p^(*) , f ) = ( f , f ) - ( p^(*) , f ) = ( f , f ) - sum_(k = 0)^n c_k^(*)(phi_k , f) $

=== 正交函数系下的最佳平方逼近
== 样条插值







