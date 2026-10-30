#import "@local/ypst-template:0.1.0": template, sidenote

#show: template

#let bmat(..args) = $mat(delim: "[", ..args)$
#let vmat(..args) = $mat(delim: "|", ..args)$

空间平面一般表示为: $A x + B y + C z + D = 0$, 还有点法式: $A(x - x_0) + B(y - y_0) + C(z - z_0) = ( A , med B , med C ) dot (x - x_0 , med y - y_0 , med z - z_0) = 0$

== 切线和法平面
对曲线上两点: $( x_0 , y_0 , z_0 ) , ( x_0 + d x , y_0 + d y , z_0 + d z )$

其割线方程为： $ frac(x - x_0, d x) = frac(y - y_0, d y) = frac(z - z_0, d z) $

当 $d x , d y , d z arrow.r 0$ 时, 割线方程即为点 $( x_0 , y_0 , z_0 )$ 处切线方程.

设 ${x = x(t)\
y = y(t)\
z = z(t)$, 有 ${x'(t) = frac(d x, d t)\
y'(t) = frac(d y, d t)\
z'(t) = frac(d z, d t)$, 于是切线方程可表示为: $ frac(x - x_0, x'(t)) = frac(y - y_0, y'(t)) = frac(z - z_0, z'(t)) $ 其中 $( x'(t) , y'(t) , z'(t) )$ 为切向量.

切向量应与法平面任意线垂直, 所以 $( x_0 , y_0 , z_0 )$ 处法平面可表示为: $ ( x - x_0 ) x'(t) + ( y - y_0 ) y'(t) + ( z - z_0 ) z'(t) = 0 $

特殊地, 若 ${y = y(x)\
z = z(x)\
x = x$, 即 $x = t$, 此时切线方程和法平面为: $  & frac(x - x_0, 1) = frac(y - y_0, y'(x)) = frac(z - z_0, z'(x))\
 & ( x - x_0 ) + ( y - y_0 ) y'(x) + ( z - z_0 ) z'(x) = 0 $

== 法线和切平面
给定平面 $F(x , y , z) = 0$

两边同时求全微分 $F_x dot d x + F_y dot d y + F_z dot d z = ( F_x , F_y , F_z ) dot (d x , d y , d z) = 0$

$( d x , d y , d z )$ 极小, 近似于在 $( x , y , z )$ 的切平面上, 因此 $( F_x , F_y , F_z )$ 即为#strong[法向量].

特殊地, 若 $z = f(z , y)$, 可视为 $F(x , y , z) = f(x , y) - z = 0$, 故法向量为 $( F_x , F_y , F_z ) = ( f_x , f_y , - 1 )$

#table(
    columns: (47.32%, 47.32%, 5.36%),
    align: (auto,auto,auto,),
    table.header([$z = x^2 - y^2$ 图像], [梯度 $( frac(partial z, partial x) , frac(partial z, partial y) )$], [等高线 $x^2 - y^2 = C$],),
    table.hline(),
    [#box(image("../../../attach/img/math/gradient-surface.webp"))], [#box(image("../../../attach/img/math/gradient-vector.webp"))], [#box(image("../../../attach/img/math/math-analytic-geometry-level-curves.webp"))],
  )

#emph[图注]: 设 $z = 0$ 平面上点 $A : ( x , y )$, 该点梯度为 $nabla z = ( frac(partial z, partial x) , frac(partial z, partial y) )$. 该梯度向量即是等高线 $x^2 - y^2 = 0$ 的法向量, 也是 $z = x^2 - y^2$ 切向量在 $z = 0$ 的投影.

#box(image("../../../attach/img/math/surface-gradient.webp"))

#emph[图注]: 设曲面 $C = f(x , y , z)$, 其梯度方向代表 C 变化率最大的方向, 即垂直于曲面的方向.

=== 参数方程形式的隐函数法向量
隐函数形式如下: $ {x = x(u , v)\
y = y(u , v)\
z = z(u , v) $

$ F_x d x + F_y d y + F_z d z = F_x(partial_x / partial_u d u + partial_x / partial_v d v) + F_y(partial_y / partial_u d u + partial_y / partial_v d v) + F_z(partial_z / partial_u d u + partial_z / partial_v d v) $

整理为:

$ ( F_x partial_x / partial_u + F_y partial_y / partial_u + F_z partial_z / partial_u ) dot d u + ( F_x partial_x / partial_v + F_y partial_y / partial_v + F_z partial_z / partial_v ) dot d v = 0 $

$d u , d v$ 有任意性, 所以其系数应为 0, 即: $ F_x partial_x / partial_u + F_y partial_y / partial_u + F_z partial_z / partial_u = 0 $ $ F_x partial_x / partial_v + F_y partial_y / partial_v + F_z partial_z / partial_v = 0 $

所以 $ ( F_x , F_y , F_z ) = ( partial_x / partial_u , partial_y / partial_u , partial_z / partial_u ) times (partial_x / partial_v , partial_y / partial_v , partial_z / partial_v) $




