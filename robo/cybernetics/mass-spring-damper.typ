#import "@local/ypst-template:0.1.0": template, sidenote
#show: template

#import "@preview/cetz:0.5.2"

= 线性 质量-弹簧-阻尼 模型

#figure(
  image("../../attach/img/robo/mass-spring-damper.webp", width: 200pt)
)

设参数如下：
- 质量 $m$ 
- 位移 $theta$ ，可以视为相对 $0$ 位置的一种“误差”
- 阻尼施加的力 $-b dot(theta)$ ，$b$ 是阻尼常数
- 弹簧施加的力 $-k(theta)$ ，$k$ 是弹簧刚度
- 外力 $f$ 

力学公式为： $ m dot.double(theta)+b dot(theta)+k theta=f $

= 无外力情况

在无外力情况下 ($f=0$) ，考虑如何控制误差稳定，并收敛为零。

#math.equation(
  numbering: "(1)",
  supplement: "Eq.",
  block: true,
  $ dot.double(theta)(t) + frac(b, m) dot(theta)(t)+frac(k,m)theta (t)=0 $ 
) <eq1> 

设自然频率 (natrual frequency) $w_(n)=sqrt(k/m)$ ，阻尼系数 (damping ratio) $zeta=b/(2sqrt(k m))$， @eq1 式的特征多项式为：

$ s^(2)+2 zeta omega_(n)s+omega_n^2=0 $

得到两个根：

$ 
s_(1)& = - zeta omega_(n)+ omega_(n)sqrt(zeta^(2)- 1) \ 
s_(2) & = - zeta omega_(n)- omega_(n)sqrt(zeta^(2)- 1) 
$

要让 @eq1 式稳定，即 $theta_(t->infinity )=0$ ，等价于让所有特征值满足 $Re(s_(i))<0$ ，等价于 $zeta omega_n >0$。

当 $theta$ 稳定时，有一下三种解。总体而言，*特征值在左半复平面离虚轴 $Im$ 越远，衰减越快。在右半复平面，发散。离实轴 $Re$ 越远，震荡越快。* 这和微分方程的解结构是类似的。

#figure(
  image("../../attach/img/robo/mass-spring-damper2.webp", width: 70%),
  caption: [Modern Robotics, Fig 11.5],
  numbering: none
)

== 过阻尼 (Overdamped)

$zeta > 1$ , roots $s_(1,2)$ are real and distinct, the solution is: 

$ theta(t)&=c_1 e^(s_1 t)+c_2 e^(s_2 t) $

#cetz.canvas({
  import cetz.draw: *

  line((-2.3,0), (1.2,0), stroke: 0.8pt)
  line((0,-1.6), (0,1.6), stroke: 0.8pt)
  content((0, 1.75), $Im(s)$)
  content((1.65, 0), $Re(s)$)

  circle((-0.8,0), radius: 0.05, fill: black)
  content((-0.8,0.5), $s_1$)
  circle((-1.8,0), radius: 0.05, fill: black)
  content((-1.8,0.5), $s_2$)
})

=== 2% Settling Time

不妨设 $s_1 < s_2 < 0$

$ theta(t) = c_1 e^(-s_1) + c_2 e^(-s_2) approx c_2 e^(-s_2) , quad t->infinity $

$ |theta(t) | approx |c_2| e^(-s_2) <= 0.02 |c_2| $

$ T_s = 4/ (|s_2|) $

== 临界阻尼 (Critically Damped)

$zeta = 1$, the roots $s_(1,2) = -omega_n$ are equal and real, and the solution is:

$ theta(t) = (c_1 + c_2 t) e^(-omega_n)t $

#cetz.canvas({
  import cetz.draw: *

  line((-2.3,0), (1.2,0), stroke: 0.8pt)
  line((0,-1.6), (0,1.6), stroke: 0.8pt)
  content((0, 1.75), $Im(s)$)
  content((1.65, 0), $Re(s)$)

  circle((-0.8,0), radius: 0.05, fill: black)
  content((-0.8,0.5), $s_1,s_2$)
})

== 欠阻尼 (Underdamped)

$zeta < 1$, the roots $s_1, s_2$ are complex conjugates, let $w_d = w_n sqrt(zeta^2 - 1)$ 
(the damped natrual frequency), the solution is:

$ theta(t) = (c_1 cos omega_d t + c_2 sin omega_d t)e^(-zeta omega_n t) $

#cetz.canvas({
  import cetz.draw: *

  line((-2.3,0), (1.2,0), stroke: 0.8pt)
  line((0,-1.6), (0,1.6), stroke: 0.8pt)
  content((0, 1.75), $Im(s)$)
  content((1.65, 0), $Re(s)$)

  circle((-0.8,1), radius: 0.05, fill: black)
  circle((-0.8,-1), radius: 0.05, fill: black)

  // 阻尼线
  line( (-0.8,1), (-0.8,0), stroke: (dash: "dashed", thickness: 0.5pt))
  line( (-0.8,1), (0,1), stroke: (dash: "dashed", thickness: 0.5pt))
  // omega_n 斜边
  line( (-0.8,1), (0,0), stroke: 0.5pt)

  // 标注
  content((-1.05,1.15), $s_1$)
  content((-1,-0.35), $-zeta omega_n$)
  content((-0.45,0.55), $omega_n$)
  content((0.45,1), $omega_d$)
})

=== Overshoot for Underdamped

The peak of the overshoot occurs at the first time where the error response satisfies $dot(theta)=0$. 

$ t_p = pi/omega_d $

=== 2% Settling Time

$ |theta(t)| = |A e^(-zeta omega_n t) cos(omega_d t + phi)| <= |A| e^(-zeta omega_n t) <= 0.02 |A| $

$ T_s = -ln(0.02)/(zeta omega_n) approx 4/(zeta omega_n) $

== 阻尼控制 

11.7 看完

= 参考

Modern Robotics -- Kevin Lynch & Frank C. Park -- 2019 

#link("https://en.wikipedia.org/wiki/Mass-spring-damper_model")[Mass-spring-damper model -- wikipedia]
