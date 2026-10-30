#import "@local/ypst-template:0.1.0" : template, definition, proof

#show: template

= 线性变换

映射 $T : V arrow.r W$, 其中 $V,W$ 是线性空间. $T$ 满足: 
- 齐次性 (Homogeneity): $f ( alpha dot.op x ) = alpha dot.op f ( x )$
- 加法性 (Additivity): $f(x+y)=f(x)+f(y)$

此时称 $T : V arrow.r W$ 为线性映射. 当 $V=W$ 时, 称 $T$ 是 $V$ 上的线性变换. 

齐次性, 保证线性变换前后, 向量仍在同一直线上. 加法性, 保证了线性变换前后, 原点位置不变 $f(x+0)=f(x)+f(0)$. 

== 例子

$T : V arrow.r V$
- 零变换: $T ( x ) = 0 \, forall x in V$
- 恒等变换: $T ( x ) = x \, forall x in V$
- 负变换; $T ( x ) = - x \, forall x in V$

$T : bb(R)^2 arrow.r bb(R)^2$: 
- 伸缩: $T ( x ) = mat(delim: "[", k_1, 0; 0, k_2)$
- 反射: $T ( x ) = ( x_1 \, - x_2 )$
- 旋转: $T ( x ) = mat(delim: "[", cos phi, - sin phi; sin phi, cos phi)$

== 多元函数线性变换

多元函数的线性变换 $f : bb(R)^n arrow.r bb(R)^m$ 定义为: 
- 齐次性: 
$
f ( alpha dot.op x_1 \, alpha dot.op x_2 \, dots.h.c \, alpha dot.op x_n ) = alpha^k f ( x_1 \, x_2 \, dots.h.c \, x_n )
$
 其中 $k in bb(R)$ 可以不等于 $n$
- 加法性: 
$
f ( x_1 \, x_2 \, dots.h.c \, x_n ) + f ( y_1 \, y_2 \, dots.h.c \, y_n ) = f ( x_1 + y_1 \, med x_2 + y_2 \, med dots.h.c \, med x_n + y_n )
$


齐次性也等价于: 
$
f ( x_1 \, x_2 \, dots.h.c \, x_n ) = x_1^k dot.op phi.alt ( x_2 \, x_3 \, dots.h.c \, x_n )
$


= 线性映射空间

$T_1 \, T_2 in cal(L) ( V \, W )$, 定义*线性映射的加法运算*: 
$
( T_1 + T_2 ) ( x ) = T_1 ( x ) + T_2 ( x ) \, quad forall x in V
$


$T in cal(L) ( V \, W ) \, lambda in F$, 定义*线性映射的数乘运算*: 
$
( lambda T ) ( x ) = lambda dot.op T ( x ) \, quad forall x in V
$


*线性映射空间* $cal(L)(V,W) = {T: V -> W | "T 是线性映射"}$, 维数为: 
$
upright("dim") cal(L) ( V \, W ) = upright("dim") V times upright("dim") W
$


当 $V=W$ 时, 称为*线性变换空间* $cal(L) ( V \, V )$. 

#definition[
  对于线性映射 $T in cal(L) ( V \, W )$: 

  *核空间 (零空间)*: $upright("Ker")(T)=N(T)={x in V | T(x)=0}$

  *像空间 (值空间)*: $upright("Im")(T)=R(T)={y in W | y=T(x), forall x in V}$

  *零度 (亏)*: $dim N(T)$

  *秩*: $dim R(T)$
]

= 亏加秩定理

也称为#link("https://notes.jay-waves.cn/math/linalg/linear-systems/theorem-of-linear-algebra/")[线性代数基本定理]:

$upright("dim") N ( T ) + upright("dim") R ( T ) = upright("dim") V$

#definition[
  同构映射: $T : V arrow.r W$ 是双射, 同时是线性映射. 

  对于同构映射 $T$, 满足:
  1. 单位元保持: $T(0)=0$
  2. 逆元保持: $T(-x)=-T(x)$
  3. 基底保持: $epsilon_1 \, dots.h \, epsilon_n$  是 $V$ 的一组基, 则 $T ( epsilon_1 ) \, dots.h \, T ( epsilon_n )$ 是 $W$ 的一组基.
]

#proof[因为 $T$ 是双射, 所以 $upright("Ker")(T)={0}, upright("Im")(T)=W$. 又因为 $upright("dim") V = upright("dim") upright("Ker") ( T ) + upright("dim") upright("Im") ( T )$, 所以 $upright("dim") V = upright("dim") W$.]
