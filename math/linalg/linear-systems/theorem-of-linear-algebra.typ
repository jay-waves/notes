#import "@local/ypst-template:0.1.0": template
#show: template

= 线性代数基本定理

任意秩为 $r$ 的矩阵 $A_(m times n)$ 可被奇异值分解: 
$
A = U Sigma V^top
$


因而, 矩阵 $A in bb(R)^(m times n)$ 产生了四个基本线性子空间:

#table(columns: 5,
  [名称],
  [记号],
  [包含于],
  [维数],
  [基],
  [列空间, 值域, 像],
  [${} upright("Im")(A)$ 或 ${} upright("Range")(A)$],
  [$bb(R)^m$],
  [r],
  [$U$ 的前 $r$ 列],
  [左零空间, 上核],
  [$upright("Ker") ( A top )$ 或 $upright("Null") ( A^top )$],
  [$bb(R)^m$],
  [m-r],
  [$U$ 的后 $m-r$ 列],
  [行空间, 余像],
  [$upright("Im") ( A^top )$ 或 $upright("Range") ( A^top )$],
  [$bb(R)^n$],
  [r],
  [$V$ 的前 $r$ 列],
  [零空间, 核],
  [${} upright("Ker")(A)$ 或 ${} upright("Null")(A)$],
  [$bb(R)^n$],
  [n-r],
  [$V$ 的后 $n-r$ 列],
)

其中, 存在两对#link("https://notes.jay-waves.cn/math/linalg/vectors/direct-sums-and-proj/")[直和与投影]:
- 在 $bb(R)^n$ 中, $upright("Ker") ( A ) = ( upright("Im") ( A^top )^tack.t$, 即零空间为行空间的正交补.
- 在 $bb(R)^m$ 中, $upright("Ker") ( A^top ) = ( upright("Im") ( A ) )^tack.t$, 即左零空间为列空间的正交补.

#figure(
  image("../../../assets/math/math-linalg-four-linear-subspaces.webp", width: 60%),
  caption: [Art of Linear Algebra]
)

#figure(
  image("../../../assets/math/math-linalg-four-linear-subspaces-2.webp", width: 60%),
  caption: [wikipedia]
)

上述结论能推广到 $bb(C)^(n times n)$, 即 $upright("Null") ( A ) xor upright("Range") ( A^H ) = bb(C)^n$

== 秩-零化度定理

...
