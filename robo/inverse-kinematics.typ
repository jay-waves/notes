#import "@local/ypst-template:0.1.0" as theme
#import theme: theorem, definition, sidenote

#show: theme.template

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

== Cyclic-Coordiinate Descent (CCD)

#image("../attach/img/robo/ccdik.webp")

== Inverse Velocity Kinematics

inverse velocity kinematics solves the instantaneous problem

$ j(theta) dot(theta) = v_d $

minimum-norm solution:

$ dot(theta) = j^dagger v_d $

this is not the same as finite-pose ik: integrating a desired twist open loop
accumulates modeling and numerical errors.  for trajectory tracking, add pose
feedback, for example

$ v_("cmd") = v_d + k v_("err"), quad
  dot(theta)=j^dagger v_("cmd") $

the feedforward twist, error twist, and jacobian must all use consistent space
or body coordinates.


== Numerical Newton-Raphson Method

