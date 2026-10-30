#import "@local/ypst-template:0.1.0": template, definition, theorem, proof

#show: template

#let GF(x) = $upright("GF")(#x)$
#let EC(a, b) = $upright("EC")(#a, #b)$
#let O = $cal(O)$

#meta(
  revised: [24-11-29],
  code: [src/cryptography/ec_plot.py],
)

= 实数域椭圆曲线运算

满足 Weierstrass 方程的点集称为椭圆曲线:
$
Y^2 = X^3 + a X + b
$

也记为 #EC($a$, $b$), 其中 $4 a^3 + 37 b^2 != 0$.
该条件保证曲线非奇异, 意味着曲线几何上无不可导尖锐点、自相交点、孤立点, 有利于定义更完备的运算性质.

#table(
  columns: 2,
  [$y^2 = x^3 - 3x + 3$],
  [$y^2 = x^3 - 6x + 5$],
  image("../../../attach/img/math/curve_-3_3.webp", width: 80%),
  image("../../../attach/img/math/curve_-6_5.webp", width: 80%),
  [$y^2 = x^3$ 含不可导点],
  [$y^2 = x^3 - 3x + 2$ 含自相交点],
  image("../../../attach/img/math/curve_0_0.webp", width: 80%),
  image("../../../attach/img/math/curve_-3_2.webp", width: 80%),
)

== 负元

点 $bold(P): (x, y)$ 的负元是其关于 x 轴的对称点 $(x, -y)$.

== 点加法

#definition[
  $P(x_1, y_1)$, $Q(x_2, y_2)$ 和 $R(x_3, y_3)$, 若 $P + Q = R$, 则三点有如下关系:
  $
  x_3 equiv k^2 - x_1 - x_2 \
  y_3 equiv k (x_3 - x_1) + y_1
  $

  其中斜率 $k$ 为:
  $
  k = cases(
    (3 x_1^2 + a) \/ (2 y_1) "if" P = Q,
    (y_2 - y_1) \/ (x_2 - x_1) "if" P != Q,
  )
  $
]

几何上, $R$ 是 $P Q$ 直线与曲线交点的关于 x 轴的对称点.

=== $P != Q$ 推导

#image("../../../attach/img/math/sec-crypto-ecc-point-addition.webp", width: 45%)

设 $P(x_1, y_1)$, $Q(x_2, y_2)$.
斜率 $k = (y_2 - y_1) \/ (x_2 - x_1)$, 所以直线表示为 $y = k x + t$.

计算直线与椭圆曲线的交点:
$
(k x + t)^2 = x^3 + a x + b.
$
展开为
$
x^3 - k^2 x^2 + (a - 2 k t) x + b - t^2 = 0.
$
已知实数域上上述三次方程必有解, 由代数基本定理知, 上述方程等价为:
$
(x - x_1)(x - x_2)(x - x_3) = 0.
$
两者比较得 $-(x_1 + x_2 + x_3) x^2 = -k^2 x^2$, 即 $x_1 + x_2 + x_3 = k^2$.
要求 $y_3$, 使用斜率公式即可:
$
k = (y_3 - y_1) \/ (x_3 - x_1).
$

=== $P = Q$ 推导

#image("../../../attach/img/math/sec-crypto-ecc-point-doubling.webp", width: 45%)

此时直线为 $P$ 点切线. 同时对 $x$ 求导:
$
2 y y' = 3 x^2 + a
$
得斜率:
$
k = y' = (3 x^2 + a) \/ (2 y)
$
其余公式和 $P != Q$ 情景相同.

=== 无穷远点

以上加法不完备, 存在两点 x 坐标相同时不存在第三个点的情况.
因此定义无穷远点, 记为 #O, 有 $P = #O + P$.
由于当 $b != 0$ 时, $y^2 = x^3 + a x + b$ 形式的曲线不过 $(0, 0)$ 点, 故程序中通常记 #O 为 $(0, 0)$.

== 点数乘

#definition[
  对于正整数 $n$ 和椭圆曲线上点 $P$, 定义数乘运算:
  $
  [n] P = P + P + dots.c + P
  $
]

蒙哥马利算法类似#link("https://notes.jay-waves.cn/math/numth/%E5%BF%AB%E9%80%9F%E6%A8%A1%E5%B9%82%E7%AE%97%E6%B3%95/")[快速模幂算法]. 计算 $[n]P$ 时, 复杂度约为 $cal(O)(M(n) dot log n)$.

```txt
R0 = P
R1 = 2 * P
if k_i == 0:
  R1 = R0 + R1
  R0 = 2 * R0
if k_i == 1:
  R0 = R0 + R1
  R1 = 2 * R1
```

= 素域上的椭圆曲线

密码学更关心离散问题, 因此密码学将椭圆曲线定义到有限域上:
1. 素域 #GF($p$), 同构于 $bb(Z)_p$.
2. 扩域 #GF($p^n$), 元素为多项式, 更适合硬件算法.

密码学椭圆曲线仍定义为:
$
Y^2 = X^3 + a X + b
$
其中 $X, Y$ 为有限域上的元素.
$+$ 和 $dot$ 是有限域上的运算, 数乘和幂运算分别是加法和乘法的衍生运算.

== 点集群

#theorem[
  椭圆曲线在有限域 $bb(Z)_p$ 上的点集构成一个 Abel 交换群.
]

#proof[
  - 封闭性: 由点加法定义显然.
  - 有单位元: $bold(P) + #O = #O + bold(P) = bold(P)$.
  - 有逆元: $bold(P) + (-bold(P)) = #O$.
  - 结合律: $bold((P + Q) + R) = bold(P + (Q + R))$.
  - 交换律: $bold(P + Q) = bold(Q + P)$.
]

=== 点集群的阶

该点集群的阶即素域 $bb(Z)_p$ 上椭圆曲线的点个数.
由于 $x$ 的整数性不保证 $y$ 的整数性, 所以并非素域上所有 $x$ 值都能由垂直 $x$ 轴直线映射到一个椭圆曲线上的点 $(x, y)$, 其中 $x, y in bb(Z)_p$.
因此椭圆曲线上的群的阶不一定是 $p$.

为了验证素域上元素满足映射 $phi: x -> (x, sqrt(x^3 + a x + b))$, 需要遍历素域, 然后验证 $x^3 + a x + b$ 是否是模 $p$ 的二次剩余, 即是否存在整数 $y$ 满足 $y^2 = x^3 + a x + b mod p$.

由 Hasse 定理知, 素域上的椭圆曲线点集群的阶满足:
$
|E(bb(Z)_p)| = p + 1 - t, quad |t| <= 2 sqrt(p).
$
说明其最小为 $|E(bb(Z)_p)| = (sqrt(p) - 1)^2$.

当点总数 $|E(bb(Z)_p)|$ 是素数时, 该群就是一个循环群. 否则是多个循环群的直积, 显然密码学对前者更感兴趣.

=== 子群的阶与基点 G

ECC 选择 $G$ 时, 需选一个阶比较大的点, 以保证有足够的私钥 $d$.

见 #link("https://notes.jay-waves.cn/sec/cryptography/public-key-crypto/ecc/ECC/")[ECC].

子群阶 to be continue...

=== ECDLP

椭圆曲线上的离散对数问题定义为: 给出点 $bold(P)$ 和数乘 $n bold(P)$, 求出 $n$ 是困难的.
目前最快的 ECDLP 算法也需要 $cal(O)(sqrt(p))$ 求解.

= 参考

注意, 图片可能包含未知版权信息.
- #link("https://www.ruanx.net/elliptic-curve/")[有限域上的椭圆曲线 by Ruan Xingzhi]
- #link("https://zh.wikipedia.org/wiki/%E6%A4%AD%E5%9C%86%E6%9B%B2%E7%BA%BF")[椭圆曲线]
- #link("https://en.wikipedia.org/wiki/Elliptic_curve_point_multiplication")[Elliptic curve point multiplication]
