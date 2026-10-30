#import "@local/ypst-template:0.1.0" as theme
#import theme: theorem, definition, diagram, node, edge

#set document(
  title: [IMU Driven Systems],
  date: datetime.today(),
  keywords: ("robotics", "imu", "kinematics", "quaternion")
)

#show: theme.template

#let bmat(..args) = math.mat(delim: "[", ..args)
#let vecb(x) = math.upright(math.bold(x))

= Inertial Measurement Unit (IMU)

IMU 集成了加速度计（Accelerometer）和陀螺仪（Gyrometer），提供刚体 (IMU) 坐标系下测量的加速度 $a_m$ 和角速度 $omega_m$。

直接由 IMU 积分计算出的姿态信息，称为刚体的*名义状态*（标称状态、Nominal State），随时间会产生误差（飘移），需要修正。
通过融合其他传感器信息（如 GPS 或视觉），可以减少和修正飘移。常见技术有 ESKF 或 Factor Graph。
常见的观测传感器有：

#theme.sidenote[
  - VIO: Camera + IMU + Slided Windows 
  - LIO: LiDAR (激光雷达) + IMU + ESIKF (IEKF) 。
  - GNSS + IMU 
  - Radar + IMU。Radar 是无线电波雷达。
][
  Radar 发射的无线电波、毫米波，比光的频率低很多，容易测量。因此，可以利用多普勒效应来测量径向速度
]

#let r1 = (
  [Full state], [$vecb(x)_t$], [$vecb(x)$], [$delta vecb(x)$], [$vecb(x)_t = vecb(x) plus.o delta vecb(x)$], [], [],
)

#let r2 = (
  [Position], [$vecb(p)_t$], [$vecb(p)$], [$delta vecb(p)$], [$vecb(p)_t = vecb(p) + delta vecb(p)$], [], [],
)

#let r3 = (
  [Quaternion], [$vecb(q)_t$], [$vecb(q)$], [$delta vecb(q)$], [$vecb(q)_t = vecb(q) plus.o delta vecb(q)$], [], [],
)

#let r4 = (
  [Rotation Matrix], [$R_t$], [$R$], [$delta R$], [$R_t = R delta R$], [], [],
)

#let r5 = (
  [Accelerometer bias], [$vecb(a)_(b t)$], [$vecb(a)_b$], [$delta vecb(a)_b$], [$vecb(a)_(b t) = vecb(a)_b + delta vecb(a)_b$], [], [$vecb(a)_omega$],
)

#let r6 = (
  [Gyrometer bias], [$vecb(omega)_(b t)$], [$vecb(omega)_b$], [$delta vecb(omega)_b$], [$vecb(omega)_(b t) = vecb(omega)_b + delta vecb(omega)_b$], [], [$vecb(omega)_omega$],
)

#let r7 = (
  [Gravity vector], [$vecb(g)_(b t)$], [$vecb(g)_b$], [$delta vecb(g)_b$], [$vecb(g)_(b t) = vecb(g)_b + delta vecb(g)_b$], [], [],
)

#let r8 = (
  [ Acceleration], [$vecb(a)_t$], [], [], [], [$vecb(a)_m$], [$vecb(a)_n$],
)

#let r9 = (
  [Angular rate], [$vecb(omega)_t$], [], [], [], [$vecb(omega)_m$], [$vecb(omega)_n$],
)

#table(
  columns: 7,
  table.header(
    [Magitude], [True], [Nominal], [Error], [Composition], [Measured], [Noise],
  ),
  ..r1,
  ..r2,
  ..r3,
  ..r4,
  ..r5, 
  ..r6,
  ..r7, 
  ..r8,
  ..r9,
)

== 典型的 IMU 测量原理

陀螺仪：

$ omega_m = omega_t + omega_"bt" + omega_n $

- $omega_t$ 是真实角速度
- $omega_"bt"$ 是陀螺仪的物理偏差 (bias)，是由于器件不理想导致的零位偏置 (offset)，是持续存在可估计的系统误差。
  由于该值持续存在，会导致积分计算位姿 $T = (p, R)$ 有随时间线性增长的*偏移（drift）*。
- $omega_n$ 是陀螺仪的测量噪声误差 (noise)，在每个采样时刻快速变化，不可直接估计的随机扰动。
- $omega_m$ 是 IMU 实际测量的角速度

同理，加速度：

$ a_m = a_t + a_"bt" + a_n $

注意，这里用了 "bt" 而不是 "b"，因为滤波器对 bias 的估计（名义值）也不是准确的 ：

$ a_"bt" = a_b plus.o delta a $ <eq:bias>

#theme.sidenote[
  bias 并不是常量，仍然会随时间缓慢随机改变，因此建模为白噪声 $a_w$ 驱动的随机游走：

  $ dot(a_"bt") = a_w,quad E[a_w] = 0 $

  作为对比，噪声误差 $a_n$ 本身是高斯分布的，随着时间的累计基本为零。

  $ a_n ~ cal(N)(0, sum_n),quad E[a_n] = 0 $
][
  可以理解为：bias 是持续存在的偏置量，并且随时间缓慢移动；noise 是快速变化的噪声，和时间无关。
]

=== 姿态表达 (orientation)

IMU 的测量值是相对刚体坐标系的，因此旋转量 $R$ 表达从刚体坐标系 $BB$ 到
世界坐标系 $WW$ 的姿态变换（orientation）。

旋转可以用旋转矩阵 $R$ 或四元数 $q$ 表示，两者是完全等价的。#footnote[详情参考刚体力学：`./rigid-bodies.typ`]
- 测量值等价 $ q_m <==> R_m $
- 误差等价（$delta theta$ 是一个微小旋转） $ delta q = exp(delta theta \/ 2) <==> delta R = exp([delta theta]_times) $
- 真实值等价 $ q_t = q times.o delta q <==> R_t = R delta R $

默认情况下，$w, v, p, g$ 等物理量都在 $WW$ 世界坐标系中表示，有加速度公式：

$ dot(v) = R a_t + g = R(a_m - a_b - a_n) + g $

其中 $a_"xxx"$  是 IMU 在 $BB$ 刚体坐标系的测量量，通过 $R$ 旋转到世界坐标系。

=== 四元数处理

误差很小时，四元数误差可用三维旋转向量 $Delta theta$ 表示：

#let ddelta = $Delta theta$

$
delta vecb(q) = exp((ddelta) / 2)

= bmat( cos(norm(ddelta)\/2); ddelta/norm(ddelta) sin(norm(ddelta)\/2) )

approx bmat(1; 1/2 ddelta)
$


因此：

$ q(t+upright(d) t) = q(t) times.o delta q,quad delta q tilde.eq bmat(1; 1/2 ddelta) $ 

由于 $ddelta = w "d"t$, 得到：

$ q(t + upright(d)t) = q(t) times.o (bmat(1; 0) + bmat(0; 1/2 ddelta)) =q(t) + q(t) times.o 1/2 bmat(0; omega) upright(d)t  $

于是：

$ dot(q(t)) = (q(t+ upright(d)t) - q(t))/ (upright(d)t) = 1/2 q(t) times.o bmat(0; omega) $

=== 微分 

旋转的累积：

$ R_(k+1) = R_k e^([w_k "d"t]) approx R_k (I + [w_k "d"t]) $

$ q_(k+1) = q_k times.o delta q = q_k times.o bmat(cos(theta/2); (w_k "d"t)/theta sin(theta/2)) $

注意，因为 $ddelta = w "d"t$，可知，

$ R(t + "d"t) = R(t) e^([ddelta]) = R(t) e^([w]"d"t) approx R(t)(I + [w]"d"t) $

$ dot(R) = (R(t + "d"t) - R(t))/("d"t) approx R(t) [w] $ <eq:dotR>

位置与速度的累计：

$ p_(k+1) = p_k + v "d"t + 1/2 (R(a_m - a_n - a_b) + g)"d"t^2 $

$ v_(k+1) = v_k + (R(a_m - a_n - a_b) + g) "d"t $


== ESKF (fusing IMU with sensors)

=== 名义状态建模

IMU 状态建模：（$g$ 用于对齐世界坐标系，除此外的其他量均位于 $BB$ 体坐标系）

$
x = bmat(p, v, q, a_b, w_b, g)^top
$

IMU 输入为： 

$ u_m = bmat(a_m ; w_m) $

#definition[Nominal State：

$
&dot(p) && = v, \
&dot(v) &&= R(q) (a_m - a_b) + g, \
&dot(q) &&= 1/2 q times.o (w_m - w_b), \
&dot(a)_b && = 0, \
&dot(w)_b && = 0, \
&dot(g) &&= 0
$

]

重力加速度 $g$ 被认为短时间不变，初始时，将世界坐标系的 $z$ 轴和 $g$ 方向对齐。
由 IMU 信息计算出的名义状态，既不知晓偏移误差 $a_b$ 的真实值（存在 $delta a_b$），也不知晓
噪声的真实值 $delta a_n$，所以名义状态传播时另它们为零。


=== 误差状态建模

上文 @eq:bias 提到，$a_b, w_b$ 均为名义值，和真实状态之间，存在误差 $delta a_b, delta w_b$ 等。
另外需要注意的是，这个误差是真实存在的，但是我们无法获得这个误差的准确值，所以 ESKF 的目的，就是
对这个误差值进行估计和修正。

#definition[Error State: #footnote[详细推导见 @sola2017 P58-60, ESKF 的标准卡尔曼滤波形式见 P61]

$
&dot(delta p) && = delta v, \
&dot(delta v) &&= -R [a_m - a_b] delta theta - R delta a_b - R a_n + delta g,\
&dot(delta theta) &&= -[w_m - w_b]delta theta  - delta w_b - w_n,\
&dot(delta a)_b && = a_w, \
&dot(delta omega)_b && = omega_w, \
&dot(delta g) &&= 0
$ <eq:ESKF>

]

==== @eq:ESKF $dot(delta v)$

不妨令 $a = a_m - a_b$，有：

$ dot(v)_t = R_t (a - delta a_b - a_n) + g + delta g,quad R_t approx R(I+[delta theta]) $

忽略二阶无穷小量：

$ dot(v)_t approx R a + R[delta theta]a- R delta a_b - R a_n + g + delta g $

两侧约掉名义量 $dot(v) = R(a) + g$，得到：

$ 
dot(delta v) &= R[delta theta]a- R delta a_b - R a_n + delta g \ 
& = -R[a]delta theta - R delta a_b  - R a_n + delta g
$

#linebreak()

上式等价于：

$
dot(delta v) &= delta (R a) + delta g \ 
&= - R[a]delta theta + R delta a + delta g, \
delta a &= -delta a_b - a_n
$

==== @eq:ESKF $dot(delta theta)$

将 $R_t approx R(I + [delta theta])$ 同乘 $R^top$ ，得到：

$ Delta R = R^top R_t approx I + [delta theta] $ <eq:DR>

不妨令 $w = w_m - w_b$。因为 @eq:dotR ，得到：

$
dot(R^top) &= -[w]R^top \
dot(R_t) &= R_t [w_t] = R_t [w - delta w_b - w_n] 
$

代入 @eq:DR 中，得到：

$ 
dot(delta theta) = -[w] delta theta + delta w, quad delta w = - delta w_b - w_n
$

==== @eq:ESKF  $dot(delta a)_b,quad dot(delta omega)_b$

偏置（bias）是一个缓慢的随机游走：（固定零点偏置，逐帧累计白噪声）

$ dot(a_"bt") = a_w $

偏置的名义值（nominal bias）保持不变（我觉得等价于固定零偏，没有累计噪声）

$ dot(a_b) = 0 $

因为 $a_"bt" = a_b + delta a_b$ ，两侧求导可知：

$ a_w = dot(delta a_b) $

=== Kalman Filter (Predict Stage)

将上述 Error-State 的建模，改写为标准卡尔曼滤波形式（连续时间下）：

$
x = bmat(p; v; q; a_b; w_b; g)_(19 times 1),
quad 
delta x = bmat(
  delta p;
  delta v;
  delta theta;
  delta a_b;
  delta omega_b;
  delta g
)_(18 times 1),
quad 
u_m = bmat(
  a_m;
  w_m
)_(6 times 1),
quad
n = bmat(
  a_n;
  omega_n;
  a_w;
  omega_w
) 
$

其中噪声源的协方差（假设所有噪声都是 $E[x] = 0$ 的）：

$
Q_c = "Cov"(n, n) = E[n n^top] 
$

误差状态转移矩阵：

$
F = bmat(
  0, I, 0, 0, 0, 0;
  0, 0, -R [a], -R, 0, I;
  0, 0, -[w], 0, -I, 0;
  0, 0, 0, 0, 0, 0;
  0, 0, 0, 0, 0, 0;
  0, 0, 0, 0, 0, 0
)
$

噪声输入矩阵：

$
G = bmat(
  0, 0, 0, 0;
  -R, 0, 0, 0;
  0, -I, 0, 0;
  0, 0, I, 0;
  0, 0, 0, I;
  0, 0, 0, 0
)
$

迭代方式 (连续时间)：

#theme.sidenote[
  $
  delta x^- &<- F dot delta x^+ + G n 
  $
][

  这里 $F, G$ 不过是用于转换坐标系的雅各比矩阵而已。
]

卡尔曼滤波#footnote[卡尔曼滤波详见 `./cybernetics/kalman-filter.typ`]一般要求在离散时间进行迭代，
参考信号采样方法#footnote[推导详见 `./cybernetics/sampling.typ` 和 `./cybernetics/kalman-filter.typ` 文末 ]，
设采样时间 $Delta t$，在区间内冻结瞬时变化 $F, G, Q_c$ ，积分得到：

$ delta x_(k+1) = Phi_k delta x_k + omega_k,quad Phi_k = e^(F_k Delta t) $

其中 $w_k$ 是这段时间的噪声 $n$ 的作用，其协方差（近似）为：

$ Q_(d,k)approx G_k Q_c G_k^top Delta t $

因此，预测阶段：

  $
  delta x^- &<- Phi delta x^+ + omega \
  P^- &<- Phi P^+ Phi^top + Q_d
  $


=== Kalman Filter (Update Stage)

观测到带噪的传感器信号：

$ z = h(x_t) + v,quad v~ cal(N)(0,V) $

在名义状态 $x$ 附近展开：

$ z approx h(x) + H delta x + v, quad H =
attach(
  lr(
    (partial h(x plus.o delta x ))/(partial delta x) |
  ), 
  b: delta x = 0,
) 
$ <eq:H>

因此 KF 的观测残差为：

$ r = z - h(x) approx H delta x + v $

修正状态：

$ 
K &= P^- H^top (H P^- H^top + V)^(-1) \
delta x^+ &<- K r \
P^+ &<- (I- K H)P^- 
$

随后将 KF 修正后的误差注入名义状态：

$
x <- x plus.o delta x^+
$

==== @eq:H

用链式法则展开 $H$ ：

$
H = 
attach(
  lr(
    (partial h(x_t))/(partial delta x) |
  ), b: x,
) =
attach(
  lr(
    (partial h(x_t))/(partial x_t) |
  ), b: x_t = x,
) 
attach(
  lr(
    (partial x_t)/(partial delta x) |
  ), b: delta x -> 0,
) 
= H_x X_(delta x)
$

其中，

$
X_(delta x) = 
attach(
  lr(
    (partial (x plus.o delta x))/(partial delta x) |
  ), b: delta x -> 0,
) =
op("diag")(
  frac(partial p_t, partial delta p),
  frac(partial v_t, partial delta v),
  bold(frac(partial q_t, partial delta theta)),
  frac(partial a_"bt", partial delta a_"b"),
  frac(partial w_"bt", partial delta w_"b"),
  frac(partial g_t, partial delta g),
)
$

值得注意的是 $J_q = partial q_t slash partial delta theta$ 这一项，

$
q = bmat(q_w; q_v), quad 
delta q approx bmat(1; 1/2 delta theta), quad
q_t = q times.o delta q = 
attach(
  lr(bmat(
    q_w - 1/2 q_v^top delta theta; 
    q_v + 1/2(q_w I + [q_v])delta theta
  )),
  b: delta theta -> 0
)
$

$
J_q = attach(
    (partial q_t)/(partial delta theta),
    b: 0
) = 1/2 bmat(
    - q_v^top;
    q_w I + [q_v]
) in RR^(4 times 3)
$

#let derivhx = $frac(partial h(x_t), partial x_t)$

另一项，$derivhx$ 由传感器的观测模型直接决定，

比如：
- GPS 的观测函数为： $ h(x_t) = p_t = p + delta p, quad derivhx = bmat(I_3, 0_(3 times 16)) $
- 测量到固定信标的距离：$ h(x_t) = d = norm(p_t - a), quad derivhx = bmat(frac((p-a)^top, norm(p-a)), 0_(1 times 16)) $

=== Reset 

在 Update 状态，我们将估计出的误差 $delta x^+$ 注入名义值 $x$ 对其修正。

$ x^+ = x^- plus.o delta x^+ $

修正后，名义值和真实状态的误差不再是 $delta x$（注意这是实际误差），变成了一个新值。
因此需要重置我们的误差估计。

$ x_t = x^- plus.o delta x = x^+ plus.o delta x_"new" $

定义 $delta x_"new" = f(delta x) = (x^- plus.o delta x)minus.o x^+$ ，
#footnote[注意这里的运算需要考虑四元数，不能交换。但是大意就是：$f(delta x) = (x^- + delta x)-x^+= delta x - delta x^+$]
$f(delta x^+) = 0$，在接近 $delta x^+$ 处一阶展开得到：

$
  delta x_"new" approx J_"reset" (delta x - delta x^+) ,quad 
  J_"reset" eq.def attach(
    lr(frac(partial f, partial delta x)|),
    b: delta x = delta x^+
  )
$

记 $e^+ = delta x - delta x^+, quad delta x_"new" = J_"reset" e^+$，新的协方差为：

$
  P_"new"
    &approx E[(J_"reset" e^+)(J_"reset" e^+)^top] \
    &= J_"reset" E[e^+ e^+^top] J_"reset"^top \
    &=J_"reset" P^+ J_"reset"^top
$

*在注入误差，并修正 $P$ 之后，丢弃估计值 $delta x^+$ ，在下一轮迭代中重新计算*。因此，Reset 阶段的实际工作是：

$
  delta x &<- 0 \
  P &<-  J_"reset" P^+ J_"reset"^top
$

至此，ESKF 的总体流程如下：

#align(center, diagram(
  node((0, 0), align(center)[
    Previous State \
    $x^+, P^+$
  ]),
  node((0, 1), [
    IMU (KF) Predict \
    $x^-, delta x^-, P^-$
  ]),
  node((0, 2), align(center)[
    Residual and Jacobian \
    $r = z - h(x^-), quad H$
  ]),
  node((0, 3), align(center)[
    Kalman Update \
    $delta x^+ = K r$ \
    $P^+ = (I - K H) P^-$
  ]),
  node((0, 4), align(center)[
    Error Injection \
    $x^+ = x^- plus.o delta x^+$
  ]),
  node((0, 5), align(center)[
    Reset Error Estimate \
    $P <- J_"reset" P^+ J_"reset"^top$ \
    $delta x <- 0$
  ]),

  node((-1, 1), [
    IMU Measurements\
    $a_m, w_m$
  ]),
  node((-1, 2), align(center)[
    Sensor Observation \
    $z$
  ]),
  node((1, 5), align(center)[
    Output \
    $x^+$
  ]),

  edge((0, 0), (0, 1), "-|>"),
  edge((0, 1), (0, 2), "-|>"),
  edge((0, 2), (0, 3), "-|>"),
  edge((0, 3), (0, 4), "-|>"),
  edge((0, 4), (0, 5), "-|>"),

  edge((-1, 1), (0, 1), "-|>"),
  edge((-1, 2), (0, 2), "-|>"),
  edge((0, 5), (1, 5), "-|>"),

  // Return to the next prediction cycle.
  edge((0, 5), "l,l,u,u,u,u,u,r,r", "-|>"),
))

// ---------------------------------------

//TODO == 离散化（离散采样）

//TODO == Factor Graph 


#bibliography("./BIBLIO.bib")
