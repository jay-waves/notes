#import "@local/ypst-template:0.1.0": template, meta, sidenote

#show: template

#meta(
  subtitle: [矩阵关系],
)

= 目录

- `./vectors/`
  - `./vectors/change-of-basis.typ` 空间基底变换
  - `./vectors/direct-sums-and-proj.typ` 线性空间的直和与相交
  - `./vectors/vector-space.typ` 内积空间
- `./linear-systems/` 线性方程组
- `./matrix-ops.typ`  矩阵基本运算
- `./invertible-matrix.typ` 矩阵的逆 
- `./othogonal-matrix.typ` 正交矩阵
- `./equivalence.typ` 矩阵的秩，矩阵等价
- `./jordan-matrix.typ` 
- `./congruence.md` 矩阵相合，正定矩阵
- `./similarity.typ` 矩阵相似
- `./symmetric-matrix.typ` 对称矩阵与相似对角化 
- `./eigen-values.typ` 矩阵的特征与特征多项式

= 矩阵的关系

#let rows = (
  (
    [等价（相抵）],
    [$R_(m times n) tilde.equiv R_(m times n)$],
    [对于初等矩阵 $P,Q$，有 $B = P_1 ... P_s A Q_1 ... Q_t$],
    [相抵标准型 $E^((r))_(m times n)$],
    [秩],
  ),
  (
    [相似],
    [$R_(n times n) tilde R_(n times n)$],
    [存在可逆矩阵 $P$，有 $B=P^(-1) A P$],
    [相似对角矩阵 $Lambda = upright("diag")(lambda_1,...,lambda_k)$],
    [特征值、秩],
  ),
  (
    [合同（相合）],
    [$R_(n times n) tilde.eq R_(n times n)$],
    [存在可逆矩阵 $P$，有 $B=P^(top) A P$],
    [合同标准型 $Lambda = upright("diag")(1,...,1,-1,...,-1,0,...)$],
    [惯性指数、秩],
  ),
)

#sidenote[
  #table(
    columns: 5,
    table.header(
      [矩阵关系],
      [定义域],
      [定义],
      [代表],
      [不变量],
    ),
    ..rows.flatten(),
  )
][
  矩阵等价，详见 #link("https://notes.jay-waves.cn/math/linalg/equivalence/")[math/linalg/mat-equivalence.typ],\
  矩阵相似，详见 #link("https://notes.jay-waves.cn/math/linalg/similarity/")[math/linalg/mat-similarity.typ],\
  矩阵合同，详见 #link("https://notes.jay-waves.cn/math/linalg/congruence/")[math/lialg/mat-congruence.md]
]

#image("../../assets/math/mat-relation.webp", width: 60%)


= 参考

- [The Art of Linear Algebra, Hiranabe, 2021]
- [Linear Algebra for Everyone, Strang, 2020]
- [Linear Algebra Done Right, Axler, 2015]
- [线性代数, 李尚志, 2004]
