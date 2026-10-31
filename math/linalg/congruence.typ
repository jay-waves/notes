#import "@local/ypst-template:0.1.0": template, sidenote, theorem, proof
#show: template
  
#let bmat(..args) = math.mat(delim: "[", ..args)

#import "@preview/cetz:0.5.2"

#let rotate-point(p, angle) = (
  p.at(0) * calc.cos(angle) - p.at(1) * calc.sin(angle),
  p.at(0) * calc.sin(angle) + p.at(1) * calc.cos(angle),
)

#let base-point(t) = rotate-point(
  (0.75 * calc.cos(t), 0.38 * calc.sin(t)),
  -55deg,
)

#let apply-transform(p, theta, s1, s2) = rotate-point(
  (s1 * p.at(0), s2 * p.at(1)),
  theta,
)

#let panel(
  theta: 0deg,
  s1: 1,
  s2: 1,
  original: false,
) = cetz.canvas(length: 7mm, {
  import cetz.draw: *

  // 网格
  for i in range(-3, 4) {
    let width = if i == 0 { 0.55pt } else { 0.25pt }
    let color = if i == 0 { luma(150) } else { luma(220) }

    line(
      (i, -3), (i, 3),
      stroke: (paint: color, thickness: width),
    )
    line(
      (-3, i), (3, i),
      stroke: (paint: color, thickness: width),
    )
  }

  // 边框
  line(
    (-3, -3), (3, -3), (3, 3), (-3, 3),
    close: true,
    stroke: (paint: luma(120), thickness: 0.4pt),
  )

  // 椭圆
  let points = range(0, 121).map(i => {
    let p = base-point(i * 3deg)
    if original { p } else { apply-transform(p, theta, s1, s2) }
  })

  line(
    ..points,
    close: true,
    stroke: (paint: rgb("#5f7fb6"), thickness: 1.1pt),
  )

})

#let compare-row(
  title,
  theta: 0deg,
  s1: 1,
  s2: 1,
) = [
  #figure(
    grid(
      columns: 2,
      gutter: 12pt,
      panel(original: true),
      panel(theta: theta, s1: s1, s2: s2),
    ),
    caption: title,
  )
]

= 矩阵相合

设二次型为

$
  f(bold(x)) = bold(x)^T A bold(x).
$

作可逆线性替换

$
  bold(x) = P bold(y),
$

则

$
  f
  &= (P bold(y))^T A (P bold(y)) \
  &= bold(y)^T P^T A P bold(y).
$

因此，在线性替换 $bold(x) = P bold(y)$ 下，二次型的矩阵由 $A$ 变为

$
  B = P^T A P.
$

当 $P$ 可逆时，称矩阵 $A$ 与矩阵 $B = P^T A P$ *相合*。

相合描述的是同一个二次型在不同坐标系下的矩阵表示。

= 二次型的线性变换

在二维情形中，任意可逆线性变换都可以通过奇异值分解表示为正交变换与伸缩变换的组合。

其中，正交变换包括旋转和反射。

== 旋转变换

将向量 $bold(x)$ 旋转角度 $theta$，得到

$
  bold(y)
  = R(theta) bold(x)
  = mat(
    cos theta, -sin theta;
    sin theta,  cos theta;
  ) bold(x).
$

如果将旋转作为坐标替换

$
  bold(x) = R(theta) bold(y),
$

则二次型矩阵相应地变为

$
  A' = R(theta)^T A R(theta).
$

旋转矩阵不会改变向量的长度、内积和夹角，只改变二次型主轴方向。

#compare-row(
  [旋转变换 $y=R(theta)x$],
  theta: 85deg,
)

== 伸缩变换

沿两个坐标轴分别伸缩 $s_1$ 和 $s_2$ 倍，可以写成

$
  bold(y)
  = D bold(x)
  = mat(
    s_1, 0;
    0, s_2;
  ) bold(x).
$

若将

$
  bold(x) = D bold(y)
$

作为坐标替换，则二次型矩阵变为

$
  A' = D^T A D.
$

假设二次型已经对角化为

$
  Lambda
  = mat(
    lambda_1, 0;
    0, lambda_2;
  ),
$

则伸缩后的矩阵为

$
  D^T Lambda D
  = mat(
    lambda_1 s_1^2, 0;
    0, lambda_2 s_2^2;
  ).
$

因此，每个对角元都乘上一个平方数。当变换可逆，即所有 $s_i != 0$ 时，对角元的正负性不会改变。

#compare-row(
  [拉伸变换, $y = "diag"(s_1, s_2)$],
  s1: 2.4,
  s2: 0.9,
)


需要注意的是，即使使用对角矩阵 $D$ 进行伸缩，伸缩方向仍然是当前坐标轴方向，并不一定与二次型的主轴方向一致。
若要沿二次型的主轴方向伸缩，需要先将坐标系旋转到主轴坐标系中。

#compare-row(
  [旋转与拉伸, $y=R(theta)"diag"(s_1, s_2)x$],
  theta: 45deg,
  s1: 2.5,
  s2: 1.4,
)

= 主轴变换

由于二次型矩阵 $A$ 是实对称矩阵，根据实对称矩阵的谱定理，存在正交矩阵 $Q$，使得

$
  Q^T A Q = Lambda,
$

其中 $Lambda$ 是由 $A$ 的特征值构成的对角矩阵。

#link("mat-similarity.pdf")[相似对角化]将原坐标 $bold(x)$ 转换到矩阵 $A$ 的特征向量方向，也就是二次型的主轴方向。

令

$
  bold(x) = Q bold(y),
$

则

$
  f
  = bold(y)^T Q^T A Q bold(y)
  = bold(y)^T Lambda bold(y).
$

此时，二次型中不再含有交叉项，可以直接沿各个主轴进行伸缩。

整个变换过程可以理解为：

$
  "原坐标"
  arrow
  "主轴坐标"
  arrow
  "沿主轴伸缩"
  arrow
  "目标二次型".
$

= 正交变换


正交变换保持向量的长度。对任意向量 $bold(x)$，有

$
  norm(Q bold(x))^2
  &= (Q bold(x))^T Q bold(x) \
  &= bold(x)^T Q^T Q bold(x) \
  &= bold(x)^T bold(x) \
  &= norm(bold(x))^2.
$

正交变换也保持内积。对任意向量 $bold(x)$ 和 $bold(y)$，有

$
  (Q bold(x))^T (Q bold(y))
  &= bold(x)^T Q^T Q bold(y) \
  &= bold(x)^T bold(y).
$

由于向量长度和内积均保持不变，正交变换也不会改变两个向量之间的夹角。

因此，旋转与反射只改变图形的位置或方向，不改变图形的长度、角度和形状。
