## 索引

[信号与系统](https://notes.jay-waves.cn/robo/cybernetics/signal%26system/):

* 信号：连续时间信号 $x(t)$ 与离散时间信号 $x[k]$ 
* 系统：主要研究*线性时不变系统* (LTI)
* [采样与离散化](https://notes.jay-waves.cn/robo/cybernetics/sampling/) 
* [低通滤波器](./low-pass-filter.md)

频域分析：
    * [傅里叶变换 FT](./fourier-transform.md)
    * [离散傅里叶变换 DTFT](./fourier-transform.md) 
    * [拉普拉斯变换](./laplace-transform.md)
    * Z 变换

* 状态空间理论

[控制论](./cybernetics.md)：

* [Mass-Spring-Damper](https://notes.jay-waves.cn/robo/cybernetics/mass-spring-damper/)
* [Kalman Filter](https://notes.jay-waves.cn/robo/cybernetics/kalman-filter/)
* [PID](./servo-motor-pid.md)
* [Impedance](https://notes.jay-waves.cn/robo/cybernetics/impedance-control/)

## 定义

* $t$ 连续时间变量，单位为秒（s）
* $n,\ k$ 离散时间序列的整数索引
* $\omega$ 模拟信号（连续时间）的角频率，单位为 rad/s
* $\Omega$ 数字信号（离散时间）的角频率，单位为 rad/sample
* $f$ 物理频率，满足 $\omega = 2 \pi f$
* $f_s$ 采样频率，满足 $f_s = 1 / T_s$
* $T_s$ 采样周期

