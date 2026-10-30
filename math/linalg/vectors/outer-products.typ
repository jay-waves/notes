#import "@local/ypst-template:0.1.0" : template

#show: template

= 叉乘

在#link("https://notes.jay-waves.cn/math/linalg/vectors/inner-product/")[三维欧几里得空间]中，定义*叉乘（cross product）*： $arrow(a) times arrow(b)$ ，结果是一个向量，方向垂直于 $accent(a \, b, ⃗)$ ，由右手定则确定。（右手从 $a$ 握向 $b$）



$
arrow(a) times arrow(b) = mat(delim: "|", arrow(i), arrow(j), arrow(k); a_1, a_2, a_3; b_1, b_2, b_3)
$


满足反对称性： 
$
a times b = - b times a
$

线性： 
$ ( a + c ) times b = a times b + c times b $


模长：

$ |arrow(a); times arrow(b)|=|arrow(a)|norm(arrow(b))sin theta $



$
| arrow(a) times arrow(b) |^2 = | arrow(a) |^2 | arrow(b) |^2 - ( arrow(a) dot.op arrow(b) )^2
$



三重标量积： 
$
a dot.op ( b times c ) = b dot.op ( c times a ) = c dot.op ( a times b )
$


向量三重积：


$
a times ( b times c ) = ( a dot.op c ) b - ( a dot.op b ) c
$


= 外积
