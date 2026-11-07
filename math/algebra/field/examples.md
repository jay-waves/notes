---
math-engine: mathjax
---



#### $p = 1, n = 3$

$x^{2^3} - x = x^8 - x$ 在 $\text{GF}(2)$ 上因式分解:   

$$x^8 - x = x(x-1)(x^3 + x + 1)(x^3 + x^2 + 1)$$

  

因式分解中包含两个次数为 3 的不可约多项式 $x^3 + x + 1$ 和 $x^3 + x^2 + 1$. 

#### $p = 3, n = 2$

$x^{3^2} - x = x^9 - x$ 在 $\text{GF}(3)$ 上因式分解:   

$$x^9 - x = x(x-1)(x-2)(x^2 + 1)(x^2 + x - 1)$$

  

因式分解中包含一个次数为 2 的不可约多项式 $x^2 + 1$. 

***

$GF(2^{n})$, like $GF(2^{8})$ be represented as a byte.

$GF(GF(p^{n})^{m})$, equivalent to $GF(p^{n})[x]\pmod{M(x)}$, where $M(x)$ is an irreducibel polynomial on $GF(p^{n})[x]$ with $deg(M(x))=m$. Example of $GF(2^{3})[x]$: $f(x)=001x^{2}+101x+010$, where 101 is shorthand for $x^{2}+1$

all finite fields are isomorphic to $GF(p^{n})$

***

域例子

$(\mathbb{C}, +, *)$ 

$(\mathbb{R}, +, *)$

$\mathbb{Z}_{p}$ is a finite field