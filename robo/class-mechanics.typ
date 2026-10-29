
#import "@local/ypst-template:0.1.0" as theme 

#import theme: template, sidenote, theorem

#set document(
  title: "经典力学",
  date: datetime.today(),
  keywords: ("robotics", "kinematics")
)

#show: template

= kinematics 

- Forward Kinematics (含位姿、坐标变换)，详见 `./kinematics.typ`
- Inverse Kinematics ，详见 `./inverse-kinematics.typ`

== Rotation 

#table(
  columns: 3,
  [平移], [转动], [转换关系],
  [位移 $r$], [角位移 $theta$],[],
  [速度 $v$], [角速度 $omega$], [], 
  [加速度 $a$], [角速度 $alpha$],[], 
  [质量 $m$], [转动惯量 $I$],[], 
  [力 $F$], [力矩 $tau=I alpha$],[$tau = r times F$],
  [动量 $p$], [角动量 $L= I omega$],[$L = r times p$], 
)

在三维旋转中，由于旋转轴不同、质量分布不同，力矩和转动惯量需要调整为矩阵形式。

转动惯量调整为_惯性张量 (inertia tensor)_，记为：

$ bold(I) = mat(I_x, -I_(x y), -I_(x z); -I_(x y), I_y, -I_(y z); -I_(x z), -I_(y z), I_z) $

其中对角元素是绕各轴的转动惯量：质量离 $x$ 轴越远，越难绕 $x$ 轴旋转。

$ I_x = integral (y^2 + z^2) upright(d)m $

非对角元素是_惯性积 (Product of Inertia)_ ，如果物体关于坐标轴对称，则惯性积为零。

$ I_(x y) = - integral x y thin upright(d)m $

= dynamics 

- fraction and drag 
- momentum theorem (动量定理)
- angular momentum 
- collision 

== particle dynamics 

== rigid body dynamics 

- Rotational Motion
- Moment of Inertia 
- Torque 

平动： $ m dot(v) = F $

转动（第二项为陀螺项 gyroscope term）： $ I dot(omega) + omega times (I omega) = tau $

动力学方程：

$ tau = M(q) dot.double(q) + C(q, dot(q))dot(q) + G(q) $

其中：
- $M(q) dot.double(q)$ 称为惯性项 (inertia term)
- $C(q, dot(q))dot(q)$ 称为科氏力（离心力）项
- $G(q)$ 是重力项

= Energy 

Work Energy: 

$ K &= 1/2 m v^2 \ K_r &= 1/2 I omega^2 $

Potential Energy:

$ U $

- Work-Energy Theorem 
- Potential Energy 
- Lagrangian Mechanics 

= statics 

= continuum mechanics (fulid & solid)

= oscillation theory 

= 
