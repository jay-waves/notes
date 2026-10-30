
# 光的反射

光照和物质的相互作用会产生两种结果：*散射 (scattering)* 和 *吸收 (absorption)* 。当光线照射在介质分界处时，
散射会分开为_反射（reflection）_和_透射（transmission）_，同时有一部分光量被介质吸收。

反射光不集中在镜像方向，而是在较宽范围内出射，称为_漫反射（diffuse reflection）_。反射光是否密集，一般决定于
介质分界处的_表面粗糙度 (roughness)_[^1]。 光线经过某个介质分界处， 传播速度改变，导致观察出的传播方向发生偏折，
称为_折射（refraction）_。

[^1]:  漫反射不一定发生在介质交界处（表面散射）。还有一部分漫反射光，来自透射光在介质体内的重新反射。

三种不同的光线类型：
- 平行光源（太阳光）
- 点光源（_Point Light_）：光从一个点向四面八方发射。
- 聚光灯（_Spot Light_）：光只超一个方向的锥形范围发射。

### TODO: 图像亮度感受

## 亮度的感受

### Subjective Brightness (Weber-Fechner Law)

<img src="../attach/img/vision/light-perception.webp">

$$S=klogB+k_{0}$$

其中 B 为真实光强. 

### Mach Effect 

人眼亮度**变化**感觉: $$\triangle\{L_{1},\ L_{2}\} = \log_{B}(y+\triangle y)-\log_{B}y$$ 马赫效应 Mach Effect: 环境的凸显效应, 灰色在白环境中显得更亮.

*原彩显示*技术就是让屏幕主动适应环境光，使得不同环境下的主观感受的屏幕色彩一致。
