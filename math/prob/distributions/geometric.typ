#import "@local/ypst-template:0.1.0": template, sidenote

#show: template

#let bmat(..args) = $mat(delim: "[", ..args)$
#let vmat(..args) = $mat(delim: "|", ..args)$

== 几何分布
几何分布 ($upright("Ber") - E_oo$) 指#link("https://notes.jay-waves.cn/math/prob/distributions/binomial/")[伯努利试验中]某事件首次出现的概率. 假设共进行 $k$ 次伯努利试验, 在第 $k$ 次试验时发生该事件, 这里包含第 $k$ 次试验的概率 $p$.

记为 $X tilde.op G(p)$

概率为 $P lr({X = k}) = (1 - p)^(k - 1) dot p$

期望为 $E X = 1 / p$, 方差为 $D X = frac(1 - p, p^2)$. 几何分布类似指数分布, 也没有记忆性.

== 超几何分布
随机变量 $X$ 表示从 $N$ 个对象的总体中不放回抽取 $n$ 个对象. 其中 $M$ 个为特殊类型对象, $k$ 表示抽取的 $n$ 个对象中特殊类型对象的数量. 记 $X tilde.op H(n , M , N)$.

离散概率分布为 $P lr({X = k}) = C_M^k C_(N - M)^(n - k) / C_N^n$

当 $n lt.double N$ 时, $p approx M / N$, $E X = frac(n M, N)$.

== 负二项式分布
负二项分布, 在整数环上也称为帕斯卡分布 (Pascal Distribution). 指重复 $n$ 次伯努利试验, 直到第 $r$ 次成功.

记为 $X tilde.op N B(r , p)$

概率为 $P lr({X = k}) = binom(k - 1, r - 1) p^r(1 - p)^(k - r), k gt.eq r$

期望为 $E X = r / p$, 方差为 $D X = frac(r(1 - p), p^2)$. 这里求 $E X$ 的技巧为, 将负二项分布视为 $r$ 个独立的几何分布, 因为 $r = 1$ 时负二项分布就退化为几何分布.






