---
source: https://zh.wikipedia.org/zh-cn/傅里叶级数
math-engine: mathjax
---

## 三角形式

对于 $[-l,l]$ 上的周期函数 $f(t)$, 可使用傅里叶级数对其拟合:

$$f(t)\sim \frac{a_{0}}{2}+\sum\limits^{\infty}_{n=1}\left[ a_{n}\cos\left( \frac{n\pi{t}}{l} \right)+b_{n}\sin\left( \frac{n\pi{t}}{l} \right) \right]$$

其中, $$\large\begin{aligned}
a_{n}=\frac{1}{l}\int^{l}_{-l}\cos\left( \frac{n\pi t}{l}\right)\cdot f(t)\ dt \\
b_{n}=\frac{1}{l}\int^{l}_{-l}\sin\left( \frac{n\pi t}{l}\right)\cdot f(t)\ dt
\end{aligned}$$


### 推导过程

傅里叶级数的思想是, **用正弦波的叠加来模拟各种周期波动**: $$f(t)=A_{0}+\sum\limits^{\infty}_{n=1}A_{n}\sin(n\omega t+\varphi)$$

由三角函数展开式:

$$f(t)=A_{n}sin(n\omega t+\varphi_{n})=A_{n}\sin\varphi_{n}\cdot\cos(n\omega{t})+A_{n}\cos(\varphi_{n})\cdot\sin(n\omega{t})$$

令 $a_{n}=A_{n}\sin\varphi_{n}$, $b_{n}=A_{n}\cdot\cos\varphi_{n}$, 那么上式可记为:

$$f(t)=A_{0}+\sum\limits^{\infty}_{n=1}[a_{n}\cos(n\omega{t})+b_{n}\sin(n\omega{t})]\tag{1}$$

> 这里暂时取角频率 $w=1$, 周期 $T=\frac{2\pi}{\omega}=2\pi$, 取一个周期区域为 $[-\pi,\pi]$

#### 引理-三角函数正交性

要进一步求解 $a_{n}$ 和 $b_{n}$, 先介绍一个引理: 

$$\begin{align}
&\int^{\pi}_{-\pi}\cos(nx)dx=0\\
&\int^{\pi}_{-\pi}\sin(nx)dx=0\\
&\int^{\pi}_{-\pi}\sin(kx)\cdot\cos(nx)dx=0\\
&\int^{\pi}_{-\pi}\cos(kx)\cos(nx)dx=0,\,k\neq n\\
&\int^{\pi}_{-\pi}\sin(kx)\sin(nx)dx=0,\,k\neq n
\end{align}$$

**证明**: $\int^{\pi}_{-\pi}\cos(kx)\cos(nx)dx=0$

由积化和差公式: ${} \cos(kx)\cdot\cos(nx)=\frac{1}{2}[\cos(k+n)x+\cos(k-n)x] {}$

如果 $k\neq n$, 有: $$\begin{aligned}
\int^{\pi}_{-\pi}\cos(kx)\cos(nx)dx&=\frac{1}{2}\int^{\pi}_{-\pi}[\cos(k+n)x+\cos(k-n)x]dx\\
&=\frac{1}{2}\left[\frac{\sin(k+n)x}{k+n}+\frac{sin(k-n)x}{k-n}\right]\Bigg\vert^{\pi}_{-\pi}\\
&=0
\end{aligned}$$

$\blacksquare$

<br>

对公式 $(1)$ 同时在 $[-\pi,\pi]$ 求定积分:

$$\begin{align}
\int^{\pi}_{-\pi}f(t)\ \mathrm{d}t &=\int^{\pi}_{-\pi}A_{0}\ \mathrm{d}t+\int^{\pi}_{-\pi}\sum\limits^{\infty}_{n=1}[a_{n}\cos(n{t})+b_{n}\sin(n{t})]dt \\
&=A_{0}\cdot2\pi
\end{align}$$

所以 $A_{0}=\frac{1}{2\pi}\int^{\pi}_{-\pi}f(t)\ \mathrm{d}t$, 记 $a_{0}=\frac{1}{\pi}\int^{\pi}_{-\pi}f(t)\ dt$, 所以 $A_{0}=\frac{a_{0}}{2}$

公式 $(1)$ 同乘 $\cos(kt)$, 得到:

$$\cos(kt)\cdot f(t)=\frac{a_{0}}{2}\cos(kt)+\sum\limits^{\infty}_{n=1}[a_{n}\cos(n{t})\cdot\cos(kt)+b_{n}\sin(n{t})\cdot\cos(kt)]$$

同时在 $[-\pi,\pi]$ 上求定积分:

$$\begin{align}
\int^{\pi}_{-\pi}\cos(kt)\cdot f(t)dt&=\frac{a_{0}}{2}\textcolor{gray}{\int^{\pi}_{-\pi}\cos(kt)dt}+\sum\limits^{\infty}_{n=1}\left[a_{n}\textcolor{red}{\int^{\pi}_{-\pi}\cos(n{t})\cdot\cos(kt)\cdot dt}+b_{n}\textcolor{gray}{\int^{\pi}_{-\pi}\sin(n{t})\cdot\cos(kt)\cdot dt}\right] \\
&=a_{n}\int^{\pi}_{-\pi}\cos(k{t})\cdot\cos(kt)\cdot dt \\
&=a_{n}\pi
\end{align}$$

整理得系数 $a_{n}$ 形式: (此时 $k=n$, 将 $k$ 写成 $n$)

$$a_{n}=\frac{1}{\pi}\int^{\pi}_{-\pi}\cos(n{t})\cdot f(t)\ dt$$

同理, $(1)$ 左右同乘 $\sin(kt)$, 得到: 

$$b_{n}=\frac{1}{\pi}\int^{\pi}_{-\pi}\sin(n{t})\cdot f(t)\ dt$$

### 周期延拓

如果 $f(x)$ 的周期不是 $[-\pi,\pi]$, 而是 $[-l,l]$, 则需要调整正弦波的角频率 $\large{\omega=\frac{\pi}{l}}$. 此时正弦波的周期区域也为 $[-l,l]$. 重复上述步骤, 得: 

$$\begin{align}
f(t)&=\frac{a_{0}}{2}+\sum\limits^{\infty}_{n=1}[a_{n}\cos(n\omega{t})+b_{n}\sin(n\omega{t})] \\
a_{n}&=\frac{2}{T}\int^{T/2}_{-T/2}\cos(n\omega{t})\cdot f(t)\ dt \\
b_{n}&=\frac{2}{T}\int^{T/2}_{-T/2}\sin(n\omega{t})\cdot f(t)\ dt \\ \\
\omega&=\frac{\pi}{l} \\
T&=\frac{2\pi}{\omega}=2l
\end{align}$$

## 复指数形式

使用[欧拉公式](三角函数.md)将正弦和余弦替换为复指数函数:

$$\cos(nx) = \frac{e^{inx} + e^{-inx}}{2}, \quad \sin(nx) = \frac{e^{inx} - e^{-inx}}{2i}$$

设角频率为: $$\omega_{0}=\frac{2\pi}{T}$$ ，那么傅里叶级数可改写为： $$f(x)=\sum^{\infty}_{k=-\infty}c_{k}e^{ik\omega_{0} x}$$

频率只出现在 $\omega=k\omega_{0}$ ，复傅里叶系数为： 

$$c_{k}=\frac{1}{T}\int^{T}_{0}f(x)e^{-ik\omega_{0}x}  \, dx $$

其中 $c_{n}$ 是复傅里叶系数, 可能包含虚数.


### 部分和算子

部分求和算子, 即前 $2N+1$ 项之和, 记为: $$S_{N}(f)=\sum^{N}_{n=-N}c_{n}e^{inx}$$

> 求傅里叶级数部分和时, 必须采用级数的对称形式, 否则收敛结果可能不成立.

$f(x)$ 的傅里叶级数的部分求和, 可以用 $f(x)$ 与狄利克雷核 $D_{n}(x)$ 的[convolution](convolution.md)来表示:

$$\begin{align}
S_{N}(f)&=\sum^{N}_{n=-N}c_{n}e^{inx} \\
&=\sum^{N}_{n=-N}\left(\frac{1}{2\pi}\int^{\pi}_{\pi}f(\tau)e^{-in\tau}d\tau \right)\cdot e^{inx}=\frac{1}{2\pi}\int^{\pi}_{\pi}f(\tau)\left(\sum^{N}_{n=-N}e^{in(x-\tau)}\right)d\tau \\
&=\frac{1}{2\pi}(f*D_{N})(x)
\end{align}$$

其中 $D_{N}(x)=\sum\limits^{N}_{n=-N}e^{inx}$ 
