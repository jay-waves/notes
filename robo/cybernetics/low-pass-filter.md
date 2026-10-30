---
math-engine: mathjax
---

## 低通滤波器

低通滤波器最常见的功能：过滤高频信号，保留中低频信号。换言之，通过降低高频增益抑制噪声，但同时引入相位滞后和响应延迟。

滤波效果越强，噪声越小，但是系统响应越慢，相位越滞后。因此：
* 对缓慢变化的输入，尽量跟随
* 对快速变化的输入，主动衰减

对于连续时间一阶低通滤波器，频域写为：
$$G(s)=\frac{Y(s)}{U(s)}=\frac{1}{\tau s+1}$$
$$Y(s)(\tau s + 1)=U(s)$$

时域写为； 
$$\tau \dot{y}(t)+y(t)=u(t)$$ 
$$\dot{y}(t)=\frac{1}{\tau}[u(t)-y(t)]=\frac{1}{\tau}e(t)$$

其中 $\tau$ 是时间常数，单位为秒。$\tau$ 越大，滤波效果越强，但响应越慢。
低通滤波器实际是一个一阶的追踪系统，$\tau$ 作为调整增益。

截止频率定义如下，低于截止频率的信号容易通过： 
$$f_{c}=\frac{1}{2\pi \tau}$$ 

## 时域视角

设单位阶跃输入 
$${} u(t)=1,t\ge 0 {}$$ 
设系统初始输入为静止 
$y(0)=0$

代入方程 ： 
$$\tau\dot{y}+y=u=1$$

解得： 
$$y(t)=1-e^{-t/\tau}$$

有对应关系： 
$$\begin{align}
t=\tau,\quad  & y\approx 63.2 \\
t=3\tau,\quad  & y\approx 95 \\
t=4\tau, \quad  & y\approx 98
\end{align}$$

可以看出，当输入突然从 $0$ 变为 $1$，系统的 $\tau$ 直接决定滤波器的响应速度。

## 频域视角

设截止角频率 
$$w_{c}=\frac{1}{\tau}$$ 
，那么 $G(s)$ 极点为： 
$$s=-\frac{1}{\tau}=-\omega_{c}$$ 

改极点位于左半平面，系统能够稳定。极点离虚轴越远，响应越快，滤波越弱。


## RC Circuit 

![](../../attach/img/robo/rc-low-pass-filter.webp)

RC 电路是典型的一阶滤波器的物理实现。包含一个电阻 $R$ 和一个电容 $C$ 。

电路微分方程为： $$RC \frac{du_{0}}{dt}+u_{0}=u_{i},\quad \tau=RC$$

大概含义：
* 低频时，电容变化较慢，输出能跟随输入
* 高频时，电容来不及充分放电，高频分量被电阻和电容网络削弱 

电压交换频率越高，电容抗阻越小，高频信号更容易通过电容流向地，因此电容两端输出变小。电容的阻抗公式为： 
$$Z_{C}=\frac{1}{j\omega C}$$

## 数字低通滤波

$$y[k]=\alpha y[k-1]+(1-\alpha)u[k],\quad 0<\alpha <1$$ 

$\alpha$ 越接近 1 ，滤波越强。


## 参考

[Low-pass filter -- wikipedia](https://en.wikipedia.org/wiki/Low-pass_filter)