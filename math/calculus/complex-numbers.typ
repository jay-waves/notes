#import "@local/ypst-template:0.1.0": template, sidenote

#show: template

#let bmat(..args) = $mat(delim: "[", ..args)$
#let vmat(..args) = $mat(delim: "|", ..args)$

复数: $z = x + i dot y$, xy 均为实数, i 为虚数单位, 满足: $i^2 = - 1$.

x 称为 z 的实部, y 为 z 的虚部, 表示为: $x = R e(x) , med y = I m(z)$. 复数集合为 $bb(C)$.

=== 复平面
x, y 可以视为复平面坐标. y 轴单位是 i.

#strong[极坐标表示]为 $z = r times ( cos(phi) + i dot sin(phi) )$, $r$ 为辐值, $phi$ 为辐角.

转化公式: $ {x = r times cos(phi)\
y = r times sin(phi) $

由欧拉公式: $ e^(i dot phi) = cos(phi) + i dot sin(phi) $

复平面极坐标可简化为: $z = r times e^(i dot phi)$.

定义幅值为 $| z | = r = sqrt(x^2 + y^2)$

==== 复平面单位根
根据#link("https://notes.jay-waves.cn/math/algebra/%E7%8E%AF/%E5%A4%9A%E9%A1%B9%E5%BC%8F%E7%8E%AF/")[代数基本定理], $ x^n = 1 $ 在复数域上有 $n$ 个解, 分别为: $ exp [frac(2 k pi i, n)] = cos (frac(2 k pi, n)) + i dot sin (frac(2 k pi, n)) , quad k = 0 , 1 , 2 , dots.h , n - 1 $ 这些根都在复平面的单位元上, 将圆平均切分为 $n$ 份.

==== 复平面旋转
$e^(phi dot i) = cos(phi) + i dot sin(phi)$, 表示复平面单位圆周上的点.

$e^(i 2 pi dot t)$, 周期为 1s 绕复平面单位圆周旋转的弧长. (弧频率)

$e^(i 2 pi dot f t)$, 以频率 f 旋转, 幅度为 1.

$e^(a + i 2 pi dot f t)$, 以频率 f 旋转. $a in bb(R)$ 且 $a eq.not 0$ 时, 复平面是螺旋线.

$g(t) dot e^(i 2 pi dot f t)$, 以频率 f 旋转, 幅度为 $g(t)$.





