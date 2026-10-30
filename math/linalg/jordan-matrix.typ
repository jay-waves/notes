#import "@local/ypst-template:0.1.0": theorem, template 
#show: template

#let bmat(..args) = math.mat(delim: "[", ..args)
#let vec(x) = math.upright(math.bold(x))

= Jordan 标准型

$
vec(J) = bmat(J_(m_1) ( lambda_1 ), 0, dots.h.c, 0; 0, J_(m_2) ( lambda_2 ), dots.h.c, 0; dots.v, , dots.down, ; 0, 0, dots.h.c, J_(m_k) ( lambda_k ))
$


其中 
$
J_(m_i) ( lambda_i ) = bmat(
    lambda_i, 1, , ; 
    #none, dots.down, dots.down, ; 
    #none, , dots.down, 1; 
    #none, , , lambda_i
  )_(m_i times m_i)
$


默认排列顺序为 $lambda_1 gt.eq lambda_2 gt.eq dots.h.c gt.eq lambda_k$

任何矩阵都相似于一个 Jordan 标准型: $A = P J P^(- 1)$

特征值 $lambda_i$ 的代数重数 $beta_i$: $vec(J)$ 的对角线上 $lambda_i$ 出现次数

特征值 $lambda_i$ 的几何重数 $n_i$: 主对角元为 $lambda_i$ 的 Jordan 块个数. 可相似对角化时, 所有 Jordan 块都必须为一阶矩阵, 整个 $vec(J)$ 退化为对角矩阵. 

https://wuli.wiki/online/ltrJor.html

https://blog.csdn.net/Insomnia_X/article/details/128796288

矩阵不一定能#link("https://notes.jay-waves.cn/math/linalg/similarity/")[相似对角化], 但是一定能化为若当标准型. 当矩阵几何重数等于代数重数时, 若当标准型就是对角矩阵.

= 若当标准化

设矩阵 $A$, 要求若当标准型 $J$, 满足 $A = P J P^(- 1)$.

*步骤一*: 用矩阵特征多项式 $det ( A - lambda E ) = 0$, 计算所有特征值 $lambda_i$ 及其代数重数.

*步骤二*: 对于每个特征值 $lambda_i$ 计算满足 $( A - lambda_i E ) x = 0$ 的特征空间 $upright(x)$ 中线性无关向量, 其个数为 $lambda_i$ 的几何重数.

*步骤三*: 如果所有 $lambda_i$ 的几何重数皆等于代数重数, 那么矩阵 $A$ 是可相似对角化的. 

*步骤四*: 如果某些特征值 $lambda_i$ 的几何重数不等于代数, 则不能完全相似对角化, 为了化为若当标准型 $J$, 需要找到其广义特征向量.
此时通过解广义特征方程 
$
( A - lambda_i E )^k dot.op upright(x) = 0
$
, 来寻找广义线性无关特征向量 $v_1 \, v_2 \, dots.h \, v_k$. 广义特征向量满足*若当链*递推关系: 
$
{( A - lambda_i E ) dot.op v_1 = 0\
( A - lambda_i E ) dot.op v_2 = v_1 & arrow.l.r.double ( A - lambda_i E )^2 dot.op v_2 = 0\
( A - lambda_i E ) dot.op v_3 = v_2 & arrow.l.r.double ( A - lambda_i E )^3 dot.op v_3 = 0\
dots.v\
( A - lambda_i E ) dot.op v_k = v_(k - 1) & arrow.l.r.double ( A - lambda_i E )^k dot.op v_k = 0\
$

, 在实际操作中, 不断增大 $k$, 直到方程核空间不再增大, 或链终止 ($( A - lambda_i I )^k = 0$).

*步骤五*: 对于每个特征值 $lambda_i$, 不妨设其代数重数为 $m$, 几何重数为 $g$. *每个几何重数对应了一个线性无关的特征向量, 以它为起点构造一条若当链, 链长度 $k$ 为其对应其若当块大小.* *可能有多种构造方式(??)*, 但链长度的总和需要等于特征值的代数重数 $m$, 链的数量不能超过几何重数 $g$. 
特征值 $lambda_i$ 对应的若当标准型(一部分)形式如下:

$
J ( lambda_i ) = bmat(
  J_(k 1) ( lambda_i ); 
  0, J_(k 2) ( lambda_i ); 
  0, 0, J_(k 3) ( lambda_i ); 
  0, 0, 0, dots.down
  )
$

== 正确性证明

设 $lambda_i$ 的一个若当块为 
$
J_3 ( lambda_i ) = bmat(lambda_i, 1; 0, lambda_i, 1; 0, 0, lambda_i)
$

对应若当链为 $v_1 \, v_2 \, v_3$. 

类比 #link("https://notes.jay-waves.cn/math/linalg/similarity/")[矩阵相似对角化] 中的形式, 若当标准化的局部为 
$
A dot.op P ( lambda_i ) = P ( lambda_i ) dot.op J_3 ( lambda_i ) = mat(v_1, v_2, v_3) mat(lambda_i, 1; 0, lambda_i, 1; 0, 0, lambda_i) = ( lambda_i v_1 \, med v_1 + lambda_i v_2 \, med v_2 + lambda_i v_3 )
$


对于矩阵第二列: 
$
A v_2 = v_1 + lambda_i v_2 med arrow.l.r.double med ( A - lambda_i E ) v_2 = v_1 arrow.l.r.double ( A - lambda_i E )^2 v_2 = 0
$


*由 #link("https://notes.jay-waves.cn/math/linalg/eigen-values/")[Hamilton-Cayley 定理]可知, 若当链的长度上限, 是矩阵最小多项式中 $lambda_i$ 项对应的指数.*

== Smith-Frobenius 结构定理

#theorem[
  对矩阵 $x I - A$, 在多项式环 $F[x]$ 上存在可逆矩阵 $U ( x ) \, V ( x ) in G L_n ( F [ x ] )$, 使得:

  $
  U ( x ) ( x I - A ) V ( x ) = upright("diag") ( d_1 ( x ) \, dots.h \, d_n ( x ) )
  $

  $
  d_1 ( x ) | d_2 ( x ) | dots.h | d_n ( x )
  $

  其中, $d_i ( x )$ 唯一确定, 称为*不变因子*.
]

$U/V$ 可以理解为初等行/列变换, 是多项式环上的不改变模的同构构造.

=== 初等因子

每个不变因子可以进一步分解: 
$
d_i ( x ) = product_lambda ( x - lambda )^(e_(i \, lambda))
$
, 如果 $e_(i \, lambda) > 0$, 就存在一个与之对应的 Jordan 块 $J_(e_(i \, lambda)) ( lambda )$.

易知, 任一 Jordan 块的最小多项式等于它的特征多项式.
