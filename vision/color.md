
## Color

### RGB 色彩

RGB 最常见于显示屏、图像、网页的色彩表达，基于自然界三元色的色彩叠加。

  <!-- Red -->
  <div style="height:16px;width:300px;max-width:100%;background:linear-gradient(to right,#000,#f00);"></div>

  <!-- Green -->
  <div style="height:16px;width:300px;max-width:100%;background:linear-gradient(to right,#000,#0f0);"></div>

  <!-- Blue -->
  <div style="height:16px;width:300px;max-width:100%;background:linear-gradient(to right,#000,#00f);"></div>

### HSL 色彩

Hue (色相、色调)

<div style="height:18px;width:300px;max-width:100%;background:linear-gradient(to right,red,yellow,lime,cyan,blue,magenta,red);"></div>

Saturation (饱和度)：H=210, L=50%

<div style="height:18px;width:300px;max-width:100%;background:linear-gradient(to right in hsl,hsl(210 0% 50%),hsl(210 100% 50%));"></div>

Lightness (明度、灰度)：H=210, S=100%

<div style="height:18px;width:300px;max-width:100%;background:linear-gradient(to right in hsl,hsl(210 100% 0%),hsl(210 100% 100%));"></div>

### CMYK 

CMYK 是印刷彩色，由四种油墨颜色构成。

### YUV 

Y (亮度), UV (色度，U 表示蓝色到绿色的色彩、V 表示红色到绿色的色差）。由于人眼对绿色的亮度变化更敏感，YUV 利用这一点来压缩色彩信息。

<figure style="display:flex;flex-wrap:wrap;">
<img src="../assets/vision/color-space.svg" alt="wiki" width=450>
<img src="../assets/vision/yuv.webp" alt="wiki" width=150>
<figcaption style="width:100%;" align="center"> <a href="https://en.wikipedia.org/wiki/Y%E2%80%B2UV">Source: Wikipedia. </a>CIE 1931 xy chromaticity diagram</figcaption>
</figure>


* for printing industry, CMYK color is preferred 
* for dispaly, RGB(A) color is wideyl used 
* for imgae compression, YUV color has been predominant


## Color Space

色彩表示和*色域 (Color Gamut)* 不同，色域是指一个设备或编码范围能够表示出的颜色范围。

* sRGB
* Display-P3
* Adobe RGB

*D65 white pint* 代表在该色彩系统中的白色定义。
