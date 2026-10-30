#import "@local/ypst-template:0.1.0": template, sidenote

#show: template

#let bmat(..args) = $mat(delim: "[", ..args)$
#let vmat(..args) = $mat(delim: "|", ..args)$

Taylor Series 实际是对函数 $f(x)$ 的一种拟合手段. 和插值拟合不同, 泰勒展开仅针对一个点, 用该点的各阶函数导数来拟合函数.

要拟合 $f(a)$ 处的函数, 拟合结果 $F(x)$ 应满足: 1. $F(a) = f(a)$ 2. $F'(a) = f'(a)$ 一阶导数相同. 3. $F''(a) = f''(a)$ 二阶导数相同. 4. …. 5. $F^(( n )) ( a ) = f^(( n )) ( a )$, 各个阶导数相同.

借助插值拟合的思路, 在 $x = a$ 处: 1. $F(a) = f(x) |_(x = a) + g(x) ( x - a ) |_(x = a)$ 2. $F'(a) = ( f(a) )' + g'(x) ( x - a ) |_(x = a) + g(x) |_(x = a) = f'(a)$, 即 $g(a) = f'(a)$

同理, 借助数学归纳法:

$ F(a) = sum_(n = 0)^oo frac(f^(( n )) ( a ), n !) ( x - a )^n $

直观上, 导数代表函数的一种”趋势”, 拟合函数 $f(x)$ 在 x=a 点的所有阶导数, 即拟合了 $f(x)$ 在 x=a 的所有趋势. 当阶数足够大时, 对 x=a 附近的 $f(x)$ 拟合效果较好. 注意到, 一阶展开实际就是切线方程.

== 另一种证明方法#footnote[#link("https://math.stackexchange.com/questions/706282/how-are-the-taylor-series-derived")[How are the Taylor Series derived - Mathematics Stack Exchange]]
注意到:

$ f(x) = f(0) + integral_0^x f'(t) thin d t thin thin thin =^(t mapsto x - t) thin thin thin f(x) = f(0) + integral_0^x f'(x - t) thin d t $

分步积分: $ f(x) & = f(0) + f'(0) x + integral_0^x t f''(x - t) thin d t\
 & = f(0) + f'(0) x + 1 / 2 f''(0) x^2 + 1 / 2 integral_0^x t^2 f'''(x - t) thin d t\
 & = dots.c\
 & = f(0) + f'(0) x + 1 / 2 f''(0) x^2 + dots.c + frac(f^(( n )) ( 0 ), n !) x^n\
 & + frac(1, n !) integral_0^x t^n f^(( n + 1 )) ( x - t ) thin d t $

红色部分为泰勒展开的积分余项形式.

== 泰勒展开的余项估计
泰勒展开有两个问题需探究#footnote[#link("https://davidlowryduda.com/p/1520/")[MixedMath An intuitive overview of Taylor series], 泰拉展开误差有很多求法, 也能用拉格朗日公式求.]: 1. 这种拟合方法的效果如何? 2. 该式趋于无限高阶时, 拟合程度是否有上限? 即能否”完美地”拟合函数 $f(x)$.

#strong[答案是否定的], 反例如下 (bump function): $ b(x) = cases(delim: "{", e^(frac(- 1, 1 - x^2)) & 0 lt.eq x < 1, 0 & x gt.eq 1) $

$b(x)$ 是可导的, 在 $x = 1$ 处的所有阶导数皆为0, 即泰勒展开 $b'(x) equiv 0$.

借助#link("https://notes.jay-waves.cn/math/calculus/mean-value-theorem/")[拉格朗日微分中值定理], 可以#strong[求解余项(误差)]#footnote[该余项也被称为拉格朗日型余项, 但实际是由柯西推出的. #link("https://zh.wikipedia.org/wiki/%E6%B3%B0%E5%8B%92%E5%85%AC%E5%BC%8F")[wiki]]

$ f(x) = f(a) + f'(a) ( x - a ) + frac(f^(( 2 )) ( a ), 2 !) ( x - a )^2 + dots.h + frac(f^(( n )), n !) ( x - a )^n + frac(f^(( n + 1 )) ( xi ), ( n + 1 ) !) ( x - a )^(( n + 1 )) , xi in(a , x) $

记余项为 $R_n(x) = frac(f^(( n + 1 )) ( xi ), ( n + 1 ) !) ( x - a )^(( n + 1 )) , xi in(a , x)$

如果存在 $M_n$, 使区间 $( a - r , a + r )$ 里的任意 x 皆有 $| f^(( n + 1 )) ( x ) | lt.eq M_n$, 那么应有上界: $ | R_n(x) | lt.eq M_n frac(r^(( n + 1 )), ( n + 1 ) !) $

== 常见麦克劳伦展开式
在 $x = 0$ 处展开的泰勒数列 (Taylor Series) 被称为麦克劳伦数列 (Mclaurin Series)

$ e^x = 1 + x + frac(x^2, 2 !) + dots.c + frac(x^n, n !) + o(x^n) $

$ sin x = x - frac(x^3, 3 !) + frac(x^5, 5 !) - dots.c + frac(( - 1 )^m, ( 2 n + 1 ) !) x^(2 n + 1) + o ( x^(2 n + 1) ) $

$ cos x = 1 - frac(x^2, 2 !) + frac(x^4, 4 !) - dots.c + frac(( - 1 )^m, ( 2 n ) !) x^(2 n) + o ( x^(2 n) ) $

$ frac(1, 1 - x) = 1 + x + x^2 + dots.c + x^n + o(x^n) $

$ frac(1, 1 + x) = 1 - x + x^2 - dots.c + ( - 1 )^n x^n + o(x^n) $

$ ln(1 + x) = x - x^2 / 2 + x^3 / 3 - dots.c + frac(( - 1 )^(n + 1), n) x^n + o(x^n) $

$ ( 1 + x )^a = 1 + a x + frac(a(a - 1), 2 !) x^2 + dots.c + frac(a(a - 1) dots.c(a - n + 1), n !) x^n + o(x^n) $

$ arctan x = x - x^3 / 3 + x^5 / 5 - dots.c + frac(( - 1 )^m, 2 n + 1) x^(2 n + 1) + o ( x^(2 n + 1) ) $






