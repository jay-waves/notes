|      | 图像增强                               | 图像复原     |
| ---- | -------------------------------------- | ------------ |
| 思想 | 1.不考虑降质原因<br>2.不一定逼近原图像 |  1.建立降质模型<br>2.建立评判复原效果的客观标准    |
| 目的 | [可懂度](图像基础概念.md#图像质量评价)      | [保真度](图像基础概念.md#图像质量评价)        |
| 方法 |  灰度修正(时域), 滤波(频域)   | 线性滤波复原 |
| 场景 / 灰度修正、平滑去噪、锐化、Retinex | 运动模糊 | 

## 灰度修正

灰度修正(灰度变换)方法:
- 增加图像对比度. 解决图像曝光问题: *图像过曝*, *曝光不足*.
- 直方图修正: 突出图像特征
- 同态增晰: 增强高频部分 (AC 系数), 减少低频部分 (DC 系数)

曝光不足 (灰度过大):

<img src="../../attach/img/vision/normal-exposure-image.avif" alt="" width="200"><img src="../../attach/img/vision/underexposed-image.avif" alt="" width="200">

直方图修正:

<img src="../../attach/img/vision/histogram-equalization.avif" alt="" width="300">

同态增晰:（在频域进行滤波）

<img src="../../attach/img/vision/homomorphic-enhancement-1.avif" alt="" width="200"><img src="../../attach/img/vision/homomorphic-enhancement-2.avif" alt="" width="200">

## 几何校正

假设 $f(\alpha, \beta)$ 是几何畸变图像, $g(x,y)$ 是校正后的图像. 即 $g(x,y)$ 通过 $h_{1},h_{2}$ 线性变换为 $f(\alpha, \beta)$.

$$\begin{cases}
\alpha \leftarrow h_{1}(x,y) \\
\beta \leftarrow h_{2}(x,y)
\end{cases}$$

如果 $(\alpha, \beta)$ 不是整数:
- 临近点插值: 找离 $(\alpha,\beta)$ 最近的点作为校正后 $f(x,y)$ 值
- 双线性插值: 将所在网格的四个边界点加权平均作为校正后 $f(x,y)$ 值. 可以理解为先对x方向平均, 再对y方向平均.

$h_{1},h_{2}$ 通常通过线程方程求解, 如假设 $h_{1}=ax+by+c$

## Retinex

从照明和反射的关系出发 $I(x,y) = R(x,y)L(x,y)$

其中 $R$ 是反射分量，$L$ 是照明分量。Retinex 算法削弱照明变化的影响，以突出物体细节。一般
用于去雾和暗光增强。

## 运动降质复原

运动降质有几种原因：
* 摄像头运动 （也受快门和曝光时间影响）。直接用滤波模型。
* 物体本身快速运动。*需要先对物体进行识别和分割，然后分别应用滤波模型*。

图像受已知某模糊原因影响导致降低质量，建模为：

$$
g(x,y)=h*f+\eta\rightarrow G(u,v)=H\cdot F+N
$$

其中 $H$ 是退化函数，$N$ 是噪声。图像复原滤波的目的，就是从 $g$ 还原 $f$

针对相机运动降质的退化函数为：

$$
H(u, v) = \frac{T}{\eta}\cdot \sin(\eta) e^{-j\eta}, \eta = \pi \cdot (u a + v b)
$$

这其实代表了时域空间中的一个向量位移。其中 $a, b$ 表示运动向量，$T$ 是相机曝光时间。

### 1 逆滤波

$$H(u,v)\cdot F(u, v)=G(u,v)$$

$$\hat{f}(x,y)=F^{-1}\left[\frac{G(u,v)}{H(u,v)}\right]$$

带噪声:

$$G(u,v)=H(u,v)\cdot F(u,v)+N(u,v)$$

$$\hat{F}=\frac{F(u,v)\cdot H(u,v)+N(u,v)}{H(u,v)}=F(u,v)+\frac{N(u,v)}{H(u,v)}$$

逆滤波对噪声非常敏感! 因为退化函数 H 使图像模糊, 就是使图像高频段变小使其丢失细节, 即 H 变换核高频段处会很小, 此时会对噪声有放大作用: $\frac{N(u,v)}{H(u,v)}$. 使用逆滤波, 须先低通滤波去噪.

### 2 维纳滤波

维纳滤波使最小均方误差接近最小: 

$$e^{2}=E\{[\hat{f}(x,y)-f(x,y)]^{2}\}$$

若噪声与图像不相关:

$$\begin{align}
& \hat{F}(u,v)  \\
&= \left[ \frac{H^{*}(u,v)}{\vert H(u,v)\vert^{2}+\gamma[S_{n}(u,v)/S_{f}(u,v)]} \right]\cdot G(u,v) \\
&= \left[\frac{1}{H(u,v)}\cdot \frac{\vert H(u,v)\vert ^2}{\vert H(u,v)\vert^{2}+\gamma[S_{n}(u,v)/S_{f}(u,v)]} \right]\cdot G(u,v)
\end{align}$$

其中 $S_{n}(u,v)$ 使噪声的功率谱, $S_{f}(u,v)$ 是图像的功率谱.

- 无噪声时, $S_{n}(u,v)$, 退化为逆滤波.
- 有噪声时, 一般假定为白噪声, 此时功率谱为常量, 一般由实验确定:

$$\hat{F}(u,v)=\left[ \frac{\overline{H}(u,v)}{\vert H(u,v)\vert^{2}+K} \right]\cdot G(u,v)$$

其中 $\overline{H}$ 是 $H$ 的共轭, $\overline{H}=\vert H\vert^{2}/H$


| 原图像                                                      | 运动降质图像                                                | 维纳滤波                                                    |
| ----------------------------------------------------------- | ----------------------------------------------------------- | ----------------------------------------------------------- |
| ![](../../attach/img/vision/enhancement-restoration-1.avif) | ![](../../attach/img/vision/enhancement-restoration-2.avif) | ![](../../attach/img/vision/enhancement-restoration-3.avif) |
| 加噪后逆滤波                                              | 加噪运动降质图像                                            | 加噪后维纳滤波                                                |
|                ![](../../attach/img/vision/enhancement-restoration-4.avif)         |      ![](../../attach/img/vision/enhancement-restoration-5.avif)          |                    ![](../../attach/img/vision/enhancement-restoration-6.avif)                                         |

