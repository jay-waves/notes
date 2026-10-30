#import "@local/ypst-template:0.1.0": template, theorem, lemma, corollary, proof, sidenote

#show: template

#let GF(x) = $upright("GF")(#x)$
#let ZZ = $bb(Z)_p$
#let FF = $bb(F)_p$

$F = #GF($p^n$)$ 是有限域.

= 线性结构

#theorem[
  $upright("char")(#GF($p^n$)) = p$ 是一个素数, 并且 $F \/ #ZZ$ 是有限扩张.
]

#proof[
  域的特征只能是 0 或某个素数 $p$.
  若 $upright("GF")$ 的特征为 0, 则 $upright("GF")$ 有素子域 $bb(Z)$, 从而 $upright("GF")$ 必为无限域, 矛盾.
  于是 $upright("char")(F) = p$.
  由#link("https://notes.jay-waves.cn/math/algebra/%E5%9F%9F/%E5%9F%9F%E6%89%A9%E5%BC%A0/")[有限扩张]的定义, $F \/ #ZZ$ 是有限扩张.
]

#corollary[
  Frobenius 自同构 $phi: x -> x^p$ 满足
  $
  (a + b)^p = a^p + b^p \
  (a b)^p = a^p b^p
  $
]

#theorem[
  $F$ 是 $#ZZ$ 上的线性空间. 记 $[F : #ZZ] = n$, 则 $|F| = p^n$.
]

#proof[
  因为 $upright("char")(F) = p$, 所以 $upright("GF")$ 有一个子域 $#ZZ$.
  于是 $upright("GF")$ 是 $#ZZ$ 上的线性空间.
  因为 $[upright("GF") : #ZZ] = n$, 所以可取 ${e_1, ..., e_n} subset upright("GF")$ 为 $upright("GF")$ 在 $#ZZ$ 上的一组基, $upright("GF")$ 中的每个元素都可以唯一地表示为:
  $
  sum_(i = 1)^n a_i e_i, quad forall a_i in #ZZ.
  $
  从而 $|upright("GF")| = |#ZZ|^n = p^n$.
]

这实际说明 $F$ 作为加法群是 $n$ 个 $p$ 阶循环群的直积.

= 乘法结构

$(F^times, dot.op)$ 为 $p^n - 1$ 阶循环群. 若 $F^times$ 由元素 $u$ 生成, 则 $F = #ZZ (u)$.

#theorem[
  对于有限域 $#GF($p^n$)$ 的任意元素, 都满足多项式 $x^(p^n) - x = 0$.
]

#proof[
  $#GF($p^n$)^times$ 是循环群 $chevron.l g chevron.r$, 阶为 $p^n - 1$, 所以任意非零域元素满足 $x^(p^n - 1) = 1$.
  又 $x = 0$ 时, 满足 $x^(p^n) = x$.
  综上, 有限域任意元素满足 $x^(p^n) = x$.

  #quote(block: true)[
    请将 $#GF($p^n$)$ 与 $Z \/ Z_(p^k)$ 区分开, $Z \/ Z_(p^k)$ 只是环. 即 $x^(p^k) equiv.not x mod p^k$.

    另外, 同时证明了上述 Frobenius 映射的*自同态*性质.
  ]
]

#corollary[
  多项式 $x^(p^n) - x$ 在 $#GF($p^n$)$ 上可以完全线性因式分解:
  $
  x^(p^n) - x = product_(a in #GF($p^n$)) (x - a)
  $
]

这说明了 $#GF($p^n$)$ 必然是 $upright("GF")(p)[x]$ 中 $p^n$ 阶多项式 $f(x)$ 构成的分裂域, 也是包含 $f(x)$ 所有根的最小域扩张.

#lemma[
  $f(x) in bb(F)_p[x]$, $f(x) divides x^(p^n) - x$, 当且仅当 $d := deg f(x) divides n$.
]

#proof[
  假设 $f(x) divides h(x) := x^(p^n) - x$.
  因为 $h(x)$ 能够在 $bb(F)_(p^n)$ 上完全因式分解, 所以 $f(x)$ 也是.
  取 $alpha in bb(F)_(p^n)$ 是 $f(x)$ 的一个根. 有 $#FF (alpha) subset bb(F)_(p^n)$, 并且 $[#FF (alpha) : #FF] = d$.
  于是
  $
  n = [bb(F)_(p^n) : #FF]
    = [bb(F)_(p^n) : #FF (alpha)] [#FF (alpha) : #FF],
  $
  所以 $d divides n$.
]

$x^(p^n) - x$ 在有限域 $#GF($p^n$)$ 上可以完全线性分解, 但是在更小的基域 $#GF($p^m$)$ 上不能完全分解.
即在 $#GF($p^m$), m < n$ 上含有次数大于一的不可约多项式 $f(x)$.
由上述定理, 当且仅当 $m divides n$ 时, 取 $d dot m = n$, 度为 $d$ 的不可约多项式 $f(x) divides x^(p^n) - x$, 这意味着通过代数扩域构造的有限域 $G(p^m) \/ (f(x)) tilde.eq G(p^n)$.

#corollary[
  $p^m$ 阶域是 $p^n$ 阶域的子域, 当且仅当 $m divides n$.
]

这里的详细证明涉及到#link("https://en.wikipedia.org/wiki/M%C3%B6bius_function")[莫比乌斯函数], 再说.

#theorem[
  对任意素数 $p$ 和自然数 $n$, $p^n$ 阶有限域必然存在, 且在同构意义下唯一.
]

#proof[
  如果在素域 $#FF$ 上总能找到任意 $n$ 阶不可约多项式 $f(x)$, 就能用其扩张为有限域 $#GF($p^n$)$.
  所以问题等价于证明: 素域存在任意阶不可约多项式.
]

#sidenote[
  #lemma[
    素域 $#FF$ 上总能找到任意 $n$ 阶不可约多项式.
  ]
][
  这里遇到了“Frobenius 映射、有限域存在性、不可约多项式存在性”的循环证明. 现在倾向于“不可约多项式的存在性”是更基础的代数结果, 是前两者的原因而不是结果.
]

#proof[
  由前述推论可知, $K = {x | x^(p^n) = x}$ 是分裂域, 并且有阶 $p^n$.
  于是 $K tilde.eq #GF($p^n$)$, 其中 $K^times$ 是乘法循环群, 设其生成元为 $alpha$, 即 $K^times = chevron.l alpha chevron.r$.
  观察到 $K = #FF (alpha)$, 即 $K$ 同样是 $#FF$ 上以 $alpha$ 为生成元的单代数扩张.
  因为域扩张的次数等于在 $#FF$ 上关于 $alpha$ 的最小多项式的次数, 所以其次数必须为 $[K : #FF] = n$.
  于是, 在 $#FF$ 上总存在 $n$ 阶不可约多项式.
]

#corollary[
  将 $#FF$ 换为 $bb(F)_(p^k)$, 将 $K$ 换为 $#GF($(p^k)^n$)$, 可推广到任意有限域上.
]

== 参考

- #link("https://math.stackexchange.com/q/2895251")[Proving that $f(x)$ divides $x^(p^n) - x$ iff $deg f(x)$ divides $n$]
- #link("https://math.stackexchange.com/q/144724")[Existence of irreducible polynomials over finite field]
