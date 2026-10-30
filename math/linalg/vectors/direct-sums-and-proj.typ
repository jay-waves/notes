#import "@local/ypst-template:0.1.0" : template

#show: template

设 $W_1 , W_2$ 是线性空间 $V$ 的子空间. 若 $W_1 + W_2$ 中任意向量*均唯一地*表示为 $W_1$ 中的一个向量和 $W_2$ 中的一个向量之和, 则称 $W_1 + W_2$ 是 $W_1 , W_2$ 的*直和*. 记为 $W_1 plus.dot W_2$

若 $W_1 perp W_2$, 则称 $W_1 plus.dot W_2$ 是 $W_1 , W_2$ 的正交直和, 记为 $W_1 xor W_2$. $W_2$ 称为 $W_1$ 的正交补空间, 记为 $W_2 = W_1^perp$

#linebreak()

*直和判定定理*: $W_1, W_2$ 是线性空间的两个子空间, 以下命题等价:
1. $W_2 + W_1$ 是直和
2. $W_1 + W_2$ 中零元素的表示法唯一
3. $W_1 upright("∩") W_2 = emptyset$
4. $"dim"( W_1 + W_2 ) = "dim" W_1 + "dim" W_2$

= 投影

设 $V = W_1 plus.dot W_2$, 其中任意向量 $x in V$ 皆可唯一分解为 $x=y+z$, 
其中 $y in W_1, z in W_2$. 称 $y$ 为 $x$ 在子空间 $W_1$ 上的*投影*.

若 $V = W_1 xor W_2$, 则称 $y$ 为向量 $x$ 在 $W_1$ 上的*正交投影*. 

== 格拉姆-施密特正交化

将一组线性无关的向量 ${alpha_1,alpha_2,...,alpha_n}$ 正交化. 

$ q_1 = alpha_1 $

$
q_2 = alpha_2 - frac(chevron.l alpha_2 \, q_1 chevron.r, chevron.l q_1 \, q_1 chevron.r) q_1
$

$ dots.h.c $

$
q_k = alpha_k - sum_(i = 1)^(k - 1) frac(chevron.l alpha_k \, q_i chevron.r, chevron.l q_i \, q_i chevron.r) q_i = alpha_k - sum_(i = 1)^(k - 1) chevron.l alpha_k \, e_i chevron.r e_i
$


其中 $chevron.l u \, v chevron.r$ 表示向量内积, $chevron.l u \, u chevron.r$ 表示#link("https://notes.jay-waves.cn/math/linalg/vectors/inner-product/")[向量范数] $bar.v.double u bar.v.double$.

如果需要正交单位向量组, 可以将每个正交向量 $q_k$ 再单位化: 
$
e_k = frac(u_k, bar.v.double u_k bar.v.double)
$

== QR 分解

将上述 Gram-Schmidt 正交化过程表示为上三角矩阵: 
$
( alpha_1 , alpha_2 , dots.h.c , alpha_n ) =
 ( e_1 , dots.h , e_n ) dot.op 
 mat(delim: "[", 
  norm(q_1), ( alpha_2 , e_1 ), dots.h, ( alpha_n , e_1 ); 
  0, norm(q_2), dots.h, ( alpha_n \, e_2 ); 
  #none, 0, dots.h, dots.v; 
  #none, , 0, norm(q_n)
  )
$


这其实就是矩阵的 QR 分解, 也叫酉三角分解: $A = Q R$. 
- $Q$ 是酉矩阵. 
- $R$ 为上三角矩阵
- *$A in bb(R)^(m times n)$ 必须是列满秩的*. 

=== 唯一性

*普通 QR 分解不是唯一的.* 取对角线上元素为 $plus.minus 1$ 的对角矩阵 $D$, 有 $A = Q R = ( Q D ) ( D^(- 1) R )$. $Q D$ 仍是正交矩阵, $D^(- 1) R$ 仍是上三角矩阵.

*当 $R_(i i) > 0$ 时, 即当 $R$ 为正线上三角矩阵时, QR 分解是唯一的*. 

=== 必要条件

对于 $A in bb(R)^(m times n)$, 如果 $upright("rank")(A)=n$, 也存在 $Q R$ 分解: 
$
A = Q R
$
, 其中 $Q in bb(R)^(m times m)$ 是正交矩阵, $R in bb(R)^(m times n)$ 是上三角 (或块上三角). 

== 最小二乘解

在 $W in V$ 中, 给定向量 $alpha in V$, 存在 $x in W$ 满足: 
$
bar.v.double alpha - x bar.v.double lt.eq bar.v.double alpha - y bar.v.double \, quad forall y in W
$


则称 $x$ 是 $alpha$ 在子线性空间 $W$ 的最佳逼近向量. 

最小二乘问题详见 #link("https://notes.jay-waves.cn/math/linalg/linear-systems/least-squares/")[线性方程组的最小二乘解].
