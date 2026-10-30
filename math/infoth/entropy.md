---
epigraph: 信息是负熵
---

## 信息论

**自信息量** 描述某事件带来的信息量, 概率越小信息量越大. 设 X 是离散型随机变量, 概率分布为 $p(x)=P(X=x), x\in X$. X 的自信息量为 $$I(x)=-\log_{2}P(x)$$

**信息熵 (entropy)** 描述一个随机变量的不确定性. X 的信息熵为 $$H(x)=-\sum_{x\in X}P(x)\cdot \log_{2}P(x)$$ 约定 $0\log0=0$, 熵单位为二进制位bit. **当所有码字出现概率相等, 即对所有结果没有偏见时, 信息熵最大**

### 联合熵 

Joint Entropy, 联合熵指一对随机变量平均所需要的信息量. 设 $X, Y$ 为一对离散随机变量, $X, Y\sim p(x, y)$, 联合熵定义为: $$H(X, Y)=-\sum_{x\in X}\sum_{y\in Y}p(x,y)\cdot \log_{2}p(x,y)$$

### 条件熵

Conditional Entropy 条件熵定义为: (给定随机变量X)
$$\begin{align}
H(Y\vert X)&=\sum_{x\in X}p(x)H(Y\vert X=x) \\
&=\sum_{x\in X}p(x)\left[ -\sum_{y\in Y}p(y\vert x)\cdot \log_{2}p(y\vert x) \right] \\
&=-\sum_{x\in X}\sum_{y\in Y}p(x,y)\log_{2}p(y\vert x) \\ \\
\end{align}$$

由条件熵表示联合熵:
$$\begin{align}
H(X,Y)&=-\sum_{x\in X}\sum_{y\in Y}p(x,y)[\log_{2} p(x)+\log_{2}p(y\vert x)] \\
&=-\sum_{x\in X}\sum_{y\in Y}p(x,y)\log_{2} p(x)-\sum_{x\in X}\sum_{y\in Y}p(x,y)\log_{2} p(y\vert x)  \\
&=-\sum_{x\in X}p(x)\log_{2}p(x)--\sum_{x\in X}\sum_{y\in Y}p(x,y)\log_{2} p(y\vert x) \\
&= H(X)+H(Y\vert X)
\end{align}$$

$p(x,y)=p(y)\cdot p\left( \frac{x}{y} \right)=p(x)\cdot p\left( \frac{y}{x} \right)$, 所以也有:

$$\begin{align}
H(Y\vert X)&=\sum_{x\in X}p(x)H(Y\vert X=x) \\
&=-\sum_{x\in X}\sum_{y\in Y}p(x,y)\log_{2}p(y\vert x) \\
&=-\sum_{x\in X}p(x) \cdot \sum_{y\in Y}p(y\vert x)\log_{2}p(y\vert x)
\end{align}$$

### 熵率

一般地, 对于长度为n的信息, 每个字的熵为 $$H_{rate}=\frac{1}{n}H(X_{1n})=-\frac{1}{n}\sum_{x_{1n}}p(x_{1n})\cdot \log_{2}p(x_{1n})$$ 称为熵率 (Entropy Rate). 其中 变量 $X_{1n}$ 表示随机变量序列 $(X_{1}, \dots, X_{n})$,  $x_{1n}=x_{1},\dots,x_{n}$ 或 $x_{1}^{n}=(x_{1},\dots,x_{n})$

### 相对熵

相对熵 (relative entropy) 也称为KL距离 (Kullback-Leibler Divergence). 两个概率分布 $p(x)$ 和 $q(x)$ 的相对熵定义为: $$D(p\Vert q)=\sum_{x\in X}p(x)\log_{2} \frac{p(x)}{q(x)}$$ 其中 $0\log_{2}(0/q)=0,\,p\log(p/0)=\infty$.

相对熵用来衡量两个随机分布的差距 (默认p应大于q?), 当两个随机分布相同时, 相对熵为0; 两随机分布差别增加时, 相对熵也增加.

### 交叉熵

交叉熵 (Cross Entropy) 用来衡量模型和真实概率分布之间的差异. 若随机变量 $X\sim p(x)$, $q(x)$ 为用于近似 $p(x)$ 的概率分布, 那么随机变量X和模型q之间交叉熵定义为 $$H(X, q)=H(X)+D(p\Vert q)=-\sum_{x}p(x)\log_{2}q(x)$$

### 互信息

互信息 (Mutual Information) 表示Y透露了多少关于X的信息量. 定义为: $$\begin{align}
I(X;Y)&=H(X)-H(X\vert Y) \\
&= -\sum_{x\in X}p(x)\cdot \log_{2}p(x) + \sum_{x\in X}\sum_{y\in Y}p(x,y)\cdot \log_{2}p(x\vert y) \\
&=\sum_{x\in X}\sum_{y\in Y}p(x,y)\left( \log_{2} \frac{p(x\vert y)}{p(x)} \right)
\end{align}$$

互信息, 条件熵与联合熵:
<img src="../../attach/img/math/entropy-relations.avif" alt="" width="300">

由于 $H(X\vert X)=0$, 所以 $H(X)=H(X)-H(X\vert X)=I(X;X)$. 因此熵又被称为**自信息**.
