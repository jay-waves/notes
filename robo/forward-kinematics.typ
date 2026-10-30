#import "@local/ypst-template:0.1.0" as theme 

#import theme: template, sidenote, theorem

#set document(
  title: "机器人运动学",
  date: datetime.today(),
  keywords: ("robotics", "kinematics")
)

#show: template

#import "@preview/physica:0.9.8": pdv

#let screw(i) = $[cal(S)_#i]$
#let mscrewm(i) = $M^(-1) [cal(S)_#i] M$
#let body(i) = $[cal(B)_#i]$
#let Ad = math.op("Ad")

= Forward Kinematics

== D-H

enavit-Hartenberg form:

$ T_04 = T_01 T_(12) T_23 T_34 $

== PoE

=== Space POE Formula

#image("../attach/img/robo/robo-PoE.webp", width: 70%)


Set all joint variables to zero and record the home configuration $M=T(0)$.
Express every joint screw axis *in the fixed space frame* at this zero position. Then

$ T(theta) = e^([cal(S)_1] theta_1)
  e^([cal(S)_2] theta_2) dots
  e^([cal(S)_n] theta_n) M. $

The exponentials appear in joint order from base to end effector.  Although
$cal(S)_i$ is recorded at home, the preceding exponentials automatically move
its physical axis to the current configuration.

=== Body POE Formula

If $T$ carries a screw coordinate frame to the space frame, then

$ T e^([cal(S)]theta)T^(-1)
  =e^(T[cal(S)]T^(-1)theta)
  =e^(["Ad"_T cal(S)]theta). $

then,

$
T(theta)
  &= e^(screw(1)theta_1) dot ... dot e^(screw(n)theta_n) M \
  &= e^(screw(1)theta_1) dot ... dot M e^(mscrewm(n)theta_n) \
  &= e^(screw(1)theta_1) dot ... dot M e^(mscrewm(n-1)theta_(n-1))
     e^(mscrewm(n)theta_n) \
  &= M e^(body(1)theta_1) dot ... dot e^(body(n-1)theta_(n-1))
     e^(body(n)theta_n)
$

$body(i) = mscrewm(i)$, i.e., $cal(B)_i = ["Ad"_M^(-1)]cal(S)_i$

The ordering of the joint variables is unchanged; only the side on which the motion product acts
is different.

== the URDF Format

The URDF (Universal Robot Description Format) is an XML file used by ROS2 to describe
 the kinematics, inertial properties, and link geometry of robots

=== Joints

#sidenote[
*Joints* connect two links: a _parent_ and a _child_ link
  - types: prismatic, revolute, continuous (revolute without joint limits), fixed (virtual joints which doesnot permit any motion)
][
  在后续的运动学中，复杂关节都会被拆分为 1DoF Revolute/Prismatic 关节，这有利于计算。
]
  - _origin frame_: defines the child link frame relative to the parent link frame *in zero position*.
  - _axis_: unit vector along the rotation axis in child link frame.

```xml
<joint name="joint1" type="continuous">
  <parent link="base_link"/>
  <child link="link1"/>
  <origin rpy="0.0 0.0 0.0" xyz="0.0 0.0 0.089159"/>
  <axis xyz="0 0 1"/>
</joint>
```

=== Link

#sidenote[
  The joints describe the kinematics of a robot, the link define tis mass properteis.
  - _origin frame_ describes the position and orientation of a frame at the link's center of mass relative to the link's joint frame
  - _inertia matrix_ ... (inertia matrix is symmetric, it's only necessary to define the terms on and above the diagonal)
][
  Inertia Matrix 详见机器人动力学（dynamics of robots）
]

#sidenote[
```xml
<link name="world"/>

<link name="base_link"/>
  <inertial>
  <mass value="4.0"/>
  <origin rpy="0 0 0" xyz="0.0 0.0 0.0"/>
  <inertia ixx="0.0044" ixy="0.0" ixz="0.0"
            iyy="0.044" iyz="0.0" izz="0.0072"/>
  </inertial>
</link>

<link name="link1"/>
  <inertial>
  <mass value="3.7"/>
  <origin rpy="0 0 0" xyz="0.0 0.0 0.0"/>
  <inertia ixx="0.0102" ixy="0.0" ixz="0.0"
            iyy="0.0102" iyz="0.0" izz="0.0066"/>
  </inertial>
</link>
```
][
  URDF 不支持环结构
]

#sidenote[
  = velocity kinematics & Statics
][
  Statics: 静力学；Dynamics：动力学
]

== Jocabion Matrix

$
bold(x) = bold(f)(bold(theta)),
quad
bold(x) = vec(x_1(t), dots.v, x_n(t)),
quad
bold(theta) = vec(theta_1(t), dots.v, theta_n(t))
$

对时间求导，由链式法则：

$
dot(x_i) = sum_(j=1)^n (partial f_i)/(partial theta_j) dot(theta_j)
$

写成矩阵形式：

$
vec( dot(x_1), dots.v, dot(x_n),)
=
mat(
  pdv(f_1, theta_1), dots.h.c, pdv(f_1, theta_n);
  dots.v, dots.down, dots.v;
  pdv(f_n, theta_1), dots.h.c, pdv(f_n, theta_n);)
vec( dot(theta_1), dots.v, dot(theta_n),)
$

定义 Jacobian：

$
J(bold(theta)) = (partial bold(x))/(partial bold(theta))
= mat(
  pdv(f_1, theta_1), dots.h.c, pdv(f_1, theta_n);
  dots.v, dots.down, dots.v;
  pdv(f_n, theta_1), dots.h.c, pdv(f_n, theta_n);
  )
$

因此：

$
  dot(bold(x)) = J(bold(theta)) dot(bold(theta))
$

#linebreak()

#image("../attach/img/robo/robot-2R.webp", width: 30%)

$
x_1 = L_1 cos(theta_1) + L_2 cos(theta_1 + theta_2) \
x_2 = L_1 sin(theta_1) + L_2 sin(theta_1 + theta_2)
$

对时间 $t$ 求导，得到：

$
vec( dot(x)_1, dot(x)_2) =
mat(
  -L_1 sin(theta_1) - L_2 sin(theta_1 + theta_2),quad, -L_2 sin(theta_1 + theta_2);
  L_1 cos(theta_1) + L_2 cos(theta_1 + theta_2),quad, L_2 cos(theta_1 + theta_2)
)
vec( dot(theta)_1, dot(theta)_2) = J(theta)dot(theta)
$


当且仅当 $det (J) = L_1 L_2 sin theta_2 = 0$ 时，某些方向的末端 速度无法继续由角速度产生。
该情况被称为*奇点 (Singularity)*。

=== Manipulability Ellipsoids


*在运动学奇点，$J$ 不满秩；在靠近奇点处，逆运动学解就已经接近病态。* 奇点可能有两种来源，
第一种是内部关节无法对齐；另一种是超出了作业空间。

实践中，规范化关节速度输入 $norm(dot(theta)) = 1$ ，观察末端执行器状态 $cal(V)$ 。

#sidenote[
对于 $J$ 进行奇异值分解：

$ cal(V) = J dot(theta) = U Sigma V^top dot(theta) $


其中 $Sigma = "diag"(sigma_1, sigma_2, dots)$ 。

由于 $V$ 是正交矩阵，令 $q = V^top dot(theta)$ ，有：

$ norm(dot(theta))^2 = dot(theta)^top dot(theta) = (V q)^top (V q) = q^top q = 1 $

所以有：

$ cal(V) = U Sigma q $

令 $y = U^top cal(V) = Sigma q$ ，由于 $q^top q = 1$ ，有椭球：

$ 1 = (y_1 / sigma_1)^2 + (y_2 / sigma_2)^2 + dots + (y_n / sigma_n)^2 $
][
  等价于：
  $ 
    &cal(V)^top (J J^top) cal(V) \ 
    &= cal(V)^top U(Sigma Sigma^top)^(-1) U^top cal(V) \ 
    &= y^top (Sigma Sigma^top)^(-1) y \
    &= 1 
  $

  其中 

  $
    (Sigma Sigma^top)^(-1) = "diag"(dots, 1/(sigma_i^2), dots)
  $
]

整体来看：

$ y = U^top cal(V) = Sigma V dot(theta) $

对于奇异值分解，$U, V$ 都是酉矩阵（或正交矩阵），即 $cal(V)$ 进入了 $U$ 坐标系；
$dot(theta)$ 进入了 $V$ 坐标系，然后由 $Sigma$ 进行缩放。对于奇异值 $sigma_i$ ，有：

$ J v_i = sigma_i u_i $ 

其中 $v_i$ 是速度输入方向，$u_i$ 是输出主轴方向，$y_i$ 是在 $u_i$ 方向上的输出分量，
$sigma_i$ 是椭球半轴长度。如果 $sigma_i -> 0$ ，椭球会越来越扁直到失去该方向的运动能力。

==== $mu_1$

$ mu_1 = sqrt("det"(J J^top)) = sqrt(product(sigma^2_i)) = product(sigma_i) $

椭球的总体体积，$mu_1$ 越大，整体运动能力越强。

==== $mu_2$

$ mu_2 = (sigma_"min")/(sigma_"max") $


椭球的各向同性（isotropy），也就是椭球圆不圆。因为 $ 0 <= mu_2 <= 1 $，越接近 $1$，各方向运动能力越均匀。

$ mu_3 = sigma_"min" $ 

$mu_3$ 是最差运动方向，需要监控这个值 $mu_3 >= epsilon.alt$，用来判断是否接近奇点。

== Space Jacobian of Vecolity Kniematics

Let $A_i = e^(screw(i) theta_i)$, $T_i = A_1 A_2 dots A_i M$. Since $dot(A_i)A_i^(-1)=screw(i)dot(theta_i)$, 

$ 
  [cal(V)_s] & = dot(T_n) T_n^(-1) \
  & = dot(A_1)A_1^(-1) + A_1 dot(A_2) A_2^(-1) A_1^(-1) + dots \ 
  & = screw(1) dot(theta)_1 + A_1 screw(2)dot(theta)_2 A_1^(-1) + dots \
  & = screw(1) dot(theta)_1 + Ad_(A_1) screw(2) dot(theta)_2 + dots + Ad_(A_1 A_2 dots A_(i-1)) screw(i)dot(theta)_i + dots \ 
  & = sum_(i=1)^n [Ad_(T_(i-1))]screw(i) dot(theta)_i 
$

#let S(i) = $[cal(S)_#i]$
从矩阵系换回 Twist 系，得到：

$ cal(V)_s = sum_(i=1)^n "Ad"_(T_(i-1))cal(S)_i dot(theta)_i $

对比 Jacobian 定义：

$ cal(V)_s = J_s dot(theta) = sum J_(s i) dot(theta) $

For home screw axes $cal(S)_i$:

$ J_s(theta) = mat(cal(S)_1, Ad_(e^(screw(1) theta_1)) cal(S)_2, dots, Ad_(e^(screw(1) theta_1) dots e^(screw(n-1) theta_(n-1))) cal(S)_n) $

Equivalently, define $T_i=e^(screw(1)theta_1)dots
e^(screw(i) theta_i)$.  Then

$ J_(s 1)=cal(S)_1, quad J_(s i)=Ad_(T_(i-1))cal(S)_i. $

Earlier joints move later joint axes in the space frame, so column $i$ depends
only on $theta_1,dots,theta_(i-1)$, never on its own joint value or later joints.

=== Body Jacobian

For body screw axes $cal(B)_i$:

$ 
J_b(theta) = 
  mat( 
    Ad_(e^(-[cal(B)_n] theta_n) dots e^(-[cal(B)_2] theta_2)) cal(B)_1; 
    dots; 
    Ad_(e^(-[cal(B)_n] theta_n)) cal(B)_(n-1); 
    cal(B)_n
  )^top 
$

Later joints affect how earlier axes are seen from the body frame.  Thus column
$i$ depends only on $theta_(i+1),dots,theta_n$, and the last column is always
$cal(B)_n$.

=== Space-Body Relation

For end-effector pose $T_("sb")(theta)$:

$ J_s(theta) = Ad_(T_("sb")(theta)) J_b(theta) $

Therefore $J_b=Ad_(T_("sb")^(-1))J_s$ and both Jacobians have the same rank.

== Statics

Let $cal(F)$ be the wrench applied by the environment to the end effector, in
the same coordinates as $cal(V)$.  Virtual power balance gives

$ tau^T dot(theta) = cal(F)^T cal(V) $

With $cal(V) = J dot(theta)$:

$ tau = J(theta)^T cal(F) $

The Jacobian transpose maps endpoint wrench to joint torque.  This is not an
inverse and remains meaningful at singularities. 

Static equilibrium including actuator torque, external wrench, gravity, and
other generalized loads requires their signed sum to vanish.  The equation
$tau=J^T cal(F)$ alone describes only the wrench-to-joint mapping.

= Inverse Kinematics

For a n-DoF open chain with forward kinematics $T(theta)$ , $theta in RR^n$, the inverse
kinematics problem is: given a desired end-effector configuration $T_d in S E(3)$, find 
solutions $theta$ that satisfy $T(theta) = T_d$.

Unlike forward kinematics, the inverse map is generally neither unique nor globally smooth.
Redundant rotos may have infinitely many solutions. Near a singularity or outside the 
reachable workspace, no exact (or bounded) solution exists.

求解逆运动学有很多方法。书中重点介绍了解析几何建模的方式，但是这需要机器的几何结构比较
优美，否则最终的三角函数方程仍可能非常复杂。
另外，由于需要同时满足 关节限位碰撞限制、速度力矩限制、最小能量 等多种约束条件，更合适的
求解方法是数值迭代与最优化建模。#footnote[非线性方程的数值解法，详见 `../numerical/nonlinear-equations.typ`]

== Newton-Raphson IK


#sidenote[
  假设标量的定位公式 $x=f(theta)$, 目标位置为 $x_d$, 则逆运动学的误差定义为 $Delta x = x_d - f(theta_d)$。
  牛顿迭代方程为：

    $ x_d = f(theta_0) + J(theta_0) (theta_d - theta_0) = f(theta_0) + J(theta_0) Delta theta  $

  对于刚体位姿坐标系 $S E(3)$ ，可以类比：

    $ cal(V)_b approx J_b(theta) Delta theta $
][
  这里 $J(theta)$ 是 $f in RR^m$ 对 $theta in RR^n$ 求导后的雅各比矩阵。

  $ J(theta) = (partial f) / (partial theta)(theta) = [(partial f_i)/(partial theta_j)]_(m times n) $

  注意，不能认为 $J(theta)_(m times n)$ 是可逆的，关节数 $n$ 通常多于末端执行器的运动维度 $m$
]

每一步取最小二乘解：

$ Delta theta = J_b(theta)^dagger cal(V)_b $

$ theta arrow theta + Delta theta $

注意，这里是刚体坐标系 $BB$ ，位姿变化表示为：


$ T(theta+Delta theta) = T(theta) Delta T
  approx T(theta)exp([J_b(theta)Delta theta]). $

Consequently,

$ T(theta+Delta theta)^(-1)T_d
  approx exp(-[J_b Delta theta])T(theta)^(-1)T_d. $

Keeping first-order Lie-algebra terms gives

$ log(T(theta+Delta theta)^(-1)T_d)^("vee")
  approx cal(V)_b-J_b Delta theta. $

Setting the linearized residual to zero yields
$J_b Delta theta=cal(V)_b$ and therefore the pseudoinverse update.

A robust numerical procedure is:

1. Compute $T(theta)$ and $cal(V)_b=log(T(theta)^(-1)T_d)^("vee")$.
2. Stop successfully when angular and linear errors meet their tolerances.
3. Compute $J_b(theta)$ and solve $J_b Delta theta approx cal(V)_b$.
4. Limit or line-search the step, update $theta$, and normalize revolute joints
   only when their limits permit wrapping.
5. Stop with failure if the iteration limit is reached, the step becomes tiny
   while the error remains large, or the residual repeatedly fails to decrease.

Convergence is local and depends strongly on the initial guess.  Different
seeds can converge to different branches or fail even when a solution exists.
Warm-starting from the previous solution is effective for a continuous pose
trajectory.

== Damped Least Squares

The pseudoinverse magnifies error along directions with small singular values.
Damped least squares solves

$ "argmin"_(Delta theta) norm(J Delta theta-cal(V))^2
  + lambda^2 norm(Delta theta)^2 $

with solution

$ Delta theta = J^T (J J^T + lambda^2 I)^(-1) cal(V) $

Damping trades exact local error reduction for bounded joint steps.  Fixed
$lambda$ is simple but slows convergence everywhere; adaptive damping can stay
small in well-conditioned regions and grow as $sigma_("min")(J)$ decreases.

The damped equation is the stationary condition of

$ min_(Delta theta)
  norm(J Delta theta-cal(V))^2+lambda^2 norm(Delta theta)^2. $

Differentiating with respect to $Delta theta$ gives

$ (J^T J+lambda^2 I)Delta theta=J^T cal(V). $

The identity
$(J^T J+lambda^2 I)^(-1)J^T
=J^T(J J^T+lambda^2 I)^(-1)$ produces the displayed right-inverse form.

Step-size control is a separate mechanism.  Using
$theta arrow theta+alpha Delta theta$ with $0<alpha<=1$ and accepting a step
only when the pose error decreases improves global behavior.

== Redundancy and Constraints

For a redundant robot, the general differential update is

$ Delta theta = J^dagger cal(V)
  + (I-J^dagger J) eta. $

The second term is a first-order null-space motion.  Choosing
$eta=-k nabla h(theta)$ can reduce a secondary cost $h$, such as distance to a
preferred posture or a joint-limit barrier, without changing the primary task
to first order.

#sidenote[
  Null-space projection alone does not guarantee finite-step feasibility.
  Practical constrained IK may instead solve a bounded least-squares or quadratic
  program with joint position and step limits. Collision avoidance requires
  additional distance constraints or costs and a collision model.
][
  Clipping an unconstrained update at joint limits changes the direction of
  the step and can destroy convergence. Active-set or bounded solvers account
  for the constrained directions while computing the step.
]

== Cyclic-Coordiinate Descent

COMP7508

== Inverse Velocity Kinematics

Inverse velocity kinematics solves the instantaneous problem

$ J(theta) dot(theta) = cal(V)_d $

Minimum-norm solution:

$ dot(theta) = J^dagger cal(V)_d $

This is not the same as finite-pose IK: integrating a desired twist open loop
accumulates modeling and numerical errors.  For trajectory tracking, add pose
feedback, for example

$ cal(V)_("cmd") = cal(V)_d + K cal(V)_("err"), quad
  dot(theta)=J^dagger cal(V)_("cmd"). $

The feedforward twist, error twist, and Jacobian must all use consistent space
or body coordinates.

== Numerical Newton-Raphson Method


== Inverse Velocity Kinematics

= Closed-chain Kinematics

详见 @lynch2019 ，此处略

#bibliography("references.bib")
