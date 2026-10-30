#import "@local/ypst-template:0.1.0": theorem, template

#show: template
#let bmat(..args) = math.mat(delim: "[", ..args)

= 矩阵特征

$A xi = lambda xi$

== 特征多项式的性质

特征多项式方程 $f ( lambda ) = | A - lambda E | = 0$ 有一些重要代数性质...

== 特征向量间的关系

#theorem[不同特征值对应特征向量线性无关.]

#theorem[相同特征值的特征向量, 可能线性无关, 也可能线性相关.]

== 衍生矩阵的特征值

$ A^(- 1)$, $A^T$, $A^(*), ... $

== Hamilton–Cayley 定理

设矩阵 $A in bb(C)^(n times n)$, 其特征多项式为 $chi_A ( lambda ) = det ( lambda I - A )$. 

#theorem[矩阵 $A$ 是自身特征多项式的零点: $chi_A ( A ) = 0$]

== 最小多项式

*最小多项式 $m_(A ( x ))$ 是满足 $m_A ( A ) = 0$ 的最小的首一的非零多项式.*

由 Hamiltion-Cayley 定理可知: 

$ m_A ( x ) | chi_A ( x ) $


在域中, 最小多项式一定可以分解为: 
$
m_A ( x ) = product_(i = 1)^r ( x - lambda_i )^(k_i)
$
, 其中 $lambda$ 是所有不同特征值, $k_i$ 是特征值对应的最大 #link("https://notes.jay-waves.cn/math/linalg/jordan-matrix/")[Jordan 块]大小.


几何重数的上限是空间维度, 而代数重数是没有上限的. (Jordan 标准型和这个有关)

> https://zhuanlan.zhihu.com/p/445344636

== 矩阵多项式的特征

https://zhuanlan.zhihu.com/p/261152093

若$lambda_i eq.not lambda_j$ 映射为 $f ( lambda_i ) = f ( lambda_j )$, 且 $xi_i eq.not xi_j$.

$xi_i + xi_j$ 是 $f ( lambda_i )$ 的特征向量, 但不是 $lambda_i$ 和 $lambda_j$ 的特征向量.

因此 $f(A)$ 的特征向量不一定是 $A$ 的特征向量.

== 代数重数的退化

若当矩阵: 
$
H = bmat(0, 1, 0, dots.h.c, 0, 0; 0, 0, 1, dots.h.c, 0, 0; dots.v, , , dots.down, , dots.v; 0, 0, 0, dots.h.c, 0, 1; 0, 0, 0, dots.h.c, 0, 0)_(n times n)
$

$H$ 只有 $n$ 重特征值 0, 即代数重数为 $n$. 但 0 的几何重数为 1, 即特征子空间的维数为 1:

$
$W_1 = {k (1,0,...,0)^T | k != 0}$
$

再来看其自乘:

$
H^2 = bmat(0, 0, 1, 0, dots.h.c, 0, 0; 0, 0, 0, 1, dots.h.c, 0, 0; dots.v, , , , dots.down, , dots.v; 0, 0, 0, 0, dots.h.c, 0, 1; 0, 0, 0, 0, dots.h.c, 0, 0; 0, 0, 0, 0, dots.h.c, 0, 0)_(n times n)
$

$H^2$ 也只有 $n$ 重特征值 0, 但其特征子空间的维数变为了 2:

$
$W_2 = {k_1 (1,0,...,0)^T + k_2 (0,1,0,...,0)^T | k_1^2 + k_2^2 != 0}$
$

显然 $W_1 subset W_2$, 而 $H^2$ 的特征向量不一定是 $H$ 的特征向量.
