#import "@local/ypst-template:0.1.0" : template, sidenote, theorem, lemma, corollary, proof

#show: template
#let bmat(..args) = math.mat(delim: "[", ..args)
#let vec(x) = math.upright(math.bold(x))

= 矩阵的秩

矩阵的秩指矩阵列 (行) 空间线性无关向量的个数.

#sidenote[
  #theorem[矩阵行秩等于列秩]
][
  这里的证明参考了#link("https://zh.wikipedia.org/wiki/线性代数基本定理")[维基百科]
]

#proof[
  对矩阵 $M_(m times n) ( R )$, 不妨假设 $m > n$.   

  对于行空间, $M$ *最多*能提供 $n$ 个线性无关的向量, 因为向量空间维数为 $n$.  

  对于列空间, $M$ 也*最多*提供 $n$ 个线性无关的向量, 因为 $M$ 最多有 $n$ 个列向量. 相当于 $m$ 维空间中的 $n$ 维子空间.
]

#lemma[
  $"rank" (A) lt.eq n$, 即 $"rank" ( A ) lt.eq "min" { m, med n }$. 
  其中 $"rank")A)$ 是行秩或列秩.
]

#proof[
  对于矩阵 $M$, 行变换不会改变其行空间, 列变换也不会改变其列空间, 即变换不影响矩阵的秩.   

  将 $M$ 不断行变换化简, 并消除零行, 得到最简 $r$ 行矩阵, 是 $M$ 行空间的最大线性无关组, 此时 $upright("rank")(A)_("rows") = r$.  必然有, $r lt.eq n$, 因为行向量维数为 $n$.  

  行变换化简后, 行空间最多只有 $r$ 个线性无关的向量, 由上述引理知, $upright("rank")(A)_("columns") lt.eq r$.   

  由假设反证法可知, 此时列空间不可能再通过列变换压缩为比 $r$ 更低维度的空间, 否则行空间秩会比 $r$ 更小. 所以 $"rank"(A) equiv r$
]

#theorem[
  对于齐次线性方程组 $A_(m times n) vec(x) = vec(0)$, 
  其解空间 $nothing_A$ 和 $A$ 列空间的秩的关系为:

  $ "rank"(A) + "rank"("null"_A) = n $
]

#corollary[若 $A B = 0$, 则 $r ( A ) + r ( B ) lt.eq n$]

#theorem[
  $
  "rank"(A B) <= "min"("rank"(A), "rank"(B))
  $
]

这反映了矩阵变换不会使空间增广, 只会使秩减小或不变.

#theorem[
  $ "rank" ( A plus.minus B ) lt.eq "rank" ( A ) + "rank"(B) $
]

#theorem[
  $
  r ( nothing_(A B) ) lt.eq r ( nothing_A ) + r ( nothing_B )
  $
]

#proof[
  #link("https://notes.jay-waves.cn/math/linalg/linear-systems/linear-system-solutions/")[线性方程组] $B vec(x) = 0$ 的解空间, 属于 $A B vec(x) = 0$ 的解空间, 即 $nothing_B subset.eq nothing_(A B)$.  
  当 $A B vec(x) = 0$ 的解不是 $B vec(x) = 0$ 的解, 即 $B vec(x) eq.not 0$, 则 $B vec(x)$ 属于 $A vec(x) = 0$ 的解空间.  
  因此 $r ( nothing_(A B) ) - r ( nothing_B ) lt.eq r ( nothing_A )$.
]

#theorem[
  $ "rank" ( A B ) gt.eq "rank"( A ) + "rank" ( B ) - n $
]

#proof[

  因为 $r ( nothing_(A B) ) lt.eq r ( nothing_A ) + r ( nothing_B )$  
  所以由定理一: $n - r ( A B ) lt.eq 2 n - r ( A ) - r ( B )$  
  即: $r ( A B ) gt.eq r ( A ) + r ( B ) - n$
]

当且仅当 $nothing_A perp nothing_B$ 时, 有 $r ( nothing_(A B) ) = r ( nothing_A ) + r ( nothing_B )$

#theorem[$r ( A A^T ) = r ( A^T A ) = r ( A ) = r ( A^T )$]

#proof[

  即证 $A vec(x) = 0$ 和 $A^T A vec(x) = 0$ 是同解方程组

  充分性: 由 $A vec(X) = 0$, 得 $A^T A vec(x) = A^T vec(0) = 0$

  必要性: 由 $A^T A vec(x) = 0$, 得 $vec(x^T) A^T A vec(x) = (A vec(x))^T A vec(x) = bar.v.double A vec(x) bar.v.double^2 = 0$, 所以 $A vec(x) = 0$
]

实质上 $C ( A^T A ) = R ( A^T A ) = C ( A^T ) = R ( A )$


= 矩阵等价

如果存在可逆矩阵 $P$ 和 $Q$, 使得 $P A Q = B$, 那么称矩阵 $A$ 和 $B$ 等价, 记 $A tilde.equiv B$.

$P A = B$, 说明 $A$ 和 $B$ 的行向量组等价, 左乘可逆矩阵是对行向量组的线性组合; $A P = B$, 说明 $A$ 和 $B$ 的列向量组等价, 右乘可逆矩阵是对列向量组的线性组合. $P A Q = B$ 没有上述结论, 这说明矩阵等价不意味着两矩阵的向量组等价, 只能说明两者秩相同.

== 满秩分解

#theorem[
  $A in bb(C)_r^(m times n) ( r > 0 )$, 
  存在列满秩矩阵 $B in bb(C)_r^(m times r)$ 和行满秩矩阵 $C in bb(C)_r^(r times n)$ 使得: 
  $A = B C$
]

#proof[
  $A$ 和 $bmat(I_r, 0; 0, 0)$ *等价*, 因此存在可逆矩阵 $P,Q$, 满足: 

  $ A = P bmat(I_r, 0; 0, 0) Q = P bmat(I_r; 0) bmat(I_r, 0) Q $

  那么有 $B = P bmat(I_r; 0)$ 以及 $C = bmat(I_r, 0) Q$, 即 $A = B C$. 
]

这里 $B$ 是 $A$ 的列空间基向量. 显然, 满秩分解并不唯一.

== 满秩分解的求法

不妨设 $A$ 的秩为 $r$.

行变换, 将 $A$ 化简为行最简矩阵: $ P A = R $

取出 $R$ 的非零行作为 $C$: 

$ P A = bmat(I_r; 0) C $

因此有: 

$ A = P^(- 1) bmat(I_r; 0) C = B C $
