#import "@local/ypst-template:0.1.0": template, sidenote
#show: template

#import "@preview/cetz:0.5.2"

#let dtheta = $dot(theta)$
#let ddtheta = $dot.double(theta)$
#let dddtheta = $theta^((3))$

Motion Control 有两种目标：末端执行器位置 $X_d(t)$ 或关节位置 $theta_d(t)$ ，这里主要研究 $theta_d$

= Velocity Input 

速度 $dtheta$ 作为控制系统的直接输出。

== Feedforward Control 

Given a desired joint trajectory: $theta_d(t)$, choose the commanded velocity $dot(theta)(t)$ as:

$ dtheta(t) = dtheta_d (t) $

Since no feedback (sensor data) is needed, _position errors_ will accumulate over time under the feedforward control law.

== P Control (Feedback Control)

_Proportional controller, or P controller_ is defined as: 

$ dtheta(t) = K_p (theta_d (t) - theta(t)) = K_p theta_e (t) $ 

_control gain_ $K_p > 0$.

$ dtheta_e (t) = dtheta_d (t) - dtheta(t) $

== PI Control

PI Controler: 

$ dtheta(t) = K_p theta_e(t) + K_i integral^t_0 theta_e(t)d t $

== Feedforaward + Feedback Control

反馈控制的缺点是，必须要有一个误差，用于启动控制系统。
我们可以根据先验知识，设定一个基准值（前馈值），让控制系统基于该基准值进行控制。

$ dtheta(t) = dtheta_d (t) + K_p theta_e (t) + K_i integral^t_0 theta_e (t) d t $


= Torque & Force Input 

力矩 $tau$ 作为控制系统的直接输出。

#figure(
  image("../../attach/img/robo/torque-control.webp", width: 50%),
  caption: [Modern Robotis, Fig 11.11]
)

设 $M$ 是（标量）转动惯量，$m$ 是单连杆质量，$r$ 是旋转轴到质心的距离，
$tau_"fric"$ 是旋转摩擦力矩，$tau_"dist"$ 是扰动转矩（一般指杆自重和负载产生的力矩）。
#sidenote[
  实际输出的关节力矩为：
][
  单连杆转动惯量的计算方式: \
  $I=sum m r^2$
]

#sidenote[
  $
  tau &= M ddtheta + tau_"dist" + tau_"fric" \
   &= M ddtheta + m g r cos theta + b dtheta
  $
][
  这里的力矩公式没有考虑离心力（科氏力），因此隐含假设是低速或静止模型
]

== PID Control 

$
  tau = K_p theta_e + K_i integral theta_e (t) d t + K_d dtheta_e
$

where $K_d$ is the derivative gain. 

#figure(
  image("../../attach/img/robo/pid-controller.webp", width: 70%),
  caption: "Fig 11.5 Modern Robotics, PID Controller Diagram",
  numbering: none
)

让控制系统输出力矩，追踪总力矩：

$ tau &= M ddtheta + tau_"dist" + tau_"fric" \
 &= K_p theta_e + K_i integral theta_e d t + K_d dtheta_e, quad theta_e = theta_d - theta $

#sidenote[
  *假设是零点控制*，即 $dot.double(theta)_d = dtheta_d=0$，左右同时求导，得到：
  $
    M dddtheta_e + (b+ K_d)ddtheta_e + K_p dtheta_e + K_i theta_e = dot(tau)_"dist" = 0
  $
][
  考虑只有重力情况：$ dot(tau)_"dist" = m g r (-sin theta)dot(theta)=0 $  
]

得到特征方程：

$  $

== PD Control (MIT Mini Cheetach Control)

MIT: PD + Torque Feedforward. 适合接触控制 

在·

= Task-Space Motion Control 

Let $X(t) in S E(3)$ be the configuration of the end-effector, 
$cal(V)_b (t)$ be the end-effetor twist in end-effector frame ${b}$, $[cal(V)_b]=X^(-1)dot(X)$. 

The desired motion is given by $X_d (t)$ and $cal(V)_d (t)$. 
$[A d_(X^-1 X_d)]cal(V)_d$ expresses the feedforward twist $V_d$ in the actual end-effector frame at $X$ ($X_(s b)$), 
rather than the desired end-effector frame $X_d$ ($X_(s d)$)

$ cal(V)_b (t) = [A d_(X^-1 X_d)] cal(V)_d (t) + K_p X_e (t) + K_i integral^t_0 X_e (t) d t $

#sidenote[
  , where $X_e$ is not simply $X_d (t) - X(t)$, but $ [X_e] = log(X^-1 X_d) $
][
  记得 $X$, $cal(V)$ 都是关于 $t$ 的函数，后续不再写 $(t)$ 了。
]



