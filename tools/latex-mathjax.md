## Mathjax

### Alphabet

- `\alpha` $\alpha$ 
- `\beta` $\beta$ 
- `\gamma` $\gamma$
- `\delta` $\delta$  $\Delta$
- `\gamma` $\gamma$  ` \Gamma` $\Gamma$ `\digamma` $\digamma$
- `\epsilon` $\epsilon$  `\varepsilon` $\varepsilon$ (var 代表斜体)
- `\zeta` $\zeta$
- `\theta` $\theta$ `\Theta` $\Theta$
 - `\iota` $\iota$
- `\kappa` $\kappa$ 
- `\lambda` $\lambda$ `\Lambda` $\Lambda$
- `\mu` $\mu$ 
- `\nu` $\nu$ 
- `\pi` $\pi$ 
- `\psi` $\psi$ `\Psi` $\Psi$
- `\phi` $\phi$ `\Phi` $\Phi$
 - `\tau` $\tau$ 
 - `\chi`, ki $\chi$
 - `\xi`, ksi $\xi$
 - `\omega` $\omega$ `\Omega` $\Omega$
- `\rho` $\rho$ 
- `\sigma` $\sigma$ `\Sigma` $\Sigma$ 
- `\eta` $\eta$ 
- `\ell` $\ell$
- `\wp` $\wp$
- `\Re` $\Re$ ${} \Im {}$
- `\aleph` $\aleph$
- `\nabla` ${} \nabla {}$

### 1.corner mark

* 上标:^ 如: $4^2$
* 下标:_ 如:$C_n^2$

### 2.vector
* single letter: 
    * \vec a   $\vec a$
    * \overrightarrow a $\overrightarrow a$
* polygram：
    * ＼vec {ab} $\vec {ab}$
    * $\overrightarrow {ab}$
### 3.special character:
* \hat a $\hat a$
* \overline a$\overline a$
* \underline a $\underline a$

### 4.typeface
* $\mathtt{A}$
* $\mathbb{A}$
* $\mathsf{A}$
* $\mathcal{A}$

### 5.space

the machine will ignore spaces,such as$a b$, unless:
1. $a\ b$
2. big space $a\quad b$
3. but be careful of  `\\`,that is just a explanation

see [Latex 空格与换行](Latex%20空格与换行.md) for details.

### 6.grouping
* the same level {}
    * e.g. $x_i^2$&$x_{i^2}$

### 7.Bracket
* $(a)$
* $[b]$
* special: $\{ab\}$,\{...\}using the escape symbol because the{} can also be identified as grouping symbol;
* angle brackets<>:$\langle ab \rangle$;\langle ....\rangle
* absolute value \vert....\vert $\vert a\vert$
* double verticle lines ;transfer v into V;$\Vert a \Vert$
* usual:use \left or \right to let bracket match with the nearest typeface;
    * e.g.transfer $\{\frac{(x+y)}{[\alpha+\beta]}\}$
    *    &emsp;&emsp;&emsp;into$\left\{\frac{(x+y)}{[\alpha+\beta]}\right\}$,you can make it on the left. \left&\right can change the format only on the left of sth.
* express ! `\not` $\not=$ 
* sqrt $\sqrt[3]{x}$
* overbraces and underbraces:

$$\begin{equation}
    \min_{\bm{w} \in \mathbb{R}^d} \mathcal{L}(w) \triangleq \min_{\bm{w} \in \mathbb{R}^d} \underbrace{\sum_{k=1}^K \frac{n_k}{n} \overbrace{\frac{1}{n_k} \sum_{i \in \mathcal{P}_k}  \underbrace{\ell(\bm{x}_i, y_i, \bm{w})}_{\text{sample}\,i\,\text{loss}}}^{\text{client average loss}}}_{\text{population average loss}}
\end{equation}$$

### 8. operator
#### A.arithmetical operator
 * $x+y$
 * $x-y$
 * $x\times y$ pay attention to the space
 * $x\cdot y$
 * $x\ast y$
 * $x\div y$
 * $x\pm y$  as same as $x\mp y$
 * $x=y$
 * $x\leq y$ less than or equal to(or \le)
 * $x\geq y$ greater than or equal to
 * $x\approx y$ approximate
 * $x\equiv  y$ equivalent;like:equivalent weight
 * $x\bigodot y$
 * $x\bigotimes y$
 * $x\oplus y$ oplus
 * $x\mid y$, $x\nmid y$

#### B.set operator
* $\in$
* $\subset$
* $\subseteq$
*  $\supset$
* $\supseteq$
* $\supset$
* $\varnothing$
*  $\cup$, $\bigcup$
* $\cap$, $\bigcap$
* $\overline a$ focus on the place "a" stays
* $\underline a$
* `\overbrace` & `\underbrace` cooperatively with `^` or `_` script

$$\overbrace{a+\underbrace{b+c}_{1.0}+d}^{2.0}$$

#### C.sundry

* $\partial x$ partial derivative
* $\dots$  ellipsis such as $1,2,\dots,n$
* another eliipsis like  $1,2,\cdots,n$
* $\uparrow$ or $\Uparrow$ 
* the same way as $\downarrow$ or$\Downarrow$
* $\leftarrow$ $\Leftarrow$
* $\rightarrow \ \quad  \Rightarrow$

### 9.summation

`\sum`, $\sum$ 

e.g. $\sum_{i=0}^n$ you can see that you also need to apply `_`&`^` to cooperate with summation symbol,what's more you can add the `\displaystyle` to highlight the sign.

### 10.limitation

`\lim` to show up the limitation $\lim$. e.g $\lim_{x\to\infty}$
  
### 11.integration
* \int $\int$
* \iint $\iint$
* \iiint $\iiint$
* \oint $\oint$
    * e.g.1 $\int_0^\infty{fxdx}$ 
* \prod $\prod$

### 12.fractions and roots
* $\frac{1}{2}$
* if the formula is complex,you can use the `\over`, which is just a bar: 
$${\alpha^2+\cos(\theta)\over \sin(\beta+\omega)}$$ 
* $\sqrt [x^2]y$

### 13.function
* $\sin x$
* $\ln x$
* $\log_n^2$
* $\max(A,B,C)$
you will notice that the mathjax didn't make a special definition for them in fact. just use the format:`\the name of the function`.

### 14.special sign
* infinity $\infty$ 
* $\nabla$
* $\triangle$
* $\forall$
* $\exists$
* ${} \lnot \neg {}$ short for logical not
* $\wedge$, ${} \vee {}$

### 15.matrix
* start mark: `\begin{matrix}{cc|c}` //this tells mathjax to add a |
* end mark: `\end{matrix}`
* end of every line: `\\`
* elements interval (alignment): `&`
* matrix frame:

| code               | result       |
| ------------------ | ------------ |
| `\begin{pmatrix}`  | ()           |
| `\begin{bmatrix}`  | []       |
| `\begin{B matrix}` | {}           |
| `\begin{vmatrix}`  | \|....\|    |
| `\begin{Vmatrix}` | \|\|...\|\| |


### 16.ellipses & dots

* vertical ellipses: $\vdots$
* oblique ellipses:$\ddots$
* horizontal ellipses: $\cdots$
* $\dots$
* $\dot x$
* $\ddot x$  

### 17.array
 * setting environment variables:`\begin{array}&emsp;\end{array}`
* using {} to unified statement,along with` |`to insert vertical curve and L to determine columns
* left justifying: `l`;center justifying:`c`; right jusifying:`r`;
* using `\hline` to insert horizontal line
e.g.

```mathjax
$$
\begin{array}{c|lll}
{\downarrow}&{a}&{b}&{c}\\
\hline
{R_1}&{c}&{b}&{a}\\
{R_2}&{b}&{c}&{c}\\
\end{array}
$$
```

### 18.equation set
* require {cases}environment
e.g.
```mathjax
$$\begin{cases}
a_1x+b_1y+c_1z=d_1\\
a_2x+b_2y+c_3x=d_2\\
a_3x+b_3y+c_3z=d_3\\
\end{cases}
$$
```
to use mathjax skillfully,we must train ourselves to apply it to more complex situation.

```mathjax
$$
\begin {split}
y &= (a + b)^2 \\&= a^2 + b^2 + 2ab\\
  &= 0
\end {split}
$$
```  

## References

https://blog.martisak.se/2023/08/11/top-latex-commands/


