---
math-engine: mathjax
---

对于非周期性函数，可以用 $T\to \infty$ 的周期函数模拟，此时傅里叶级数变换为： $$f(t)=\sum^{\infty}_{k=-\infty}c_{k}e^{jk\omega_{0} t},\quad \omega_{0}\to 0$$

由于基频 $\omega_{0}\to 0$ ，每个离散频率点 $k\omega_{0}$ 间隔变小，**频谱变得连续**。数学上，级数变为积分： $$f(t)=\int^{\infty}_{-\infty}F(\omega)e^{j\omega t}  \, d\omega $$

<img src="../../attach/img/robo/spectrum.avif" alt="no-copyright" width="400">

## 傅里叶变换

$$F(\omega)=\int^{\infty}_{-\infty}f(t)e^{-j\omega t}dt$$

### 频谱

将傅里叶变换后的结果是一个复数（固定 $\omega$ ），将其表示为极坐标形式：

$$F(\omega)=|z|e^{j\arg (z)}=\vert F(\omega)\vert \cdot e^{j\phi(\omega)}$$

- $\vert F(\omega)\vert=\sqrt{\Re^{2}(\omega)+\Im^{2}(\omega)}$ 称为 $f(t)$ 的*幅度谱*
- $\phi(\omega)=\arctan\left[ \frac{\Im(\omega)}{\Re(\omega)} \right]$ 称为 $f(t)$ 的*相位谱*

### 线性

$$\mathcal{F}\{af(t)+bg(t)\}=aF(\omega)+bG(\omega)$$

### 时移（延迟）

$$\mathcal{F}\{f(t-t_{0})\}=e^{-j\omega t_{0}}F(\omega)$$

### 频移（调制）

$$\mathcal{F}\{f(t)e^{j\omega_{0}t}\}=F(\omega-\omega_{0})$$

### 共轭对称性

频谱关于原点共轭对称：

$$F(-\omega)=F^{*}(\omega)$$

### 缩放

时域紧缩时，频域展开（频谱拉宽）

$$\mathcal{F}\{f(at)\}=\frac{1}{|a|}F\left( \frac{\omega}{a} \right)$$

## 常见傅里叶变换

| 时域 $$f(t)$$                  | 傅里叶变换 $$F(\omega)$$                                                          | [laplace-transform](laplace-transform.md) $$F(s),\quad s=\sigma+j\omega$$ |
| ------------------------- | ---------------------------------------------------------------------- | ---- |
| $$\delta(t)$$             | $$1$$                                                                  |  $$1$$    |
| $$1$$                     | $$2\pi\delta(\omega)$$                                                 |  $$\frac{1}{s}$$    |
| $$u(t)$$                  | $$\pi \delta(\omega)+\frac{1}{j\omega}$$                               |  $$\frac{1}{s}$$   |
| $$e^{-at}u(t),\quad a>0$$ | $$\frac{1}{a+j\omega}$$                                                | $$\frac{1}{a+s}$$      |
| $$\cos \omega_{0}t$$      | $$\pi[\delta(\omega-\omega_{0})+\delta(\omega+\omega_{0})]$$           | $$\frac{s}{s^{2}+\omega_{0}^{2}}$$     |
| $$\sin \omega_{0}t$$      | $$\frac{\pi}{j}[\delta(\omega-\omega_{0})-\delta(\omega+\omega_{0})]$$ | $$\frac{\omega_{0}}{s^{2}+\omega_{0}^{2}}$$      |
| $$e^{-at^{2}}$$           | $$\sqrt{ \frac{\pi}{a} }e^{-\omega^{2}/(4a)}$$                         |      |


## 参考资料

![](../../attach/img/robo/four-forms-of-fourier-transform.avif)

> [3blue1Brown – 形象傅里叶变换](https://www.bilibili.com/video/BV1pW411J7s8/?spm_id_from=333.337.search-card.all.click&vd_source=389ad1f24e143504d05c538916c8c532)

> [图像处理中的傅里叶变换](https://zhuanlan.zhihu.com/p/360764625)
