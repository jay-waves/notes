卷积和相关知识见[数字信号处理:卷积与相关](../../robotics/cybernetics/convolution.md), 图像中卷积一般指互相关 (cross correlation): $$\large O[i,j]=(I*K)[i,j]=\sum\limits_{m}\sum\limits_{n}I[i+m,j+n]\cdot K[m,n]$$ 其中 $K$ 称为变换核.

==不同的图像变换方法, 可以提取不同的图像信息特征, 也有不同的计算效率.==

## 二维离散傅里叶变换


详见 [fourier-transform](../../robo/cybernetics/fourier-transform.md), 将图像变为频域图像, 减小计算量.

二维离散傅里叶变换: $$F(u,v)=\sum\limits^{M-1}_{x=0}\sum\limits^{N-1}_{y=0}f(x,y)\exp\left[ -j2\pi \left( \frac{ux}{M} +\frac{vy}{N}\right) \right]$$ 

通常仅研究正方图像, 即 $M=N$, ${} u,v\in [0,N-1] {}$, 于是有:

变换核: 

\[
\begin{aligned}
g(x,y,u,v)
&=e^{-j2\pi(ux+vy)/N}\\
&=e^{-j2\pi ux/N}e^{-j2\pi vy/N},\\
h(x,y,u,v)
&=\frac{1}{N^2}e^{j2\pi(ux+vy)/N}.
\end{aligned}
\]

傅里叶变换: 

\[
\begin{aligned}
\mathcal{F}(u,v) &=
    \sum_{x=0}^{N-1}
    \sum_{y=0}^{N-1}
    f(x,y)g(x,y,u,v),\\
f(x,y) &=
    \sum_{u=0}^{N-1}
    \sum_{v=0}^{N-1}
    \mathcal{F}(u,v)h(x,y,u,v).
    \end{aligned}
\]

**缺点:**
- 复数运算费时 (尽管有 [FFT](https://notes.jay-waves.cn/math/numerical/fast-fourier-transform/))
- 很多图像在高频段衰减很快, 频域集中于原点. 可以取 $D(u,v)=\lg(1+\vert F(u,v)\vert)$ 来解决这一问题.

### 平移性

**平移性**:

\[ \begin{aligned}
    f(x-x_0,y-y_0) &\xleftrightarrow{\mathcal{F}} F(u,v)e^{-j2\pi(ux_0+vy_0)/N},\\
    F(u-u_0,v-v_0) &\xleftrightarrow{\mathcal{F}^{-1}} f(x,y)e^{j2\pi(u_0x+v_0y)/N}.
\end{aligned} \]

时域 $f(x,y)$ 移动时, 频域仅发生相移, 傅里叶变换幅值不变: 

\[ \lvert F(u,v)e^{-j2\pi(ux_0+vy_0)/N} \rvert = |F(u,v)| \]

因而常将 $F(u,v)$ 平移到图像中心 $\left( \frac{N}{2}, \frac{N}{2} \right)$, 以使频谱更加清晰: 

\[
f(x,y)(-1)^{x+y} \equiv f(x,y)e^{j\pi(x+y)} \xleftrightarrow{\mathcal{F}} F\left(u-\frac{N}{2},v-\frac{N}{2}\right)
\]

## 离散沃尔什变换

### 一阶离散沃尔什变换

离散沃尔什变换 (Discrete Walsh Transform, DWT) 用于提取图像二值特征, 仅涉及加减法, 不涉及复数, 运算更高效. 
有能量集中特性, 数据分布方差较小时, 变换后数据集中于矩阵角上, 也可用于压缩图像.

设 $N=2^{n}$, 一维沃尔什变换为: 

$$W(u)=\frac{1}{N}\sum\limits^{N=1}_{x=0}f(x)\cdot G$$

变换核为: $$G=\prod\limits^{n-1}_{i=0}(-1)^{b_{i}(x)b_{(n-1-i)}(u)}$$ 

其中 $b_{k}(I)$ 是 I 的二进制表示的第 k 位:

<table>
<tr>
	<th>N</th>
	<th colspan="2">2<br>(n=1)</th>
	<th colspan="4">4<br>(n=2)</th>
</tr>
<tr>
	<td>I</td><td>0</td><td>1</td><td>0</td><td>1</td><td>2</td><td>3</td>
</tr>
<tr>
	<td>I (bin)</td><td>0</td><td>1</td><td>00</td><td>01</td><td>10</td><td>11</td>
</tr>
<tr>
	<td>b_0(I)</td><td>0</td><td>1</td><td>0</td><td>1</td><td>0</td><td>1</td>
</tr>
<tr>
	<td>b_1(I)</td><td></td><td></td><td>0</td><td>0</td><td>1</td><td>1</td>
</tr>
</table>

N=2 时变换核: $$G_{2}=\begin{pmatrix}1&1 \\ 1 & -1\end{pmatrix}$$

N=4 时变换核: $$G_{4}=\begin{pmatrix}
1 & 1 & 1 & 1 \\
1 & 1 & -1 & -1 \\
1 & -1 & 1 & -1 \\
1 & -1 & -1 & 1
\end{pmatrix}$$

## 离散余弦变换 (DCT)

主要用于图像压缩，比如 JPEG 核心算法就是分块 DCT

\[ DCT(u,v) =
\frac{2}{\sqrt{MN}}C(u)C(v)
\sum_{m=0}^{M-1}
\sum_{n=0}^{N-1}
f(m,n)
\cos\frac{(2m+1)u\pi}{2M}
\cos\frac{(2n+1)v\pi}{2N}
\]

- $f(m, n)$ 是输入图像($M\times N$)像素值
- $C(u)$, $C(v)$ 是归一化系数:
	- 若 $u=0$, $C(u)=\frac{1}{\sqrt{ 2 }}$
	- 其他情况, $C(u)=1$

如果是正方形图像:

\[ F(u,v) = 
\frac{2}{N}
\sum_{x=0}^{M-1}
\sum_{y=0}^{N-1}
f(x,y)
\cos\frac{(2x+1)u\pi}{2N}
\cos\frac{(2y+1)v\pi}{2N}
\]

逆变换: 类似

\[ f(x,y) =
\frac{2}{N}
\sum_{u=0}^{M-1}
\sum_{v=0}^{N-1}
F(u,v)
\cos\frac{(2x+1)u\pi}{2N}
\cos\frac{(2y+1)v\pi}{2N}
\]

- DC 系数: $DCT(u,v)$ 的左上角系数, 代表整个块的平均亮度, 照明部分.
- AC 系数: 除 DC 系数外其他(右下角)系数, 代表图像细节和纹理信息. AC系数通常可进行更多压缩, 反射部分. 

## 小波变换

适合压缩、去噪、 边缘分析

