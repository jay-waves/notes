#import "@local/ypst-template:0.1.0": template, sidenote

#show: template

#let bmat(..args) = $mat(delim: "[", ..args)$
#let vmat(..args) = $mat(delim: "|", ..args)$

= 线性方程组的解法

== 克莱姆 (Cramer) 方法
克莱姆法则 (Cramer's Rule) 使用行列式来求解线性方程组.

对于线性方程组: 

$ 
cases(
a_11 x_1 + a_12 x_2 + dots.c + a_(1 n) x_n = b_1,
a_21 x_1 + a_22 x_2 + dots.c + a_(2 n) x_n = b_2,
dots.v,
a_(n 1) x_1 + a_(n 2) x_2 + dots.c + a_(n n) x_n = b_n,
)
$

设系数矩阵 $A$ 的行列式 $D = | A | eq.not 0$, 则方程组有唯一解: $x_i = D_i / D$

其中 $D_i$ 是将系数矩阵 $A$ 的第 $i$ 列替换为常数列 $hat(b)$ 后的行列式. $ D_i = vmat(a_11, dots.c, b_1, dots.c, a_(1 n); a_21, dots.c, b_2, dots.c, a_(2 n); dots.v, , dots.v, , dots.v; a_(n 1), dots.c, b_n, dots.c, a_(n n)) $

只适合规模不大的方程, 并且要求系数矩阵非奇异.

=== 证明
$ det(D_i) = det ( upright(bold(a))_1 , dots.h , upright(bold(b)) , dots.h , upright(bold(a))_n ) = det ( upright(bold(a_1)) , dots.h , x_1 upright(bold(a_1)) + dots.h + x_n upright(bold(a))_n , dots.h , upright(bold(a))_n ) $

将行列式按第 $i$ 列展开:

$  & det(D_i)\
 & = x_1 det ( upright(bold(a))_1 , dots.h , upright(bold(a_1)) , dots.h , upright(bold(a))_n ) + dots.h + x_i det ( upright(bold(a))_1 , dots.h , upright(bold(a))_i , dots.h , upright(bold(a))_n ) + dots.h\
 & = x_i det(A)\
 & = x_i D $

于是有: $ x_i = D_i / D $

== 高斯 (Gauss) 消去法
本质上两种方法都首先构建了一个增广矩阵:

$ bmat(
  a_11, dots.c, a_(1 n), b_1; 
  dots.v, dots.down, dots.v, dots.v; 
  a_(n 1), dots.c, a_(n n), b_n; 
) $

然后按行进行初等变化, 使得矩阵变为如下的形式:

$ bmat(
  1, dots.c, a'_(1 n), b'_1; 
  #none, dots.down, dots.v, dots.v; 
  upright(bold(0)), , 1, b'_n; 
) $

代回, 变化成下面的矩阵, 得到的即为向量 $upright(bold(x))$ 的解:

$ bmat(upright(bold(I))_(n times n), upright(bold(b'))_(n times 1)) $

=== LU 分解
用高斯消除法求解#link("https://notes.jay-waves.cn/math/linalg/linear-systems/linear-system-solutions/")[非齐次线性方程组] $A dot x = b$, 也被称为矩阵 $L dot U$ 分解. 每一步高斯消去, 等价于用一个单位下三角矩阵 $L_k^(- 1)$ 左乘 $A$, 将所有行变换操作连乘, 得到 $L^(- 1) A = U$, 即 $A = L U$.

高斯消去法的充要条件是*所有顺序主子式都非零*, 即每一步都不会遇到零主元 (对角元). 如果某步主元为零 (或者非常小, 为了数值稳定性), 需要将其与非零行交换, 引入置换矩阵 $P$: $P A = L U$.

=== 三角分解法
$ A x = L U x = L y = b $, 求解时, 先求 $y$, 然后求 $x$.

对于 $ D o o l i t t l e$ 分解, $L$ 为单位下三角阵 (主对角元为1), $U$ 为上三角阵:

$ 
upright(bold(L)) = bmat(1, 0, 0, dots.h, 0; 
  l_21, 1, 0, dots.h, 0; 
  l_31, l_32, 1, dots.h, 0; 
  dots.v, dots.v, dots.v, dots.down, 0; 
  l_(n 1), l_(n 2), l_(n 3), dots.h, 1; 
) quad upright(bold(U)) = bmat(
  u_11, u_12, u_13, dots.h, u_(1 n); 
  0, u_22, u_23, dots.h, u_(2 n); 
  0, 0, u_33, dots.h, u_(3 n); 
  dots.v, dots.v, dots.v, dots.down, dots.v; 
  0, 0, 0, dots.h, u_(n n); 
) 
$

对于 #emph[$C r o u t$ 分解], $L$ 为下三角阵, $U$ 为单位上三角阵:

$ upright(bold(L)) = mat(delim: "[", l_11, 0, 0, dots.h, 0; l_21, l_22, 0, dots.h, 0; l_31, l_32, l_33, dots.h, 0; dots.v, dots.v, dots.v, dots.down, 0; l_(n 1), l_(n 2), l_(n 3), dots.h, l_(n n); #none) quad upright(bold(U)) = mat(delim: "[", 1, u_12, u_13, dots.h, u_(1 n); 0, 1, u_23, dots.h, u_(2 n); 0, 0, 1, dots.h, u_(3 n); dots.v, dots.v, dots.v, dots.down, dots.v; 0, 0, 0, dots.h, 1; #none) $

#strong[Doolittle 和 Crout 分解的充分必要条件都为 $upright(bold(A))_(n times n)$ 的前 $n - 1$ 个顺序主子式不为零.]

== 病态方程问题
对非奇异矩阵 $A$ (可逆矩阵), 定义其#emph[条件数]为: $ upright("cond")(A) = norm(A) dot norm(A^(- 1)) $, 其中 $norm(A)$ 为某种矩阵范数.

推论:

- #strong[任意非奇异矩阵 $A$, 总有 $upright("cond")(A) gt.eq 1$]

- #strong[$A$ 是非奇异矩阵, $k eq.not 0$ 是常数, 则有 $ upright("cond")(k A) = upright("cond")(A) $.]

- #strong[条件数越大, 方程越病态, 微小扰动会导致数值解巨大变化], 满足: $ frac(norm(delta x), norm(x)) lt.eq upright("cond")(A) frac(norm(delta b), norm(b)) $

== 迭代法
对于大型稀疏矩阵, 上述精确算法效率低. 迭代法可以快速逼近解.

=== 简单迭代法
对于简单迭代法，将原方程组改写为:

$ {A x = ( N - P ) x = b\
N x = P x + b\
x = N^(- 1) P x + N^(- 1) b = G x + d $

迭代式为: $ upright(bold(x))^(( k + 1 )) = upright(bold(G x))^(( k )) + upright(bold(d)) $

==== 迭代法的收敛条件
#strong[定理一: 迭代法的收敛, 当且仅当, #link("https://notes.jay-waves.cn/math/linalg/symmetric-matrix/")[谱半径]满足 $rho(G) < 1$]

#strong[定理二: 如果矩阵 $G$ 的某种矩阵范数满足 $norm(G) < 1$, 那么迭代法也收敛且解唯一]. 此时有误差估计公式:

$ norm(upright(bold(x))^(( k )) - upright(bold(x))^(*)) lt.eq frac(norm(upright(bold(G)))^k, 1 - norm(upright(bold(G)))) norm(upright(bold(x))^(( 1 )) - upright(bold(x))^(( 0 ))) $ $ norm(upright(bold(x))^(( k )) - upright(bold(x))^(*)) lt.eq frac(norm(upright(bold(G))), 1 - norm(upright(bold(G)))) norm(upright(bold(x))^(( k )) - upright(bold(x))^(( k - 1 ))) $

=== Jacobi 迭代法
将原矩阵拆为三部分:

$ upright(bold(A = D + L + U)) $, 其中, $D$ 是对角阵, $L , U$ 是严格三角阵.

这样原来的迭代方法有： $ upright(bold(x))^(( k + 1 )) = [ upright(bold(- D))^(- 1) ( upright(bold(L + U)) ) ] upright(bold(x^(( k )))) + upright(bold(D))^(- 1) upright(bold(b)) $

Jacobi 有一个额外的#strong[收敛定理]:

#strong[若矩阵 $upright(bold(A))$ 是按行/按列严格占优阵] ($| a_(i i) | > sum_(i eq.not j) | a_(i j) |$), #strong[那么 Jacobi 迭代法必然收敛, 同时 $A$ 近似非奇异矩阵.]

#quote(block: true)[
证明可以参考 #link("https://notes.jay-waves.cn/math/numerical/eigenvalue-problems/")[盖尔圆盘定理].
]

=== Gauss-Seidel (GS) 迭代方法
Gauss-Seidel 方法在 Jacobi 方法上做了一些调整, 保持矩阵 $upright(bold(D)) , upright(bold(L)) , upright(bold(U))$ 不变, 调整迭代方法: $ upright(bold(x))^(( k + 1 )) = [ upright(bold(- ( D + L )))^(- 1) upright(bold(U)) ] upright(bold(x^(( k )))) + [ upright(bold(( D + L )))^(- 1) upright(bold(b)) ] $

GS 方法也有一个额外的#strong[收敛定理]: #strong[若 $A$ 为正定矩阵, 那么 GS 方法收敛].

=== 逐次超松弛 (SOR) 迭代法
…






