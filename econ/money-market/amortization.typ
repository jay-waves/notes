#import "@local/ypst-template:0.1.0": template, sidenote

#show: template

= Amortization Schedule (贷款摊还算法, 折现法)

假设，贷款名义本金为 $N$，年利息利率 $r$ ，计息时间比例 $alpha_i = frac(T_i - T_(i-1), 365)$ 。
每期固定付款 $A$ 先支付利息 $I_i$，剩余偿还本金 $P_i$，并更新贷款余额 $B_i$。

贷款开始时，$B_0 = N$ ，折现因子为 $D_0 = 1$，付款日期确定为 $T_0, dots, T_m$

== 确定每期还款额

折现因子递推公式： #footnote[见远期利率一文 ./forward-rate.md]

$
  D_i = frac(D_(i-1), 1 + r alpha_i)
$

未来付款现值应该等于初始本金：

$
  N = sum_(i=1)^m A D_i
  quad => quad
  A = frac(N, sum_(i=1)^m D_i)
$

== 逐期摊还

每期需要经过经过如下步骤：

#table(
  columns: (1fr, 2fr, 2fr),
  [步骤], [公式], [含义],
  [计息], [$I_i = B_(i-1) r alpha_i$], [按期初余额计息],
  [还本], [$P_i = A - I_i$], [付款扣除利息],
  [余额], [$B_i = B_(i-1) - P_i$], [扣除偿还本金],
  [现值], [$"PV"_i = A D_i$], [当期付款折现],
)

计息、还本、余额公式合并为：

$
  B_i = B_(i-1)(1+r alpha_i)-A
$

即：*期末余额 = 期初余额 + 利息 − 付款*。

同乘 $D_i$ ，由折现递公式得到：

$
  B_i D_i
  &= B_(i-1) D_(i-1) - A D_i \
  &= N - sum_(j=1)^i A D_j
$

*含义：剩余本金现值 = 初始本金 - 已付款现值*

当第 $m$ 期全部还清，满足：

$
  sum_(i=1)^m A D_i = N, quad 
  sum_(i=1)^m P_i = N, quad
  B_m &= 0
$

= APPENDIX

不用折现法，从正向也能推导出 $A$ 的公式：

$
  B_i = B_(i-1)(1+q_i)-A
$

逐期展开：

$
  B_1 &= N(1+q_1)-A \
  B_2 &= N(1+q_1)(1+q_2)-A[(1+q_2)+1] \
  B_3 &= N product_(k=1)^3 (1+q_k)
    -A[(1+q_2)(1+q_3)+(1+q_3)+1]
$

推广至第 $m$ 期：

$
  B_m = N product_(k=1)^m (1+q_k)
  - A sum_(j=1)^m product_(k=j+1)^m (1+q_k)
$

令 $B_m=0$（末期还清），解得：

$
  A = frac(
    N product_(k=1)^m (1+q_k),
    sum_(j=1)^m product_(k=j+1)^m (1+q_k)
  )
$

分子分母同除以 $product_(k=1)^m (1+q_k)$：

$
  A = frac(
    N,
    sum_(j=1)^m frac(1, product_(k=1)^j (1+q_k))
  )
$

定义折现因子：

$
  D_j = product_(k=1)^j (1+q_k)^(-1)
  = frac(D_(j-1), 1+q_j),
  quad D_0=1
$

最终得到：

$
  A = frac(N, sum_(j=1)^m D_j)
$

