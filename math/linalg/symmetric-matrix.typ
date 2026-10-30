#import "@local/ypst-template:0.1.0" : template, sidenote, theorem, lemma, corollary, definition, proof

#show: template

#let vec(x) = math.upright(math.bold(x))
#let bmat(..args) = math.mat(delim: "[", ..args)

= 对称矩阵

$A^top = A$, 所有特征值都为实数.

$ ( sigma ( alpha ) \, beta ) = ( alpha \, sigma ( beta ) ) $

对于任何方阵 $X$, $X + X^top$ 是一个对称矩阵, $X - X^top$ 是一个斜对称矩阵.

== Hermite 矩阵

设 $A in bb(C)^(n times n)$, Hermite 矩阵满足: $A^H = A$; 反 Hermite 矩阵满足: $A^H = - A$. 

对于 Hermite 矩阵 $A$, 定义 $bb(C)$ 上的复二次型: $f ( x ) = x^H A x$.

== 正规矩阵

*正规矩阵 (normal matrix)* 是指: $A^H A = A A^H$

*Hermite 矩阵，酉矩阵，实对称矩阵都是正规矩阵*。

= 实对称矩阵的相似对角化

如果 $A = A^top$, 且属于实数域, 则称 $A$ 为实对称矩阵.

#theorem[如果 $A$ 是实对称矩阵, 那么 $A$ 的特征值全部是实数.]

#theorem[如果 $A$ 是实对称矩阵, 那么 $A$ 的几何重数一定等于代数重数.]

该定理是说, $A$ 特征空间维数一定等于代数重数, 即能找到代数重数个数的线性无关向量

#theorem[如果 $A$ 是实对称矩阵, 那么 $A$ 不同特征的特征向量一定正交.]

#proof[
  设不同特征值 $lambda_1 \, lambda_2$, 有 $A xi_1 = lambda_1 xi_1 \, A xi_2 = lambda_2 xi_2$.  

  有: $lambda_2 xi_1^top xi_2 = xi_1^top A xi_2 = xi_1^top A^top xi_2 = ( A xi_1 )^top xi_2 = lambda_1 xi_1^top xi_2$  
  因为 $lambda_1 eq.not lambda_2$, 所以 $xi_1 perp xi_2$
]

== 谱定理

#theorem[
  实对称矩阵 $A_(n times n)$ 可以被正交矩阵相似对角化:

  $
  Q^top A Q = Q^(- 1) A Q = Lambda = upright("diag") ( lambda_1 , lambda_2 , dots.h.c , lambda_k )
  $
]


其中, 
- $upright("diag")()$ 表示对角矩阵 (Dignomal Matrix), 参数为对角元素.
- $k lt.eq n$, 因为可能存在重根, 重根按重数记入 $Lambda$ 参数.

#sidenote[
  根据矩阵相似对角化原理, 有 $Q = ( xi_1 \, xi_2 \, dots.h \, xi_n )$,
  $Q^top = Q^(- 1) = ( xi_1^top \, xi_2^top \, dots.h \, xi_n^top )^top$. 于是有:
][
  矩阵相似对角化原理详见 ./mat-similarity
]

$
A &= Q Lambda Q^top \ &= 
[ xi_1 , xi_2, dots.h , xi_n ] 
bmat(lambda_1; #none, lambda_2; #none, , dots.down; #none, , , lambda_n) 
bmat(xi_1^top; xi_2^top; dots.v; xi_n^top) \ 
&= lambda_1 xi_1 xi_1^top + lambda_2 xi_2 xi_2^top + dots.h + lambda_n xi_n xi_n^top
$

#linebreak()

$
xi_1 xi_1^top + xi_2 xi_2^top + dots.h + xi_n xi_n^top = Q Q^top = E_n
$

#linebreak()

设向量 $upright(bold(x))$, 经过 $A$ 线性变换后, 可以表示为 $A upright(bold(x)) = Q^top Lambda Q upright(bold(x))$, 这说明, 实对称矩阵存在一组正交特征向量基底，在这组基底下，其作用表现为沿着各特征方向放缩。 
通过旋转 ($Q upright(bold(x))$) 将向量从#link("https://notes.jay-waves.cn/math/linalg/vectors/change-of-basis/")[默认标准正交单位基底]调整为新的正交单位基底, 然后进行正交变换 ($Lambda upright(bold(x))$), 然后再变换回旧基底 ($Q^top upright(bold(x))$). 

#linebreak()

$A = Q Lambda Q^T$ 也被称为*正交分解*, 属于特征值分解的一种特例. 当 $A$ 不满秩时, 也能对角化, 但是存在特征值 $lambda = 0$.

#theorem[在实数域上, A 可正交对角化, 当且仅当, A 是实对称矩阵 ($A^T = A$).]

#theorem[在复数域上, A 可酉对角化, 当且仅当, A 是正规矩阵 ($A^H A = A A^H$).]

== 谱半径

设矩阵 $A_(n times n)$ 的特征值为 $lambda_1 \, lambda_2 \, dots.h \, lambda_n$, 那么 $A$ 的*谱半径*定义为: 
$
rho ( A ) = max | lambda_i |
$

= 实对称矩阵的交换性

#lemma[对角矩阵 $Lambda$ 和 $B$ 可交换, 当且仅当 $B$ 是和 $Lambda$ 结构对应的分块对角矩阵.]

#proof[
  不妨设 $Lambda$ 形式如下, $lambda_i$ 值各不相同: 
$
Lambda = mat(
  lambda_1 I_(k_1), 0, dots.h.c, 0; 
  0, lambda_2 I_(k_2), dots.h.c, 0; 
  dots.v, dots.v, dots.down, dots.v; 
  0, 0, dots.h.c, lambda_m I_(k_m)
  )
$

将 $B$ 按 $Lambda$ 格式分块为: 
$
B = mat(
  B_11, B_12, dots.h.c, B_(1 m); 
  B_21, B_22, dots.h.c, B_(2 m); 
  dots.v, dots.v, dots.down, dots.v; 
  B_(m 1), B_(m 2), dots.h.c, B_(m m)
  )
$

那么:

$
Lambda B = mat(
  lambda_1 B_11, lambda_1 B_12, dots.h.c, lambda_1 B_(1 m); 
  lambda_2 B_21, lambda_2 B_22, dots.h.c, lambda_2 B_(2 m); 
  dots.v, dots.v, dots.down, dots.v; 
  lambda_m B_(m 1), lambda_m B_(m 2), dots.h.c, lambda_m B_(m m)
  )
$

$
B Lambda = mat(
  lambda_1 B_11, lambda_2 B_12, dots.h.c, lambda_m B_(1 m); 
  lambda_1 B_21, lambda_2 B_22, dots.h.c, lambda_m B_(2 m); 
  dots.v, dots.v, dots.down, dots.v; 
  lambda_1 B_(m 1), lambda_2 B_(m 2), dots.h.c, lambda_m B_(m m)
  )
$

要使 $Lambda B = B Lambda$, 需要 $B_(i j) = 0 upright(", if ") i eq.not j$, 所以 $B$ 最终形式为:

$
B = bmat(
  B_1, 0, dots.h.c, 0; 
  0, B_2, dots.h.c, 0; 
  dots.v, dots.v, dots.down, dots.v; 
  0, 0, dots.h.c, B_m
  )
$
]

#sidenote[
  #theorem[如果 $A, B$ 皆为实对称矩阵, 那么: $A B = B A$, 当且仅当, 存在正交矩阵 $Q$, 可将 $A, B$ 同时相似对角化: $Q^top A Q$, $Q^top B Q$]
][
  [1]: 证明请参考: R. A. Horn and C. R. Johnson, *Matrix Analysis*, 2nd ed. Cambridge, UK: Cambridge University Press, 2013, p. 62, Theorem 1.3.12.
]

#lemma[ 如果两个实对称矩阵可交换，则它们存在一组公共的正交特征向量基底.]

#proof[

任取 $A$ 的一个特征值 $lambda$, 设其对应的特征子空间 $bb(V)_lambda = {p | A p = lambda p}$, ${ alpha_1 \, alpha_2 \, dot.op dot.op dot.op \, alpha_m }$ 是 $bb(V)_lambda$ 的一个基.  
由 $A B = B A$ 知, $A ( B alpha_i ) = B ( A alpha_i ) = lambda B alpha_i in bb(V)_lambda \, ( i = 1 \, 2 \, dots.h \, m )$.  
于是存在数 $k_(i j) \, ( i \, j = 1 \, 2 \, dot.op dot.op dot.op \, m )$, 使得

$
B alpha_i = k_(1 i) alpha_1 + k_(2 i) alpha_2 + dot.op dot.op dot.op + k_(m i) alpha_m \, med i = 1 \, 2 \, dot.op dot.op dot.op \, m .
$
  
记 $C = [alpha_1 \, alpha_2 \, dot.op dot.op dot.op \, alpha_m]$, $K = [k_(i j)]_(m times m)$, 则 $B C = C K$．  
设 $mu$ 为 $K$ 的一个特征值, $beta$ 是 $K$ 的对应于 $mu$ 的特征向量, 即 $beta eq.not 0$, $K beta = mu beta$.  
又取 $p = C beta$, 则 $p in bb(V)_lambda$ , 所以 $p$ 是 $A$ 的对应于 $lambda$ 的特征向量,   
于是 $B p = B ( C beta ) = C K beta = C ( mu beta ) = mu p$.   
于是 $p$ 也是 $B$ 的对应于 $mu$ 的特征向量, 故 $A$ 与 $B$ 有公共的特征向量. 

]
