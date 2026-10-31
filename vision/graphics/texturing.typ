#import "@local/ypst-template:0.1.0": template, sidenote
#show: template

#let bmat(..args) = math.mat(delim: "[", ..args)
#let vec(x) = math.bold(math.upright(x))

= 纹理贴图

纹理 Textures 为描述物体提供了更多细节，使着色能根据这些细节（以及光照），计算最终的视觉效果。

图像纹理中的像素通常称为 Texels（纹素）。将纹理空间中的数据，通过纹理坐标映射到几何表面，并
在几何着色过程中进行采样的技术，称为_纹理贴图 (Texture Mapping)_ 。

#mermaid[
```mermaid
flowchart LR
    P["P"] -->|f| UV["(u, v)"]
    UV -->|T| t["t"]
    t -->|Shading| C["C"]
```
]

- $P (x,y,z)$ 是空间坐标
- $U V  (u,v)$ 是纹理坐标，对应纹理图片上的某个位置
- $f$ 是从几何表面 $S$ 到纹理坐标 $(u,v)$ 的映射。这可以是投影、球面映射、柱面映射、UV 展开等。
- $T$ 是从纹理坐标到纹理数据的映射，即，在纹理空间中采样。
- Shading 是着色过程，是从纹理数据、光照等到最终颜色的映射
