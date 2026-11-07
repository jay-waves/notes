---
copyright: [JayWaves (2024), ]
revised: 24-11-17
math-engine: mathjax
---


## 有限域

有限域, (伽罗华域, Galois Fields), $GF(p^{n})$ 满足下列性质的多项式环 $\mathbb{Z}_{p}[x]\text{ mod }p(x)$:
- ${} p(x)\in \mathbb{Z}_{p}[x] {}$
- $p(x)$ 是不可约多项式
- $deg(p(x))=n$, 即, 有 $n+1$ 个系数.

**$GF(p^{n})$ 有 $p^n$ 个元素, 并且是除零循环群.**

***

## 扩域的极小多项式

对于有限域 $GF(p^{n})\simeq GF(p)[x]/(f(x)),\quad def(f)=n$, $\alpha$ 是不可约多项式 $f(x)$ 在更大扩域 ($GF(2^{m}),\quad m>n$) 上的根. 此时 $GF(p^{n})=\set{0,1,\alpha,\alpha^{2},\alpha^{3},\dots,\alpha^{p^{n}-2}}$, $\alpha^{p^{n}-1}=1$.

极小多项式是以 $\alpha$ 为根的度最小首一不可约多项式 ${} p(x)\in GF(p)[x] {}$, 其系数 $c_{i}\in GF(p)$, 次数可能小于 $f(x)$. 假设在扩域上, $f(x)=0$ 有解 $\alpha,\beta\in GF(p^{m}),\quad \alpha, \beta\not\in GF(2^{n})$, 此时在扩域上 $f(x)$ 可分解为 $f(x)=(x-\alpha)(x-\beta)P(x)$, 显然并不是 $\alpha$ 的极小多项式, 包含了多余的项 $(x-\beta)$.

### 共轭元素

对于有限域 $GF(p^{n})$, 设 $\alpha$ 为其扩域 ($GF(p^{m}),\quad m>n$) 的一个元素, 则其共轭元素指: $$\set{\alpha, \alpha^{p},\alpha^{p^{2}},\dots,\alpha^{p^{n-1}}}$$

由于 $\large x^{p^{n}}=x$, 所以这些共轭元素构成了一个代数闭合的集合.

设 $\alpha$ 在 ${} GF(p^{n}) {}$ 上的极小多项式为 ${} m(x)=c_{n}x^{n}+c_{n-1}x^{n-1}+\dots {}$, 根据有限域的 Frobenius 自同构: $\alpha:\to \alpha^{p}$, 可以得到: $$\begin{align}
m(\alpha^{p}) & =c_{n}(\alpha^{p})^{n}+c_{n-1}(\alpha^{p})^{n-1}+\dots+c_{1}\alpha^{p}+c_{0},\quad c_{i}\in GF(p) \\
 & =(c_{n}\alpha^{n})^{p}+(c_{n-1}\alpha^{n-1})^{p}+\dots.+(c_{1}\alpha)^{p}+c_{0}^{p} \\
 & =(c_{n}\alpha^{n}+c_{n-1}\alpha^{n-1} +\dots+c_{1}\alpha+c_{0})^{p} \\
 & =m^{p}(\alpha) =0
\end{align}$$

同理可以扩展到 $\alpha^{p^{i}}$ 上. 因此在 $GF(p^{n})$ 上, $\alpha$ 的共轭元素是其极小多项式的所有根, 即 $m(x)$ 可代数分解为: 

$$m(x)=(x-\alpha)(x-\alpha^{p})(x-\alpha^{p^{2}})\dots(x-\alpha^{p^{n-1}})$$, 其中 ${} n$ 是元素的扩展次数. 换言之, $\alpha^{p^{i}}$ 共享同一个极小多项式.

***

## $GF(2)$

域 F 元素个数有限时, 称为**有限域**, 不妨令其元素个数为 n, 则记有限域为 $\mathbb{GF}(n)$.  **$n$ 的形式一定是 $n=p^{m}$**, 当 m=1 时, 该域称为素域; n>2 时, 称为扩展域. 扩展域 $\mathbb{GF}(p^{n})$ 使用**多项式**来表达和简化 ....

## $GF(2^n)$

伽罗华域 $GF(2^{n})$ 类似 欧式空间里的**n维向量空间 $\{0,1\}^{n}\equiv GF^{n}(2)$**, 也可以类比为 $F\{\textbf{二进制数}, \oplus\}$

### $GF(2^n)$ 上加法

表示 $GF(2^{n})$ 上元素的二进制数 $A, B$, 它们的加法或减法等价于异或操作: $$C=A\oplus B$$

### $GF(2^n)$ 上乘法

$GF(2^{n})$ 上多项式乘法有两部分组成:普通二进制乘法 + 取模不可约多项式.

```python
def gf2n_mul(a, b, p, n):
	result = 0
	for i in range(n):
		if (b >> i) & 1:                  # 如果 b 的第 i 位为 1, 则累加 a 左移 i 位
			result ^= (a << i)

	# 模不可约多项式
	for i in range(2 * n - 2, n - 1, -1): # 对于 a, b < 2^n, 乘积最高次为 2^{2n-2}
		if result & (1 << i):             # 依次检查是否需要取模
			result ^= (p << (i - n + 1))
	return result

```
