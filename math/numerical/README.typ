#import "@local/ypst-template:0.1.0": template, sidenote

#show: template

#let bmat(..args) = $mat(delim: "[", ..args)$
#let vmat(..args) = $mat(delim: "|", ..args)$


计算机只能完成加减乘除运算, 并且精度有限. 所有数值访问都需要控制误差导致的精度损失, 并用简单问题近似替代复杂问题: 1. 用有限空间代替无限维空间 2. 用有限过程代替无限过程 3. 用代数方程代替微分方程 4. 用线性方程代替非线性问题 5. 用低阶系统代替高阶系统 6. 用简单函数代替复杂函数 7. 用简单结构的矩阵代替一般结构的矩阵

数值计算过程中的误差: \* 截断误差: 指数值方法做近似处理时的误差 \* 舍入误差: 数据只能用有限位表示导致的误差.

== 误差
误差 $e = x - tilde(x)$

误差界 (误差限): $| e | lt.eq epsilon$

相对误差: $e_r = e / x$

设 $tilde(x)$ 为 $x$ 的近似值, 若 $tilde(x)$ 的前 $p$ 位有效数字 ($p gt.eq 1$) 正确, 则其相对误差限满足: $ | e_r | < 1 / d_0 times 10^(- p + 1) $, 其中 $d_0$ 为 $tilde(x)$ 的第一位有效数字.

设 $tilde(x)$ 为对 $x$ 四舍五入 (保留 $p$ 位有效数字) 后得到的近似值, 则其相对误差限满足: $ | e_r | < frac(1, 2 d_0) times 10^(- p + 1) $.

=== 范数
==== 向量范数
#strong[向量范数]是在 $bb(R)^n$ 上的实值函数, 用于定义向量的大小: 1. 正定性: $norm(x) gt.eq 0$, 当且仅当 $x = 0$ 时, $norm(x) = 0$ 2. 齐次性: 任意数 $k in bb(R)$, 有 $norm(k x) = | k | dot norm(x)$ 3. 三角不等式: $norm(x + y) lt.eq norm(x) + norm(y)$.

对于 $x in bb(R)^n$, 有一范数:

$ norm(x)_1 = sum_(i = 1)^n | x_i | $

欧几里得范数: $ norm(x)_2 = sqrt(sum_(i = 1)^n x_i^2) $

无穷范数: $ norm(x)_oo = max_(1 lt.eq i lt.eq n) | x_i | $

==== 矩阵范数
#strong[矩阵范数]: 1. 正定性 2. 齐次性 3. $norm(A + B) lt.eq norm(A) + norm(B)$ 4. $norm(A B) lt.eq norm(A) norm(B)$

#strong[矩阵范数需要与某种向量范数相容], 即: $norm(A x) lt.eq norm(A) dot norm(x)$.

一范数: 即矩阵各#strong[列元素]的绝对值之和的最大值, 称为#strong[列范数]:

$ norm(upright(bold(A)))_1 = max_j sum_i | a_(i j) | $

二范数: 即矩阵$A^T A$的最大特征值, 称为#strong[谱范数]:

$ norm(upright(bold(A)))_2 = sqrt(lambda_(upright("max")) ( A^T A )) $

无穷范数: 即矩阵各#strong[行元素]的绝对值之和的最大值, 称为#strong[行范数]:

$ norm(upright(bold(A)))_oo = max_i sum_j | a_(i j) | $

F范数: 类似地对应了向量的二范数, 矩阵的每个元素开方后求和:

$ norm(upright(bold(A)))_(upright("F")) = sqrt(sum sum a_(i j)^2) $

=== 数值稳定性
==== 1. 避免舍入误差传播
==== 2. 避免小数加到大数
浮点数加法不是严格结合律的. 求和时, 先将小数累加, 再加大数. 或者使用 Kahan 补偿求和.

==== 3. 避免两个近似值相减
$x = a + epsilon_0$, $y = b + epsilon_1$

各自的相对误差:

$delta x = epsilon_0 / a$, $delta y = epsilon_1 / b$

如果 $a approx b$, 直接相减时, 相对误差占比会放大:

$delta(x - y) = frac(epsilon_0 - epsilon_1, a - b)$

可以采取 代数变换 或者 泰勒级数展开 的方式, 避免相近数的减法.

==== 4. 避免除数远小于被除数
==== 5. 迭代问题
迭代问题需要平衡舍入误差与截断误差 \* 当迭代步长过小, 计算机浮点数舍入误差会积累, 并且迭代速度过慢 \* 当迭代步长过大, 算法的截断误差会导致数值稳定性下降

== 方程组求解
高斯消元法, LU 分解, OR 分解, 乔莱斯基分解, QR 分解, 雅各比法, 共轭梯度法

== 特征值求解
奇异值分析

== 函数逼近
插值法, 快速傅里叶变换

=== 函数求解
牛顿法, 二分法

== 偏微分方程
== 数值积分
== 最优化问题
线性规划, 非线性规划





