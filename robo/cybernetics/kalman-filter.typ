
#import "@local/ypst-template:0.1.0": template, sidenote, theorem, definition

#show: template

= Kalman Filter 

卡尔曼滤波实际是一种*迭代*求解线性系统二次优化（最小方差估计）的方法。
在实际工程中，通常面临：系统建模不精确，传感器观测（修正）有噪声或偏差，很难估计系统当前的状态。
卡尔曼滤波提供了一种建模方法，在“建模”和“测量”之间做动态最优化融合。#footnote[一个常见的例子是 IMU 姿态传感器，详见 `../imu.typ`]

卡尔曼滤波始终在融合两个信息：建模预测值 $x_k^-$ ，传感器观测值 $z_k$ 

修正方式为：

$ x_k^+ = x_k^- + K_k (z_k - H x_k^-) $

其中 $K_i$ 是每次迭代的最优权重，被称为_卡尔曼增益（Kalman Gain）_。

#figure(
  image("../../attach/img/robo/kalman-filter-wiki.png", width: 50%),
  caption: link("https://en.wikipedia.org/wiki/Kalman_filter")[Kalman Filter -- Wikipedia],
)

== 线性系统建模

系统的状态传播：（真实世界）

$
  x_k^- = F_k x_(k-1)^+ + B_k u_k + w_k 
$

系统的估计传播：（预测值）

$
  x_k^- = F x_(k-1)^+ + B u_k
$

#sidenote[
- *$x_i^+$ 是观测后修正后结果，$x_i^-$ 是模型估计结果，$x_i$ 是实际值。*
- $F_k$ 是状态转移矩阵
- $B_k$ 是控制输入，$u_k$ 是控制向量。目前没有接入控制器，不关心。 
- $w_k$ 是状态转移过程的噪声，一般假设 $w_k ~ cal(N) (0, Q_k)$
][
  注意区分，$w$ 是状态转移噪声，$v$ 是传感器观察误差。
  KF 的迭代公式是固定的，但是 $F$ 建模比较困难。
]

== Kalman Gain 

设真实状态和建模预测之间的误差为：$ e^- = x - x^- $

每次测量时，传感器读数 $z$ 和真实状态间存在测量噪声 $v$: $ z = H x + v $

其中
- $H$ 只是映射矩阵，将建模空间映射到测量空间
- $v ~ cal(N)(0, R)$ , 协方差矩阵 $"Cov"(v) = R$ 越大，传感器噪声范围越宽，越不可信。

由于噪声的存在，测量无法直接获得 $x$，含有一个（误差）噪声 $v$。
定义测量残差为：

$ r = z - H x^- = H(x - x^-) + v = H e^- + v $

#sidenote[
  $r$ 和 $e^-$ 紧密相关，我们希望通过 $r$ 来估计实际的 $e^-$ ，从而估计真实状态 $x$ 。
  由于用 $r$ 估计 $e^-$ 时有误差，因此得到的结果 $x^+$ 和真实 $x$ 也有误差。

  Kalman 使用 $K r$ 来逼近 $e^-$ 。设 $e^+ = e^- - K r = x - x^+$ ，取 $e^+$ 的最小方差估计：
][
  注意 $e^+$ 是向量，没有“最小”的定义，需要看它的统计量。
]

$ limits("min")_K P^+ = limits("min")_K  E[norm(e^+)^2] = limits("min")_K E[norm(e^- - K r)^2] $

最小方差估计问题的最优性条件为（最优估计下，误差 $e^+$ 已经和 $r$ 没有线性相关性）： 

$ E[e^+ r^top] = 0 $

得到 $ E[(e^- - K r) r^top ] = E[e^- r^top] - K E[r r^top] = 0 $

*因此 $ K = E[e^- r^top](E[r r^top])^(-1)  = "Cov"(e^-, r)"Cov"(r)^(-1) $*

$"Cov"(e^-, r)$ 是状态误差和 $r$ 的相关性，展开可得（过程略）：

$ "Cov"(e^-, r) = E[e^- e^-^top] H^top = P^- H^top  $


$S="Cov"(r)$ 是 $r$ 本身的稳定性（可靠程度、置信度），展开可得：

$
  S 
    &= "Cov"(r) \
    &= H E[e^- e^-^top] H^top + "Cov"(v) \ 
    &= H P^- H^top + R
$

最终有：

$ K = P^- H^top (H P^- H^top + R)^(-1) $

当 $e^-$ 和 $r$ 的相关性大时，K 

== 迭代过程

一次迭代分为 Predict 和 Update 两个过程。

=== 预测阶段（Predict）

模型迭代（忽略控制项）：

$ x_k^- = F_k x_(k-1)^+ + w_k $

#let ek1 = $e_(k-1)$
#let xk1 = $x_(k-1)$
#let Mo(x, y: none) = {
  if y == none {
    $cal(M)[#x]$
  } else {
    $cal(M)[#x, #y]$ }
}

不确定性传播 (注意 $"Cov"(e^+, w) = 0$，定义二阶矩符号 $cal(M)(x) eq.def E[x x^top]$ ）：

$ 
  P_k^- 
    & = Mo(e_k^-) = Mo(x_k - x_k^-) \
    & = Mo(F xk1 + w - F xk1^+)\
    & = Mo(F ek1^+ + w_k) \
    & = F Mo(ek1) F^top + Mo(w) \
    & = F_k P^+_(k-1) F_k^top + Q_k 
$

得到 $(x_k^-, P_k^-)$ ，接下来通过观测值进行修正。

=== 修正阶段（Update）

首先修正状态 #footnote[由于不涉及迭代，这里忽略掉迭代下表 $k$ ，即 $x_k$ 记为 $x$。] ：

$
  x^+ 
  &= x^- + K r \
  &= x^- + K (z - H x^-) 
$

修正协方差（不确定性），注意 $"Cov"(e^-, v) = 0$：

$
  P^+ 
    & = Mo(e^+) \
    & = Mo((I-K H)e^- - K v) \
    & = (I-K H) Mo(e^-) (I-K H)^top + K Mo(v) K^top \
    & = (I - K H) P^- (I- K H)^top + K R K^top 
$

此公式称为Joseph Form。此形式就像一种 $(1-k)x + k y$ 的线性插值。

#quote[
还有一种简洁形式。可以证明：

$
  P^+
    & = (I - K H) P^- (I- K H)^top + K R K^top \
    & = (I - K H) P^-
$

在有限精度浮点数迭代计算中，该形式不具备数值稳定性。（暂且搁置）
]

最终，得到 $(x^+_k, P_k^+)$ 后，即可进入下一轮。

== 总结

#let cov = math.op("Cov")

定义估计误差 $e^plus.minus = x - x^plus.minus$。
假设噪声零均值，且与相应的先验误差不相关。

=== Predict

预测状态（这里 $x^+$ 是上一轮修正后的状态）：

$
  x^- <- F x^+ + w
$

传播误差协方差：

$
  cov(e^-) <- F cov(e^+) F^top + cov(w)
$

=== Update

计算观测残差：

$
  r <- z - H x^-
$

计算残差协方差与交叉协方差：

$
  cov(r) <- H cov(e^-) H^top + cov(v) \
  cov(e^-, r) <- cov(e^-) H^top
$

计算卡尔曼增益：

$
  K <- cov(e^-, r) cov(r)^(-1)
$

修正状态：

$
  x^+ <- x^- + K r
$

更新剩余误差协方差：

$
  cov(e^+) <- (I - K H) cov(e^-) (I - K H)^top
    + K cov(v) K^top
$

= Appendix

== 一维卡尔曼滤波

系统状态模型：

$ x_k = xk1 + w_k ,quad w_k ~N(0, Q) $

测量模型：

$ z_k =  x_k + v_k, quad v_k ~ N(0, R) $

其中：
- $F = 1$
- $B u_k = 0$ 
- $H = 1$

预测过程：

$ 
  x_k^- &= x_(k-1)^+ + w_k \
  P_k^- &= P_(k-1)^+ + Q
$


卡尔曼增益：

$
  K = P_k^-/(P_k^- + R)
$

修正过程：

$
  x_k^+ 
    &= x_k^- + K r \
  P_k^+ 
    &= (I- K) P_k^- \
    &= 1/P_k^- + 1/R
$

$P$ 是当前估计的置信度，$R$ 是测量噪声。当 $R->0$ 时，有 $P^+->0$ ，估计几乎完全确定。
当 $R->infinity$ 时，测量噪声的范围太大，有 $P^+->P^-$ ，此时测量基本不起作用。

== 连续时间下的卡尔曼滤波形式

根据线性系统#footnote[详见采样与系统离散化 `./sampling.typ`]的离散化关系，
有：$ F = e^(A Delta t) approx I + A Delta t $

代入离散协方差公式：

$ P_(k+1) 
  & = (I+ A Delta t )P_k (I + A Delta t)^top + Q_d \
  & = P_k + (A P_k + P_k A^top) Delta t + A P_k A^top Delta t^2 + Q_d 
$

其中 $Q_d approx Q_c Delta t$ ，详细解释见下文 @appx:qc

忽略二阶项得到：

$
  dot(P) = frac(P_(k+1) - P_k, Delta t) approx A P_k + P_k A^top + Q_c
$

=== 噪声项的处理 <appx:qc> 

确定性的时不变系统中，没有 KF 需要考虑的 $w_c(t)$ 白噪声。因此 $Q_d$ 项需要额外处理。

对于白噪声 $w_c$ ，它在不同时刻是不相关的，即：

#sidenote[
  $
    E[w_c(t) w_c(tau)^T] = Q_c delta(t - tau),
  $

  离散过程噪声是把这一整段连续噪声累积起来：

  $
    w_k
    = integral_0^(Delta t)
      e^(A(Delta t - tau)) w_c(tau)
      dif tau.
  $

][
   Dirac Delta 函数满足：

  $
    delta(t) = 0, quad t != 0
  $

  $
    integral_(-infinity)^infinity delta(t) dif t = 1
  $

  筛选性质：

  $
    integral f(t) delta(t - t_0) dif t = f(t_0)
  $ 
]

然后计算

$
  E[w_k w_k^T] & = Q_d
  = integral_0^(Delta t) e^(A tau) Q_c e^(A^top tau) dif tau \
  &approx integral_0^(Delta t) (I+ A tau) Q_c (I + A^top tau) dif tau \
  &approx integral_0^(Delta t) [Q_c + (A Q_c + Q_c A^top) tau] dif tau
  & Q_c Delta t
$

所以有近似结果 $Q_d approx Q_c Delta t$ 。


