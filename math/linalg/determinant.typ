#import "@local/ypst-template:0.1.0": template, sidenote, theorem, corollary, proof

#set document(title: [行列式])
#show: template

== 行列式等值变换

..

== 范德蒙行列式

对于向量 ${} (x_1, x_2, ..., x_n) {}$，范德蒙矩阵是一个 $n times n$ 的矩阵.

范德蒙矩阵:



$
V = mat(delim: "[", 
1, x_(1), x_(1)^(2), x_(1)^(3), ..., x_(1)^(n - 1) ; 
1, x_(2), x_(2)^(2), x_(2)^(3), ..., x_(2)^(n - 1) ; 
1, x_(3), x_(3)^(2), x_(3)^(3), ..., x_(3)^(n - 1) ; 
dots.v, dots.v, dots.v, dots.v, dots.down, dots.v ; 
1, x_(n), x_(n)^(2), x_(n)^(3), ..., x_(n)^(n - 1))
$

范德蒙行列式 (Vandermonde Matrix):

$
| V | = product_(1 <= i < j <= n)(x_j- x_i)
$

#proof[...]

== 块三角矩阵


$
A = mat(delim: "[", B, C ; 0, D)
$


#theorem[
  $
  det A = det B det D
  $
]

#proof[
  $
  A = mat(delim: "[", I, C D^(- 1) ; 0, I) mat(delim: "[", B, 0 ; 0, D)
  $
]

#corollary[
  $
  det (A - lambda I)= det (B - lambda I)det (D - lambda I)
  $
]

#corollary[
  $
  A = mat(delim: "[", A_(1 1), A_(1 2), ..., A_(1 m) ; 
  0, A_(2 2), ..., A_(3 m) ; 
  dots.v, dots.v, dots.down, dots.v ; 
  0, 0, ..., A_(m m))
  $

  其中每个 ${} A_(i i) {}$ 皆是方阵, 那么有: 
  $
  det A=product^m_(i=1)det A_(i i)
  $
]
