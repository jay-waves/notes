
#import "@local/ypst-template:0.1.0": template, sidenote, theorem

#set document(title: [机器人动力学], keywords: ("robotics", "dynamics"))
#show: template

来源：Modern Robotics, Chapter 8

修订日期：2026-08-02

"./imu.typ"


$tau in RR^n$ 机器人的力矩表示为：

$ tau = M(theta) dot.double(theta) + h(theta, dot(theta)) $

其中所有一次项合并称为 $h\(theta, dot(theta)\)$ ，但其构成很复杂：

$ h(theta, dot(theta)) = C(theta, dot(theta))dot(theta) + g(theta) + f(dot(theta)) $

- $C\(theta, dot(theta)\)dot(theta)$ 是向心力（关节圆周运动）和 Coriolis 项（$theta_i theta_j$ 不同关节间相互影响耦合）
- $g(theta)$ 是重力项 
- $f\(dot(theta)\) approx B dot(theta) + f_c "sgn"\(dot(theta)\)$ 是摩擦项，包含粘性摩擦 $B dot(theta)$、库伦（静电）摩擦
  $f_c "sgn"\(dot(theta)\)$ 、以及可能的静摩擦。


= Lagrangian Formulation 

= Newton-Euler Ivnerse Dynamics 

= Forward Dynamics of Open Chains 

= Dynamics in the Task Space 

= Constrained Dynamics 

= Acutation, Gearing and Friction 

> 挪到电机选型里
