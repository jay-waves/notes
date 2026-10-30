#import "@local/ypst-template:0.1.0": template, sidenote

#show: template
#let bmat(..args) = math.mat(delim: "[", ..args)
#let vecb(x) = math.upright(math.bold(x))

#quote[
  来源：#link("https://github.com/Krasjet/quaternion")[四元数于三维旋转]，Krasjet，CC BY-NC-SA 4.0。
]


= 复数

复数 $a + b i$ 同构映射于矩阵形式：

$
bmat(a, -b; b, a)
$

如：

$
i arrow.l.r bmat(0, -1; 1, 0)
$

记复平面 $z = a + b i$ 与 $Re$ 的正方向夹角为 $theta$，那么：

$ cos theta &= a / sqrt(a^2 + b^2) \
 sin theta &= b / sqrt(a^2 + b^2) $

记 $abs(z) = sqrt(a^2 + b^2)$，复数的同构矩阵可表示为_缩放矩阵_与_旋转矩阵_的乘积：

$
z = abs(z) dot I dot bmat(cos theta, -sin theta; sin theta, cos theta)
  = bmat(abs(z), 0; 0, abs(z))
    dot bmat(cos theta, -sin theta; sin theta, cos theta)
  = abs(z) e^(i theta)
$

因此，一个复数可以表达一次旋转与缩放的线性变换。

= 轴角式旋转

设经过原点的旋转轴 $vecb(u) = (x, y, z)^T$ 满足 $norm(vecb(u)) = 1$，给定向量 $vecb(v)$，使其沿着旋转轴转动 $theta$ 角度，得到 $vecb(v)'$。这里使用右手系统来定义旋转正方向。

轴角旋转有三个#link("https://notes.jay-waves.cn/robo/rigid-bodies/")[自由度]：一个表示 $theta$，两个表示单位向量 $vecb(u)$。

#image("../attach/img/robo/robo-quaternion-axis-rotation.webp", width: 70%)

将向量 $vecb(v)$ 沿垂直于轴 $vecb(u)$ 和平行于轴的两个方向分解为 $vecb(v)_1, vecb(v)_2$。平行分量 $vecb(v)_1$ 在旋转后保持不变，垂直分量旋转后变为：

$
vecb(v)'_2 = cos theta dot vecb(v)_2 + sin theta dot (vecb(u) times vecb(v)_2)
$

由于：

$ vecb(v)_2 times vecb(u) = vecb(v) times vecb(u) $

$ vecb(v)_1 = (vecb(u) dot vecb(v)) vecb(u), quad vecb(v)_2 = vecb(v) - vecb(v)_1
$

因此，旋转后的向量有_三维旋转公式_ (Rodrigues Formulation)：

$
vecb(v)' =
  cos theta dot vecb(v)
  + (1 - cos theta)(vecb(u) dot vecb(v)) vecb(u)
  + sin theta (vecb(u) times vecb(v))
$

= 四元数

定义四元数 $q in bb(H)$ 满足：

$ q = a + b i + c j + d k = [a, vecb(v)] $

其中：

$
a, b, c, d in bb(R), quad
i^2 = j^2 = k^2 = i j k = -1, quad
vecb(v) = (b, c, d)^T in bb(R)^3
$

四元数的模长：

$ abs(q) = sqrt(a^2 + b^2 + c^2 + d^2) $

纯四元数：

$ q = [0, vecb(x)] $

四元数的共轭：

$ overline(q) = [a, -vecb(v)] $

四元数的互乘不满足交换律，因为叉乘不满足交换律：

$ q_1 times.o q_2 - q_2 times.o q_1 = [0, 2 vecb(x) times bold(y)] $

换言之，当 $vecb(x) parallel bold(y)$ 时，满足：

$ q_1 times.o q_2 = q_2 times.o q_1 $

== Grassmann Product

$
q_1 times.o q_2 = 
  &(a e - (b f + c g + d h)) \
  + &(b e + a f + c h - d g) i\
  + &(c e + a g + d f - b h) j\
  + &(d e + a h + b g - c f) k
$

令向量 $vecb(x) = (b, c, d)^T$，$vecb(y) = (f, g, h)^T$，那么：

$ q_1 = [a, vecb(x)], quad q_2 = [e, vecb(y)] $

$
q_1 times.o q_2 =
  [a e - vecb(x) dot vecb(y),
   e vecb(x) + a vecb(y) + vecb(x) times vecb(y)]
$

$ q times.o overline(q) = overline(q) times.o q = [a^2 + norm(vecb(v))^2, 0] = [norm(q)^2, 0] $

四元数的逆：

$
q^(-1) q = 1, quad
q^(-1) = overline(q) / abs(q)^2
$

纯四元数的积：

$
v times.o u = [0, vecb(v)] dot [0, vecb(u)]
  = [-vecb(v) dot vecb(u), vecb(v) times vecb(u)]
$

== 代数结构

四元数空间是一个#link("https://notes.jay-waves.cn/math/linalg/vectors/linear-transform/")[线性空间]，满足：

$
HH equiv RR plus.o "Im"(HH) equiv RR^4
$

其中，
- 实部 $RR = "span"_RR {1}$  
- 虚部 $"Im"(HH) = "span"_RR {i, j, k}$


需要注意，$"Im"(HH)$ 在四元数乘法下并不封闭，纯四元数相乘可能产生实部。

== 单位四元数

任意单位四元数都可表示为：

$
q = cos theta + sin theta vecb(u)
  = [cos theta, sin theta vecb(u)]
$

其中 $vecb(u)$ 是单位旋转轴向量。

$ abs(q) = 1, quad q^(-1) = overline(q) $

也可以证明：

$ q^2 = q times.o q = [cos(2 theta), sin(2 theta) vecb(u)] $

典型的极值：
- `wxyz=(1, 0, 0, 0)` 不旋转
- `wxyz(-1, 0, 0, 0)` 不旋转
- `wxyz=(0, x, y, z)` 旋转 180D
- `wxyz=(0.7071, x, y, z)` 旋转 90D
- `wxyz=(0, 1, 0, 0)` 绕 X 轴旋转 180D

= 旋转与单位四元数

令 

$ q = [c, s vecb(u)],quad c = cos(phi/2), quad s = sin(phi/2),quad v = [0,vecb(v)] $

展开该项：

$ q times.o v times.o q^(-1) = [0, (c^2 - s^2)vecb(v) + 2s^2 (vecb(u)^top vecb(v))vecb(u) + 2c s(vecb(u)times vecb(v))] $


#sidenote[
利用三角函数公式，也能得到三位旋转公式：

$ vecb(v)' = cos phi vecb(v) + (1-cos phi)(vecb(u)^top vecb(v))vecb(u) + sin phi (vecb(u)times vecb(v)) $
][
  其实利用分量 $v_2 = [0, vecb(v)_2],quad v_1=[0,vecb(v)_1]$ 也能推导出来。但很麻烦。
]

== 三维旋转公式

任意向量 $vecb(v)$ 绕单位轴向量 $vecb(u)$ 旋转 $phi$ 度后得到 $vecb(v)'$，在四元数定义下有旋转公式：

$
v' = q times.o v times.o q^(-1) = q times.o v times.o overline(q)
$

也称为单位四元数群对纯四元数的伴随作用，定义为：

$
"Ad"_q (v) := q times.o v times.o q^(-1), quad "Ad"_q (v) in "Im"(HH)
$

其中：

- $q = [cos(phi / 2), sin(phi / 2) vecb(u)] in "Sp"(1)$
- $v = [0, vecb(v)] in "Im"(HH)$

公式变形：

$
v' = "Ad"_q (v_1 + v_2)  = v_1 + "Ad"_q (v_2) 
$

可以证明 $q times.o v_2 = v_2 times.o q^(-1)$，因此有：

$
v' = v_1 + q^2 times.o v_2
   = v_1 + [cos phi, sin phi vecb(u)] times.o v_2
$

== 旋转的复合

设 $q_1, q_2$ 都是单位旋转四元数，可以证明 $q_1^(-1) times.o q_2^(-1) = (q_2 times.o q_1)^(-1)$，因此复合旋转：

$
v'' = "Ad"_q_2 ("Ad"_q_1 (v)) = "Ad"_(q_2 q_1)(v) 
$

向量绕 $q$ 旋转 $theta$，就等于反方向旋转 $2 pi - theta$，实际是同一个旋转，用 $-q$ 表示：

$
"Ad"_q (v) = "Ad"_(-q) (v)
$

为了走“最短路径”，会先求夹角，取 $pi$ 内旋转。

每一个固定旋转轴的单位四元数，可以生成一个子群。这个子群与复指数 $e^(i theta) = cos theta + i sin theta$ 是同构的。#footnote[复指数相关知识见 #link("https://notes.jay-waves.cn/math/calculus/complex-numbers/")[复数]、#link("https://notes.jay-waves.cn/math/calculus/trigonometric/")[三角函数]。] 复指数表示一个平面的旋转。

$
upright("Sp")(1) equiv upright("SU")(2)
$

= 插值

*单位旋转四元数常用于表示一个刚体的旋转姿态（Orientation）*。刚体运动过程中，$q_0$ 表示初始位姿，$q_1$ 表示目标位姿，两者是离散的。
需要用插值，来获取中间状态，完成平滑旋转过渡。

设一个旋转 $Delta q$，那么有：

$
Delta q times.o q_0 = q_1, quad
Delta q = q_1 times.o q_0^(-1)
$

$
q_t = (Delta q)^t times.o q_0
$

注意，由于 $abs(q) = 1$，四元数实际上只有三个自由度。旋转姿态活动于一个超球面内，
但两个姿态 $q_0, q_1$ 和原点共同位于一个平面圆内，因此固定端点并选定路径后，插值只剩 $t$ 一个自由度。

#image("../attach/img/robo/orientation_lerp.webp", width: 50%)

== Slerp 插值

#image("../attach/img/robo/slerp.webp", width: 50%)

设 $q_0, q_1 in "Sp"(1)$ 为单位四元数，并定义四维欧式内积：

$
q_0^top q_1 = a e + vecb(x)^top vecb(y)
$


定义四元数在 $bb(R)^4$ 中的球面夹角：

$
theta = arccos (q_0^top q_1)
$

设插值四元数位于 $q_0, q_1$ 张成的平面内：

$
"Slerp"(q_0, q_1;t) = q_t = alpha q_0 + beta q_1
$

分别与 $q_0, q_1$ 取欧氏内积：

$
cos(t theta) &= alpha + beta cos theta \
cos((1 - t) theta) &= alpha cos theta + beta
$

解得：

$
alpha = sin((1 - t) theta) / sin theta,
quad
beta = sin(t theta) / sin theta
$

实际求解时需要注意两个问题：
- $theta approx 0$ 时，会有数值不稳定
- 由于 $q$ 和 $-q$ 表示同一个旋转，为选取路径最短，若 $d < 0$，可以将其 $q_1$ 取反。

== Squad 插值

Slerp 在两点间对角度进行线性插值，但不能保证端点处*平滑*。假设三个姿态 $q_0, q_1, q_2$，那么 $"Slerp"(q_0, q_1)$ 和 $"Slerp"(q_1, q_2)$ 在 $q_1$ 点不能保证导数连续。

Squad 算法：

$
"Quad"(q_0, q_1, q_2, q_3; t)
  = "Slerp"("Slerp"(q_0, q_3; t), "Slerp"(q_1, q_2; t); 2 t (1 - t))
$

$h(t) = 2 t (1 - t)$ 是一个对称的抛物线权重函数。

= 四元数与李群

2D、3D 旋转矩阵都是#link("https://notes.jay-waves.cn/math/linalg/othogonal-matrix/")[_正交矩阵（Orthogonal Matrix）_]，它们的行列式值为 $1$，代表着旋转；$-1$ 代表反射。

特殊正交群 $"SO"(n)$ (Special Orthogonal Group) 是一种李群，定义为：

$ "SO"(3) = {R in RR^(3 times 3) | R^top R = I, det(R) = 1} $

单位四元数群则定义为： 

$ "Sp"(1) = { q in HH | norm(q) = 1} $ 

并且单位四元数群也是一种李群： 

$ "Sp"(1) tilde.equiv "SU"(2) tilde.equiv S^3  $

但单位四元数不和 $"SO"(3)$ 同构，因为 $q$ 和 $-q$ 映射到同一个旋转，即关系为：

$ "Sp"(1)\/{plus.minus 1} tilde.equiv "SO"(3) $

= 参考资料

#link("https://github.com/Krasjet/quaternion")[四元数于三维旋转]. Krasjet. CC BY-NC-SA 4.0
