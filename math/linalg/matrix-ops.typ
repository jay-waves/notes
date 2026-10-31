#import "@local/ypst-template:0.1.0": template, sidenote, theorem, proof

#set document(title: [矩阵运算])
#show: template

#let bmat(..arg) = $mat(delim: "[", ..arg)$
#let vec(x) = $upright(bold(#x))$

矩阵的两种意义:
1. 视为列空间坐标基底, $A x$ 表示向量 $upright(x)$ 在 $A$ 所表示的列空间基底下的坐标. 如 单位基底下的坐标: 
$
(vec(x), vec(y)) = mat(1, 0; 0, 1) dot (vec(x), vec(y))
$

2. 视为对向量的变换, 即一种线性变换: 
$
A (vec(x), vec(y)) = A dot E dot (vec(x), vec(y))
$

= 矩阵乘向量

矩阵描述了欧氏空间的一个线性变换, 如平面旋转或拉伸. 其实质是改变*基底*, $A vec(x)$ 将坐标 $vec(x)$ 从单位基底下, 转到*矩阵 $A$ 变换后的基底下*, 举例而言:

$
bmat(a, b; c, d) dot bmat(x_1; x_2) = bmat(a dot x_1 + b dot x_2; c dot x_1 + d dot x_2) = bmat(a; c) dot x_1 + bmat(b; d) dot x_2
$

观察单位基底下向量表示: 

$ bmat(1; 0) dot x_1 + bmat(0; 1) dot x_2 = bmat(x_1; x_2) $


#sidenote[
  可以发现矩阵 $A = [ vec(alpha) \, vec(alpha) ]$ 将基底变换为 $alpha = ( a \, c )$ 和 $beta = ( b \, d )$, 张成 (线性组合成) 子空间记为 $bb(C) ( A )$. 注意, $x \, med y$ 仍是新基底下的坐标, 而新基底 $alpha = ( a \, c )$ 和 $beta = ( b \, d )$ 是用单位基底表示的.
][
  除了#link("https://notes.jay-waves.cn/math/linalg/vectors/change-of-basis/")[空间基底变换]过程, 
  线性变换的另一个形象体现是#link("https://notes.jay-waves.cn/math/linalg/congruence/")[二次型形状变换], 本质也是基底变换.
]

#image("../../attach/img/math/math-linalg-linear-transformation.webp", width: 60%)

$A_(n times n)$不一定是满秩的, 即其描述的新基底无法张成n维空间. 这种降维有一个生动的例子: 沿着平面内一条直线旋转平面, 垂直纸面时, 平面降维为了一条直线.

#sidenote[
  此时 $A dot.op x = 0$ 的解空间是零空间 $bb(N) ( A )$. 在 $bb(R)^n$ 上, $bb(N) ( A )$ 和 $bb(C) ( A^T )$ 相互正交. 这是从列空间来理解矩阵.
][
  类似请参考 ./linear-systems/solutions-of-linear-systems.typ 线性方程组的解的结构
]

以上是从列空间角度去理解矩阵:

$ mat(A_1, A_2) mat(x; y) = x mat(A_1) + y mat(A_2) $

#linebreak()

还可以从行空间, 线性组合角度理解矩阵: 相当于矩阵 $A$ 三个行向量, 分别乘向量 $vec(b)$. 对于向量乘 $vec(a) dot vec(b)$, 从矩阵角度理解, 等价于 $vec(a)^T vec(b)$. 

$ A vec(b) =
( vec(a)_i^T vec(b))_i ,quad vec(a) dot vec(b)
= vec(a)^T vec(b)
$

$ A^T vec(b) = sum_i b_i vec(a)_i $

#linebreak()

向量乘矩阵也同理, 有两种理解方式:

(1) 列向量相乘：
$ bold(a)^T A = sum_i a_i bold(r)_i = ( bold(c)_j^T bold(a))_j $

(2) 行向量线性组合：
$ bold(a)^T A = a_1 bold(r)_1 + a_2 bold(r)_2 + dots + a_n bold(r)_n $

此时, $A$ 的行向量张成了 $bb(C) ( A^T )$, $y dot.op A = 0$ 的解空间是 $A$ 的左零空间 $bb(N) ( A^T )$. 

= 矩阵相乘

指矩阵相乘: $A dot.op B$, $A$ 决定结果行数, $B$ 决定结果列数. 

$
C = A dot.op B\
"rows"(C) = "rows"(A)\
"cols"(C) = "cols"(B)
$

从列空间角度理解, 结果是矩阵列的线性组合.  从行空间角度理解, 结果是矩阵行的线性组合.

= 矩阵可交换

只要矩阵可交换 $A B = B A$, 就可以牛顿展开, 并且两矩阵共享公共的特征向量基底.

#theorem[如果 $A, B$ 是对称矩阵, 且可交换, 那么 $A B$ 也是对称阵.]

#proof[$( A B )^T = B^T A^T = B A = A B$]

#theorem[如果 $A, B$ 是对称矩阵, 且可交换, 那么 $A$ 和 $B$ 能通过同一正交阵进行相似对角化.]

#proof[
  设 $v$ 是 $A$ 的特征向量, 满足 $A v = lambda_A v$, 考虑到: 

  $
  A ( B v ) = B ( A v ) = lambda_A B v
  $
  这意味 $B v$ 仍是 $A$ 的特征向量, 这可以理解为 $B$ 是在 $A$ 特征空间内闭合的线性变换, 因此可以找到 $v'$ 既是 $A$ 的特征向量, 又是 $B$ 的特征向量.
]

#theorem[如果 $A, B$ 是正定矩阵, 且可交换, 那么 $A B$ 也是正定的.]

#proof[
  由上一个定理知 $Q^T A Q = Lambda_A \, Q^T B Q = Lambda_B$. 

  因此 $vec(x)^T Q^T A B Q vec(x) = vec(x)^T Q^T A Q Q^T B Q vec(x) = vec(x)^T Lambda_A Lambda_B vec(x) = x^T Lambda vec(x) > 0$
]

= 矩阵的转置

矩阵转置后, 其行空间和列空间被对偶交换, 此时 $A vec(x))$ 将 $x$ 坐标转换到列其列空间, $A^T vec(y)$ 将 $y$ 坐标转换到行空间.

$< vec(x) \, A^T vec(y) > = vec(x)^T A^T vec(y) = ( A vec(x) )^T y = < A vec(x) \, vec(y) >$

= 矩阵指数

对于矩阵 $A_(n times n)$ ，定义其幂级数：

$ e^A = sum_(k = 0)^oo frac(A^k, k !) = I + A + frac(A^2, 2 !) + frac(A^3, 3 !) + dots.h.c $


如果 $A$ 可以相似对角化，则有： 

$ e^A = e^(P D P^(- 1)) = P e^D P^(- 1) \, quad e^D = upright("diag") ( e^(lambda_1) \, dots.h \, e^(lambda_n) ) $

= 矩阵对数

矩阵对数定义为*矩阵指数的逆运算*，对于可相似对角化矩阵 $A$ ，矩阵对数 $X = log A$ 满足：

$ log ( A ) = P log ( D ) P^(- 1) \, quad log ( D ) = upright("diag") ( log ( lambda_1 ) \, dots.h \, log ( lambda_n ) ) $


注意，如果矩阵不可逆，需要用约旦标准型来定义矩阵对数。
