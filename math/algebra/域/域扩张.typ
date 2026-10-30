#import "@local/ypst-template:0.1.0": template, definition, lemma, theorem, proof, sidenote

#show: template

= 作为向量空间的扩域

1. $K, F$ 是两个域, $F \/ K$ 是个域扩张, $F$ 是 $K$ 的扩域, $K$ 是 $F$ 的子域.
2. 若 $F \/ K$ 是个域扩张, 则 $F$ 是 $K$ 上的#link("https://notes.jay-waves.cn/math/linalg/vectors/vector-space/")[向量空间].
3. 域扩张 $F \/ K$ 的次数是 $K$ 上线性空间 $F$ 的维数, 记作 $dim_K F$ 或 $[F : K]$.
  - 有限扩张: $[F : K] < infinity$.
  - 无穷扩张: $[F : K] = infinity$.

= 域的生成

设 $F \/ K$ 是域扩张, $S$ 是 $F$ 的子集, 则 $F$ 中包含 $K union S$ 的最小子域称作 $S$ 在 $K$ 上生成的域, 记作 $K(S)$.

也就是所有满足 $K union S subset.eq E lt.eq F$ 的中间域 $E$ 的交.

类似地可以定义 $S$ 在 $K$ 上生成的环 $K[S]$: $F$ 中包含 $K union S$ 的最小环.

有限生成域: 设 $a_1, a_2, dots.c, a_n in F$, 则域 $K(a_1, dots.c, a_n)$ 被称为 $K$ 的有限生成扩张.
只有一个生成元的域扩张称为单扩张, 记为 $K(a_1)$.
有限生成扩张的逆过程记为 $K(a_1, a_2) = (K(a_1))(a_2)$.

设 $u, u_i in F$, $S subset.eq F$, $x, x_i$ 均为未定元:

- 单扩环:
  $
  K[u] = {f(u) | f(x) in K[x]}
  $
  $
  K[u_1, dots.c, u_n] = {f(u_1, dots.c, u_n) | f(x_1, dots.c, x_n) in K[x_1, dots.c, x_n]}
  $
  $
  K[S] = {f(u_1, dots.c, u_n) | forall u_i in S, f(x_1, dots.c, x_n) in K[x_1, dots.c, x_n], n in bb(Z)_+}
  $
- 单扩域:
  $
  K(u) = {f(u) \/ g(u) | f, g in K[x], g(u) != 0}
  $
  $
  K(u_1, dots.c, u_n) = {(f \/ g)(u_1, dots.c, u_n) | f, g in K[x_1, dots.c, x_n], g(u_1, dots.c, u_n) != 0}
  $
  $
  K(S) = {(f \/ g)(u_1, dots.c, u_n) | forall u_i in S, f, g in K[x_1, dots.c, x_n], g(u_1, dots.c, u_n) != 0, n in bb(Z)_+}
  $

易知 $K[u] subset.eq K(u)$.

= 代数扩张

在域扩张 $F \/ K$ 中:
- 代数元素: 存在 $p(x) in K[x]$, $p(x) != 0$, $p(a) = 0$.
- 超越元素: 对任意 $p(x) in K[x]$, $p(x) != 0$, 都有 $p(a) != 0$.
- $a in F$ 是 $K$ 上的代数元素: $K(a) \/ K$ 是有限扩张.
- $a in F$ 是 $K$ 上的超越元素: $K(a) \/ K$ 是无限扩张.
- $forall a in F$ 都是 $K$ 上的代数元素, 则 $F \/ K$ 是代数扩张.
- $exists a in F$ 是 $K$ 上的超越元素, 则 $F \/ K$ 是超越扩张.

#theorem[$F$ 中 $K$ 的代数元素全体构成 $F$ 的子域.]

#theorem[$F \/ K$ 是有限扩张, 当且仅当它既是有限生成扩张, 又是代数扩张.]

#theorem[
  若 $E$ 是域, $F \/ E$ 和 $E \/ K$ 均为代数扩张, 则 $F \/ K$ 也是代数扩张.
  如果它们都是有限扩张, 则 $[F : K] = [F : E] [E : K]$.
]

== 最小多项式

#definition[
  存在唯一的首一非零多项式 $p(x)$, 使得每个有根为 $a$ 的多项式 $f(x) in K[x]$ 被 $p(x)$ 整除.
  称 $p(x)$ 为 $a$ 在 $K$ 上的最小多项式或极小多项式, 记为 $m_(a,K)(x)$.
]

#theorem[
  最小多项式是不可约的, 且 ${f(x) in K[x] | f(a) = 0} equiv (p(x))$.
]

== 单代数扩张

#theorem[$K(a)$ 的结构-环同构: $K[x] \/ (p(x)) tilde.eq K(a)$.]

#theorem[
  $K(a)$ 的结构-线性空间: 若 $deg p = n$, 则 ${1, a, dots.c, a^(n - 1)}$ 是 $K(a)$ 在 $K$ 上的一组基, 即 $K(a) = K[a]$.
]

#proof[
  设 $alpha$ 为 $K$ 上的代数元素, 定义同态映射
  $
  phi: K[x] -> K(alpha).
  $

  存在非零 $f(x) in K[x]$, 使得 $f(alpha) = 0$.
  映射 $phi$ 的非零同态核空间为
  $
  ker phi = {f in K[x] | f(alpha) = 0}.
  $

  取 $p(x)$ 为满足 $p(alpha) = 0$ 的 $n$ 次极小多项式, 非零、首一、度最小.
  于是它是 $K[x]$ 主理想的生成元, 记
  $
  J_alpha = (p(x)) = {f(x) dot p(x) | p(alpha) = 0, f(x) in K[x]}.
  $

  于是 $ker phi = (p(x))$.
  由环第一同构定理, 得到 $K[x] \/ (p(x)) tilde.eq upright("Im")(phi)$.
  $
  upright("Im")(phi) = {f(x) + J_alpha | f(x) in K[x]}
    = {[f(x) mod p(x)] | f(x) in K[x]}
    = K[alpha]
  $

  对应的同构映射为
  $
  overline(phi)([f(x) mod p(x)]) = overline(phi)(f(x) + J_alpha) = f(alpha).
  $
]

#lemma[$K[alpha] = K(alpha)$]

#proof[
  ${[f(x) mod p(x)] | f(x) in K[x]} = K[alpha]$.
  因为 $p(x)$ 是不可约多项式, 所以任意非零多项式 $f(x) in K[x]$ 在模 $p(x)$ 时都有逆元.
  由域的定义知, $K[alpha]$ 实际是域, 即 $K[alpha] = K(alpha)$.
  所以 $K[x] \/ p(x) tilde.eq K(alpha)$.
]

=== 同构的替代构造

$F -> F'$ 是一个域同构, $p(x) = sum_(i=0)^n a_i x^i in F[x]$ 是一个不可约多项式, 且 $p'(x) = sum_(i=0)^n phi(a_i) x^i in F'[x]$.
若 $alpha$ 是 $p(x)$ 的一个根, $beta$ 是 $p'(x)$ 的一个根, 则存在同构:
$
sigma: F(alpha) -> F'(beta), quad alpha |-> beta
$
使得 $sigma|_F = phi$.

= 超越扩张

...
