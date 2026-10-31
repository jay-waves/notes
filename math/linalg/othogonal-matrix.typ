
#import "@local/ypst-template:0.1.0": template, sidenote
#show: template

= 正交矩阵

- $Q^top Q = Q Q^top = E_n$
- $det Q = 1$
- $Q^top = Q^(-1)$

描述空间中一组正交的单位基底. 乘向量时 (表线性变换时), 使向量旋转, 长度不变; $det Q = - 1$ 时使向量镜像旋转 (改变手性).

设 $Q = [ q_1 \, q_2 \, dots.h \, q_n ]$, 那么有: 

$
q_i^T q_j = cases(
  1 "if" quad i = j,
  0 "if" quad i eq.not j
)
$

= 酉矩阵

#sidenote[
  酉矩阵 (幺正矩阵, Unitary Matrix) 是复数域 $bb(C)$ 上的正交矩阵, 记为 $U$.
][
  $A^H$ 共轭矩阵是指：对每个复数取共轭，再转置矩阵。
]

- $U^H U = U U^H = E_n$
- $U^(- 1) = U^H$
- $| lambda_n | = 1$
- $|U|=1$
- 酉矩阵不改变向量点积: 

$ ( U vec(x) ) dot ( U vec(y) ) = vec(x dot y) $
