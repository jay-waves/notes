#import "@local/ypst-template:0.1.0": template, sidenote, theorem, proof

#show: template

#let vec(x) = math.upright(math.bold(x))

= 矩阵相似

#sidenote[
  若存在可逆矩阵 $P$, 使得 $P^(- 1) A P = B$, 则称矩阵 $A$ 和 $B$ 相似, 记为 $A tilde.op B$.
][
  线性变换 可以参考 `./vectors/linear-transform.typ`
]

矩阵相似描述了同一线性变换在不同基底下的表示, $P$ 是某种过渡矩阵, 
$P vec(x)$ 将坐标 $vec(x)$ 转换为新基底下的坐标, 
$A P vec(x)$ 指对新基底下的向量进行 $A$ *线性变换*, 然后 $P^(- 1) A P vec(x)$ 将坐标重新转换回原基底. 一系列操作的效果, 等价于直接进行 $B vec(x)$ 线性变换.

> 秩相同, 不等于矩阵相似, 还需要矩阵同型; 特征值相同, 不等于特征方向相同.

== 矩阵特征值

若存在非零向量 $xi in bb(R)^n$ 使得 $A_(n times n) xi = lambda xi$, 称 $lambda$ 为矩阵的一个特征值, $xi$ 为该特征值对应的一个特征向量.

将 $A$ 看作一个线性变换, $A xi = lambda xi$ 表示 $xi$ 在线性变换后只有尺度上的伸缩, 而没有方向的变化, 也没有维度上的变化. 对于特征值 $lambda_i$, $xi$ 位于 $( A - lambda_i E ) xi = 0$ 的解空间 (也成为 $lambda_i$ 的特征空间) 之中, 该解空间维数 ($n - r ( A - lambda_i E )$) 称为该特征值的几何重数; 要使解空间存在, 应保证 $| A - lambda E | = 0$, 方程 $f ( lambda ) = | A - lambda E | = 0$ 在复数域上的完全分解中, 项 $( lambda - lambda_i )^k$ 的(重根)次数 $k$ 称为该特征值的代数重数.

#sidenote[
  #theorem[如果 $A$ 和 $B$ 相似, 那么 $A$ 和 $B$ 的特征值相同.]
][
  在 $A$ 的特征方向上, 向量只有长度变化, 而向量在不同基底表示下是同一的.
  将特征向量的坐标 $xi$ 从旧基底变换到新基底下 $P^(- 1) xi$, 向量模数仍变化 $lambda$ 倍.
]

#proof[
  设 $A xi = lambda xi$, $P^(- 1) A P = B$, 则有 $P^(- 1) A xi = P^(- 1) A P dot.op P^(- 1) xi = B dot.op P^(- 1) xi = P^(- 1) lambda xi$. 所以 $A$ 和 $B$ 特征值相同, $B$ 对应的特征向量为 $P^(- 1) xi$.
]

#linebreak()

== 相似对角化

#sidenote[
  如果用 $A$ 的全部特征方向作为*新基底*, 该线性变化就可以描述为对新基底的数乘, 即一个对角矩阵, 该过程称为矩阵的相似对角化. 不是所有矩阵都可以相似对角化, 如果 $lambda_i$ 特征空间的线性无关向量个数少于 $lambda_i$ 的代数重数, 就凑不出*新基底*数量.
][
  这部分论述可以参考 `./vectors/change-of-basis.typ` 空间基底变换
]

若存在 $n$ 阶可逆矩阵 $P$, 使得 $P^(- 1) A P = Lambda$, 则称 $A$ 可相似对角化. 


$
A dot.op P & = A dot.op [ xi_1 \, xi_2 \, dots.h \, xi_n ]\
 & = P dot.op Lambda\
 & = [ xi_1 \, xi_2 \, dots.h \, xi_n ] dot.op mat(delim: "[", lambda_1; #none, lambda_2, ; #none, , dots.down, ; #none, , , , lambda_n)
$


由 $P$ 可逆, 知 $[ xi_1 \, xi_2 \, dots.h \, xi_n ]$ 线性无关. 因此 $A_(n times n)$ 可相似对角化 等价于 $A$ 有 $n$ 个线性无关的特征向量.

$A = P Lambda P^(- 1)$ 被称为*特征值分解 (Eigenvalue Decomposition, EVD)*.
