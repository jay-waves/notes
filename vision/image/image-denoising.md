## 图像去噪

<img src="../../attach/img/vision/vision-image-processing-denoising.avif" alt="" width="200">

图像频域中, 低频段代表图像的平滑与缓慢变化, 自然图像的能量多集中于此; 高频段则反应图像的突兀变化. **噪声有随机性, 表现在图像上为像素级的随机变化, 所以导致图像高频分量的能量增加.**

噪声+图像细节都在高频上, 

滤波框图: 

$\mathcal{F}$ 变换 $\Rightarrow$ 滤波器 $\Rightarrow$ $\mathcal{F}$ 反变换

### 图像平滑

处理噪声: 
- 胡椒噪声 (Pepper Noise): $\approx 0$, 粒状
- 盐噪声 (Salt Noise): $\approx 255$, 粒状. 椒盐噪声也称脉冲噪声.
- 高斯噪声: 

**图像平均**:
- 空间域平均
- 频率域平均

图像平均时, 噪声越少, 可能导致图像越模糊.

**低通滤波** (噪声能量集中在高频段): 振铃效应

**中值滤波** 窗口长度(滤波长度)

| 噪声标准差 | 加噪 (高斯噪声)                                                | 去噪后 (DCT变换+低通滤波)                                               |
| ---------- | ----------------------------------------------------- | ----------------------------------------------------- |
| 10         | ![](../../attach/img/vision/image-smoothing-1.avif) | ![](../../attach/img/vision/image-smoothing-2.avif) |
| 30         | ![](../../attach/img/vision/image-smoothing-3.avif) | ![](../../attach/img/vision/image-smoothing-4.avif)                                                      |
