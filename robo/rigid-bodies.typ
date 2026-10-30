
#import "@local/ypst-template:0.1.0": template, sidenote
#show: template

#let bmat(..args) = math.mat(delim: "[", ..args)
#let vec(x) = math.bold(math.upright(x))

at its most basic level a robot consists of rigid bodies connected by joints, with the joints driven by actuators

= Configuration Space of rigid bodies 

描述一个刚体的姿态的最小 $n$ 个实数，被称为*自由度（degrees of freedom）*。描述为一个向量，向量空间被称为 *configuration space (C-space)*.

The *task space* is a space in which the robot’s task can be naturally expressed.

The *workspace* is a specification of the configurations that the end-effector
of the robot can reach. 

== 独立刚体自由度

平面上的刚体有三个自由度： $(x, y, theta)$ 分别对应 xy 方向的平移与绕垂直轴旋转。

空间中的刚体有六个自由度： $(x,y,z, "roll","yaw","pitch")$ #footnote[roll,yaw,pitch 翻译为： 滚转、俯仰、偏航]

#image("../attach/img/robo/adam-lite.webp", width: 50%)

== 刚体关节

#image("../attach/img/robo/robot-joints.webp", width: 70%)

- F: fixed joint. 完全刚性连接。0DoF
- R: revolute joint, hinge joint. 铰链关节。1DoF
- P: prismatic joint, linear, sliding joint. 滑动关节。1DoF
- H: helical joint, screw joint. 螺旋关节。1DoF
- C: cylindrical joint. 2DoF. 圆柱接头。
- U: universal joint, 2DoF. 万向接头，有两个正交的铰链接头组成。
- S: spherical joint, 3DoF. 球形接头。

设 $N$ 个用关节连接在一起的刚体，刚体自由度为 $m$ （如空间中刚体无约束自由度为 $m=6$ ），关节的自由度为 $f$ ，那么总体的自由度：

$
d o f 
& = m(N - 1)- sum^(J)_(i = 1)(m - f_i) \ 
& = m(N - 1 - J)+ sum^(J)_(i = 1)(f_i) 
$

== C-space Topology 

球面上的点： $S^1$

直线上的点： $E^1$ 或 $R^1$

平面： $R^2$

平面上的刚体： $R^2 times S^1$

双铰链机械臂： $S^1 times S^1=T^2$

#sidenote[
  = Rigid-Body Rotation
][
  这里使用 Modern Robotics 中的表示法。
]

设固定单位坐标系 $s$ ，移动刚体单位坐标系 $b$ ，以两者原点为首尾的向量 $vec(p)$ 。

忽略位移， $b$ 中向量可通过单位旋转矩阵 $R$ 变为 $s$ 中向量： $ vec(v)_s=R vec(v)_b $

反之：$ vec(v)_b=R^(-1) vec(v)_s=R^(top)vec(v)_s $

这里的单位坐标系都是右手系，满足： $ vec(x) times vec(y)=vec(z) $ 

== Angular Velocities 

设坐标系绕单位向量 $vec(w)$ 旋转 $Delta theta$ 耗时 $Delta t$ ，记角速度为： $ w=vec(w)dot theta=vec(w)(Delta/theta)(Delta t) $

三个坐标方向的角速度可以表示为： 

$ dot(vec(x)) & = w times vec(x) \ dot(vec(y)) & = w times vec(y) \ dot(vec(z)) & = w times vec(z) $

#image("../attach/img/robo/angular-velocity.webp", width: 50%)

#sidenote[
  用固定坐标系 $s$ 表示*旋转变化量* $w$, 即 $w_s$ ，设从固定坐标系 $s$ 到刚体坐标系 $b$ 的旋转矩阵 $R$ ，此时角速度可表示为： $ dot(R)=w_s times R=[w_s]R $
][
  旋转矩阵： $R=bmat(vec(r_x),vec(r_y), vec(r_z)) I$ \
  其中 $r_x$ 是对标准坐标系中 $x$ 轴的变换。
]

向量叉乘可以写为“左乘一个斜对称矩阵”的形式，类似：

#math.equation(
  numbering: "(1)",
  supplement: "Eq.",
  block: true,
  $ vec(a) times vec(b) = 
  bmat(a_(1);a_(2);a_(3)) times vec(b) = bmat(0, - a_(3), a_(2) ; a_(3), 0, - a_(1) ; - a_(2), a_(1), 0) times b = [vec(a) ]vec(b) $
) <eq1> 

因此，$w_s$ 可以表示 SO(3) 中的等价矩阵：$ [w_s]=dot(R)R^(-1)=dot(R)R^top $

#sidenote[
  在考虑刚体坐标系下的旋转变化量 $w_b$ ，满足：
][
  再次强调，这里 $R$ 是指从固定坐标轴到刚体坐标轴的旋转矩阵。
]

$ w_b=R^(-1)w_s $

对于任意旋转矩阵 $R$ 和向量 $vec(v)$ ，有： $ R[vec(v)]R^(-1)=R[vec(v)]R^top=[R vec(v)] $

因此： $ [w_b]=[R^(-1)w_s]dot = R^(-1)[w_s]R=R^(-1)(dot(R) R^(-1))R=R^(-1)dot(R) $

总结： $ [w_(s)]& = dot(R) R^(- 1) [w_(b)]& = R^(- 1)dot(R) $

= Rigid-Body Motion and Twist

== Homogenous Transformation Matrices 

Represent the regid-body transofrmation by a homogeneous transformation matrix in $S E(3)$: 

$ T = bmat(R, p ; 0, 1) $

where $R in S O(3)$ represents the orientation of the coordinate frame, and $p in RR^3$ represents the position of its origin. 

> $R in S O(3)$ 是纯旋转群，3DoF；$T in S E(3)$ 是刚体运动群，还有平移运动，6DoF。

<br> 

Some properties of T: 

$ T^(- 1)= mat(delim: "[", R^(top), - R^(top)p ; 0, 1) $

appling on vectors:  

$ T bmat(x ; 1) = bmat(R, p ; 0, 1) bmat(x ; 1) = bmat(R x + p ; 1) $

pre-multiply $dot(T)$ by $T^(-1)$ : 

$ T^(- 1)dot(T) = 
bmat(R^(top), - R^(top)p ;, 1) 
bmat(dot(R), dot(p) ; 0, 0) 
= bmat(R^top dot(R), R^top dot(p) ; 0, 0) 
= bmat([omega_(b)], v_(b) ; 0, 0) $

#sidenote[
  from $R x_b=x_s$, we get: $R^(-1)dot(p)=R^top dot(p)=v_b$
][
  此处 T: ${b}->{s}$

  求导 $x_s = T x_b$ ，得到 $dot(x_s)=dot(T)x_b + T dot(x_b)=dot(T)x_b$ ，此时求出的是 
  ${s}$ 坐标系下是速度，再用 $T^-1$ 转换为刚体坐标系： $T^(-1)dot(x_s)=T^(-1)dot(T)x_b=[cal(V)_b]x_b$

  这里的速度并非单纯对 $t$ 求导，而是速度场（加入旋转量）
]

#linebreak()

pre-multiply $T^(-1)$ by $dot(T)$ : 

$ T^(-1) dot(T)=
bmat(dot(R), dot(p) ; 0, 0) 
bmat(R^(top), - R^(top)p ; j, 1) 
= bmat(dot(R) R^(top), dot(p) - dot(R) R^(top)p ; 0, 0) 
= bmat([omega_(s)], v_(s) ; 0, 0) $

in which, $dot(p) - dot(R) R^top p = dot(p) - [w_s]p = dot(p) - w_(s)times p = v_(s)$ .

对于空间中刚体，描述刚体中某一点 $x$ 的运动状态的量，称为*速度场*，由旋转产生的线速度与整体平移速度复合而成： $dot(x)=omega_s times x+v_s$ 。令 $x=p$ ，即代表 $s$ 坐标系下的 $b$ 刚体坐标系原点的速度场，必须有： $dot(p)-w_s times p=v_s$

== Twist

*Body Twists* ( Spatial Velocity in body frame): 

$ cal(V)_(b)= bmat(omega_(b) ; v_(b)) in RR^(6) $

defining: 

$
T^(- 1)dot(T) = [cal(V)_(b)]= bmat([omega_(b)], v_(b) ; 0, 0 k) in "se"(3)
$

similarly, defining *spatial twist (spatial velocity in the space frame)*: 

$ cal(V)_(s)= bmat(omega_(s) ; v_(s)) in RR^(6) $ 

$ [cal(V)_s]= bmat([omega_s], v_s ; 0, 0) = dot(T) T^(- 1)in "se"(3) $

then: $ [cal(V)_s]=T^(-1)[cal(V)_b] T $

== Adjoint representation of T

Given $T$, its adjoint representation is: 

$ [A d_(T)]= bmat(R, 0 ; [p ]R, R) in R^(6 times 6) $

we have adjoint map: $ [cal(V)_(s)]
= bmat(R, 0 ; [p ]R, R) [cal(V)_(b)]
= A d_(T)(cal(V)_(b)) $

Equivalently, $ w '& = R w \ v ' & = p times(R w) + R v $

Equivalently, $ [cal(V)_s]= T^(- 1)[cal(V)_b]T $

> $T$ 作用在坐标系的点 $x$ 上，$A d_T$ 作用在运动量 $cal(V)$ 上。都用于转换坐标系。

Inverse:

$ [A d_T]^(- 1)= [A d_(T^(- 1))]= bmat(R^top, 0 ; - R^top [p], R^top) $

== Twist in Screw Axis $cal(S)$

Screw axis $cal(S)={q,hat(s),h}$ represents the motion of a screw: rotating about the axis while also translating along the axis:
- $q in RR^{3}$ is a point on the axis 
- $hat(s)$ is a unit vector in the direction of axis 
- $h$ is the *screw pitch (螺距，螺旋节距)*, defining as: linear speed / angular speed， or translation along the axis / rotation angle. 

> $h=0$ 是纯旋转，$h=infinity$ 是纯平移。螺旋运动的转角、轴向平移有一个固定比例。


#figure(
  image("../attach/img/robo/screw-axis.webp", width: 50%),
  caption: [Modern Robotics F3.19],
)

write the twist $cal(V)=(w,v)$ to an angular velocity $dot(theta)$ about $cal(S)$ as: 

$ cal(V) = bmat(w ;v) = 
bmat(hat(s) dot(theta) ; - hat(s) dot(theta) times q + h hat(s) dot(theta)) 
=bmat(hat(s); -hat(s)times q + h hat(s)) dot(theta) , 
quad hat(s) = omega / norm(omega), dot(theta) = norm(omega) $

其中 $ h = (hat(s)^top v) / dot(theta) =(hat(omega)^top v)/ norm(omega)^2 $

#sidenote[
  也就是说，$S$ 可以用归一化的 $cal(V)$ 表示：
][
  注意，这里 $S$ 表示的不是速度，虽然内部 $omega,v$ 都是速度，但归一化后表示某种坐标系。
]

$ S = cal(V) / dot(theta) = cal(V) / norm(omega) in RR^6 $

- 当 $norm(w) = 1$ 时， $v=-w times q+h w$ 。
- 当 $w=0,norm(v)=1$ 时，螺距 $h$ 是无穷大，运动量 $cal(V)$ 沿着 $v$ 所在轴平移

$ [cal(S) ]= bmat([omega], v ; 0, 0) $

= Exponential Coordinates 

== Exponential Repr. of Rotation

#image("../attach/img/robo/rigid-body-motion.webp", width: 40%)

考察线速度，参考 #link("https://notes.jay-waves.cn/robo/quaternion/")[四元数推导过程]，对于固定坐标系中的向量 $p in RR^3$ ，设其旋转角速度向量为 $w=vec(w)dot(theta)$ ，其端点线速度为： 

$ dot(p)=w times p=[w]p $ 

这是一个线性微分方程，其解是 $ p(t)=e^([w]t) p(0) $ 


设 $t$ 时刻时，向量 $p$ 旋转了 $theta$ 角度，此时将指数 $e^([vec(w)]theta)$ 泰勒展开得到 Rodrigues' Formula：

== Rodrigues' Formula 

Given vector $vec(w)theta in RR^3$, such that $theta$ is any scalar and $vec(w) in RR^3$ is a unit vector, the matrix exponential of $[vec(w)] theta=[vec(w) theta] in S O(3)$ is

#math.equation(
  numbering: "(1)",
  supplement: "Eq.",
  block: true,
$ R o t(vec(w),theta)=e^([vec(w)] theta)=I+sin theta[vec(w)]+(1- cos theta)[vec(w)]^2 in S O(3) $ 
) <eq2> 

#sidenote[
  Subsituting the skew-symmetric matrix representation of $[vec(w)]$ in @eq1 into @eq2, we obtain:
  $ R-R^top=e^[vec(w)]-(e^[vec(w)])^top=2 sin theta [vec(w)] $
][
  $omega in RR^3 -> e^(omega theta) in S O(3)$
]

== Exponential Repr. of Motion

Let $cal(S)=(w, v)$ be a screw axis, and  $norm(w) =1$ , for any distance $theta in RR$ traveled along the axis: 

$
e^([cal(S) ] theta) 
& = I +[cal(S) ] theta +[cal(S) ]^(2) frac(theta^(2), 2 !)+[cal(S) ]^(3) frac(theta^(3), 3 !)+ ... \ 
& = bmat(e^(vec(w) theta), G(theta)v ; 0, 1), quad G(theta)= I theta + vec(w) frac(theta^(2), 2 !)+ vec(w)^(2) frac(theta^(3), 3 !)+ ... \ 
& = bmat(R, p ; 0, 1)
$

Using the $vec(w)^3=-[vec(w)]$,  $G(theta)$ can be simplified to : 

#sidenote[
  $
  G(theta)=I theta + (1-cos theta)[vec(w)]+(theta-sin theta)[vec(w)]^2
  $
][
  $[cal(S)] theta in s e (3) -> T in S E(3)$ \
  $R$ 是累计绕轴旋转，$p =G(theta) v$ 是累计平移。因为 $v$ 方便不断随旋转变化，因此需要积分修正。
]

If $w=0, norm(v)=1$, then: 

$ e^([cal(S)] theta)= bmat(I, v theta ; 0, 1) $

== Summary 

旋转向量（角速度）、李代数与矩阵李群相关转换：

$ 
 &bold(w) = bmat(w_x; w_y; w_z) \
  <==> &[bold(w)] = bmat(0, -w_z, w_y; w_z, 0, -w_x; -w_y, w_x, 0) in "so"(3)\
  <==> &R = exp([bold(w)]) in "SO"(3) 
$

旋量、李代数与李群相互转换：

$
  &cal(V) = bmat(omega; v) in RR^6 \
  <==>& [cal(V)] = bmat([omega], v; 0, 0) in "se"(3) \
  <==>& T = exp([cal(V)]) in "SE"(3) 
$

在世界坐标系（固定坐标系）:

$
  dot(T)T^(-1) & = [cal(V)_s] \
  dot(R)R^(-1) & = dot(R)R^top = [bold(w)_s] 
$

在刚体坐标系：

$
  T^(-1)dot(T) &= [cal(V)_b] \
  R^(-1)dot(R) & = [bold(w)_b] 
$

*我也没搞懂 李代数和李群 的关系是啥。*

= Wrench

*Wrench* (spatial force, moment, torque) is expressed in the ${a}$ frame: 

$ cal(F)_a=bmat( m_a ; f_a) in RR^6 $

Considering another frame ${b}$ , the relationship between $cal(F)_a$ and $cal(F)_b$ is:  the power generated by $(cal(F), cal(V))$ pair must be the same regardless of the frame:

$
cal(V)_b^top cal(F)_(b)= cal(V)_(a)^top cal(F)_(a) = ("Ad"_T_(a b) cal(V)_b)^top cal(F)_a = cal(V)_b^top "Ad"^top_T_(a b) cal(F)_a
$

Thus, 
$ cal(F)_a=[A d_(T_(b a))]^ top cal(F)_b $

$ cal(F)_b=[A d_(T_(a b))]^top cal(F)_a $
