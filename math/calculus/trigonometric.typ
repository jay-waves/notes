#import "@local/ypst-template:0.1.0": template, sidenote

#show: template

#let bmat(..args) = $mat(delim: "[", ..args)$
#let vmat(..args) = $mat(delim: "|", ..args)$

== 欧拉公式
欧拉公式: $ e^(i theta) = cos(theta) + i sin(theta), quad i = sqrt(-1) $

棣莫弗 (de Moivre's) 公式: $ cos(phi theta) + i sin(theta phi) = e^(i phi theta) = (e^(i theta))^phi = (cos theta + i sin theta)^phi $

该公式可以用#link("https://notes.jay-waves.cn/math/linalg/congruence/")[旋转矩阵]描述: $ R = mat(delim: "(", cos theta, - sin theta; sin theta, cos theta) $

=== 三角平方和公式
$ e^(i x) dot e^(- i x) = 1 = ( cos x + i sin x ) ( cos(- x) + i sin(- x) ) = cos^2 x + sin^2 x $

=== 反双曲函数
$ e^(i x) & = cos x + i sin x\
e^(- i x) & = cos x - i sin x $

解得: $ cases(cos x = frac(e^(i x) + e^(-i x), 2), sin x = frac(e^(i x) - e^(-i x), 2 i)) $

=== 二倍角公式
令棣莫弗公式中 $phi = 2$, 得到: $ ( e^(i theta) )^2 = cos 2 theta + i dot sin 2 theta = ( cos theta + i sin theta )^2 $

虚实对应有: $ cos(2 theta) & = cos^2 theta - sin^2 theta\
sin(2 theta) & = 2 sin theta cos theta $

=== 和差角公式
$ cos(alpha + beta) + i sin(alpha + beta) & = e^(i(alpha + beta))\
 & = e^(i alpha) dot e^(i beta)\
 & = [ cos alpha + i sin alpha ] [ cos beta + i sin beta ]\
 & = [ cos alpha cos beta - sin alpha sin beta ] + i [ sin alpha cos beta + cos alpha sin beta ] $






