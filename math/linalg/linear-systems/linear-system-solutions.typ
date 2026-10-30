#import "@local/ypst-template:0.1.0": template
#show: template

#let bmat(..args) = $mat(delim: "[", ..args)$

$
mat(
  a_11, a_12, dots.h.c, a_(1 n); 
  a_21, a_22, dots.h.c, a_(2 n); 
  dots.v, , dots.down, ; 
  a_(m 1), a_(m 2), dots.h.c, a_(m n))_(m times n) 
  times vec(x_1, x_2, dots.h.c, x_n)_(n times 1) 
= vec(b_1, b_2, dots.h.c, b_m)_(m times 1)
$

称上式为线性方程组, 记为 $A upright(bold(x)) = upright(bold(b))$. 其中 $upright(bold(x))$ 为未知向量, $A_(m times n)$ 是系数矩阵.

理解 $A upright(bold(x)) = 0$ 有两种方式:
- 从列空间角度, 是对向量 $upright(bold(x))$ 进行线性变换, 变换为 $upright(bold(0))$.
- 从行空间角度, 解空间和行空间垂直.

= 从行空间

解空间和系数矩阵行空间垂直, 因此有 $upright("rank")(A)+upright("rank")(upright("null"))=n$

...

= 从线性变换

$A_(m times n) upright(bold(x)) = 0$

== 齐次方程系数矩阵为方阵

矩阵 $A_(m times n)$, 其中 $m=n$

=== 系数矩阵满秩, 只有零解

$A$ 满秩时, 即 $upright("rank")(A)=n$ 时, 其代表的线性变换不会使维度降低. 这里的维度降低, 可以理解为多个向量 $upright(bold(x))$ 被映射到同一个 $upright(bold(b))$; 不会使维度降低, 代表线性变换是单射. 此时只有 $upright(bold(0))$ 能变换为 $upright(bold(0))$, 即只有零解.

零解 $upright(bold(x)) = 0$ 是平凡的, 即任何线性方程组都有零解.

=== 系数矩阵不满秩, 有无穷非零解 

系数矩阵不满秩, 即该线性变换不是单射, 此时有另一个元 $upright(bold(x))$ 被映射为原点 $upright(bold(0))$. 由线性变换的齐次性可知, $upright(bold(x))$ 同一方向上的向量皆会被映射为原点, 一定有无穷解. (这里没有证明为什么一定有一元被映射为原点)

举一个例子, 想象一个纸平面 ($upright(bold(x))$ 解空间), 其上有一条直线 ( $A$ 的特征空间), 我们眼睛平视该直线, 然后绕该直线旋转平面直至该平面在我们视线和该直线完全重合. 这个过程是一个矩阵 $A$ 代表的线性变换, 直线中间的#link("https://notes.jay-waves.cn/math/linalg/vectors/linear-transform/")[原点保持不变].

此时, 过原点垂直于直线上的所有向量, 都会被映射为原点 $upright(bold(0))$, 所以有无穷解. 这些降维后被隐藏起来的空间被称为*核空间 (null)*. 相应的, 方程组位置向量的所有可能解 $upright(bold(x))$ 构成解空间 $bb(X)$. 在齐次方程中, $upright("null") = bb(X)$.

再举一个例子:
$
vec(x + y, x + y) = mat(delim: "(", 1, 1; 1, 1) dot.op vec(x, y)
$


所有二维空间向量 $( x \, y )^T$ 经过秩为 1 的线性变换后, 被压缩为了一条直线 $y=x$. 

空间被压缩后, 一部分信息被彻底舍弃掉, 这部分信息不可能再被找回. 即不满秩的矩阵变换是不可逆的, 称为不可逆矩阵.

== 齐次方程系数矩阵不是方阵

由于矩阵*行秩等于列秩*, 所有若矩阵 $A_(m times n)$行列数 $m,n$ 不相等, 矩阵的秩至多等于 $upright("min") ( m \, n )$. 行列不相等时, 行空间和列空间的区别变得更加可察, 此时行空间和解空间的向量都是 $n$ 维的, 列空间则是 $m$ 维的.

如果 $m>n$, 此时列向量无法张成 $m$ 维向量空间, 只能张成其中的 $n$ 维子空间. 想象三维空间中的一张纸.

== 非齐次方程 

$A upright(bold(x)) = upright(bold(b))$

1. 若 $upright("rank") ( mat(delim: "[", A, upright(bold(b))) ) eq.not upright("rank") ( A )$, 方程组无解.
2. 若 $upright("rank") ( mat(delim: "[", A, upright(bold(b))) ) = upright("rank") ( A ) eq.not n ( < n )$, 方程组有无穷解, 至多有 $n-r+1$ 个线性无关解. 
3. 若 $upright("rank") ( mat(delim: "[", A, upright(bold(b))) ) = upright("rank") ( A ) = n$, 有唯一解.

想象一个纸平面 ($upright(bold(x))$ 解空间), 其上有一条直线 ( $A$ 的特征空间), 我们眼睛平视该直线, 然后绕该直线旋转平面直至该平面在我们视线和该直线完全重合. 这个过程是一个矩阵 $A$ 代表的线性变换, 设该直线上有一个向量 $upright(bold(b))$. 

可以观察到, 旋转过程中, $upright(bold(x))$ 空间中所有在直线上投影为 $upright(bold(b))$ 的向量 $upright(bold(x))$, 都会最终变换为 $upright(bold(b))$. 投影为 $upright(bold(0))$ 的空间为解空间 (null), 投影为 $upright(bold(b))$ 的空间为 $r(upright("null")) + 1$. 在被压缩掉的维度中, $A upright(bold(x)) = upright(bold(b))$ 有无穷解.

= 从列空间

一个向量组 $alpha_1 \, alpha_2 \, alpha_3 \, alpha_4$ 设其中 $alpha_1 \, alpha_2$ 为极大线性无关组. 此时求 $k_1 alpha_1 + k_2 alpha_2 + k_3 alpha_3 + k_4 alpha_4 = 0$, 解空间 $upright(bold(k))$ 有两个自由度.
