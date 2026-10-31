
#import "@local/ypst-template:0.1.0": template, sidenote

#show: template

#let bmat(..args) = math.mat(delim: "[", ..args)

#sidenote[
  Mobile Robots:
  - kinematic: wheel speed $->$ velocity
  - dynamic: wheel torque $->$ acceleration
][
  这是一个极简化的模型。假设地面平坦、平行、坚硬，并且轮子不打滑。
  机器人假设为一个 完整刚体底盘。
]

= Kinematics of Wheeld Mobile

坐标变换矩阵 $T_(s b)$ 可以被简化为 $q=(phi.alt, x, y)$

刚体的螺旋速度 $cal(V)$ 简化为 

$
  cal(V)_b = bmat(omega_(b z); v_(b x); v_(b y)) 
  = bmat(1, 0, 0; 0, cos phi, sin phi; 0, -sin phi, cos phi) bmat(dot(phi); dot(x); dot(y))
$

== Omnidirectional 

== Non-holonomic

$A(q)dot(q) = 0$
