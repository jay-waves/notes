通用处理器多采用 SoC (片上系统) 的设计方法, 集成各种功能模块. 除了集成中央处理器外, 还会集成: 图形处理器, 视频编解码器, 浮点协处理器, 通信模块等一系列功能模块. 这些功能模块按技术分类有 DSP, ASCI, CPLD/FPGA 等. 详见 [计算机架构](计算机架构.md). 

中央处理器的架构可以分为两类:
1. 冯诺依曼结构: Intel, ARM7. 将程序*指令存储器*和*数据存储器*合并在一起的存储器结构, 因此程序指令和数据宽度相同.
2. 哈弗结构: ARM9~10, ARM Cortex A. 程序指令和数据分开存储, 常有不同的数据宽度, 数据和指令也可以有不同的总线.

## CPU 性能指标

*指令周期*指 CPU 从内存中取出一条指令并执行完这条指令的时间总和.

程序有多条指令构成, 当指令系统不变时, 一个程序执行的总指令数相对不变. CPU 使用时钟来协调计算运行, 该时钟非墙上时钟, 而是有固定频率, 称为**时钟频率** (如 3.6GHz), 时钟频率的倒数称为**时钟周期, clock cycle**, 时钟周期的时间间隔称为**时钟周期长度**.  

由于微指令存在, 一条指令不一定对应一个 CPU Clock, 所以引入**每条指令所耗平均时钟周期**, CPI, clock cycle per instruction, 即执行它将持续多少个时钟周期. 程序真实持续时间为: `指令平均时钟周期数 * 时钟周期长度 * 程序指令数`

MIPS (Million Instructions Per Second) 平均每秒执行多少百万条定点指令数. `MIPS = 总指令数 / (程序总执行时间 * 10^6)`

FLOPS (Floating-point Operations Per Second) 每秒执行浮点操作的次数. `FLOPS = 程序中的浮点操作次数 / 程序总执行时间`

## CPU 架构

<img src="../../attach/img/hw/hw-cpu-internal-architecture.avif" alt="" width="500">

CPU (Central Processing Unit): 
- **ALU, Arithmetic Logic Unit, 算术逻辑单元**
- FPU, Floating Point Unit, 浮点运算单元
- Registers, 寄存器, 存储临时数据和指令
- Pipeline, 指令流水线
- Cache, 缓存
	- L1 Cache, 一级缓存, 离核心最近. 分为指令缓存 (I-Cache) 和数据缓存 (D-Cache)
	- L2 Cache, 二级缓存, 单核心独有
	- L3 Cache, 三级缓存, 多核心共享
- **Control Unit, 控制单元, 控制器**. 取出指令, 译码并测试, 产生相应的控制信号.
	- PC, Program Counter, 指令计数器
	- IR, Instruction Register, 指令寄存器
	- ID, Instruction Decoder, 指令解码器
- MMU, Memory Management Unit, 地址转换和内存保护.

### CPU 内部寄存器

- 指令寄存器 (IR), 保存当前正在执行的指令.
- 数据地址寄存器 (AR), 保存即将访问的内存地址. 
- 程序状态字寄存器 (PSWR), 通过状态位保存程序运行状态.
- 程序计数器 (PC), 保存下一条即将被读取和执行的指令内存地址. 顺序执行时, PC 自增.
- 数据缓冲寄存器 (DR), 暂存 ALU 运算结果, 或来自内存 / IO 接口的一个数据字. 用于补偿 CPU 和外设之间的速度差异.
- 各类通用寄存器 (R0-R3...)


## GPU 性能指标

TOPS (Tera Operation Per Second): 每秒可执行万亿次操作. 1 TOPS = $10^{12}$ 次操作每秒, 这里的操作指整数和浮点数运算能力. 用于 GPU 的 AI 推理.

FLOPS (Floating Pointer Operations Per Second): 专用浮点数指标. 1 FLOPS = $10^{12}$ 次浮点运算每秒, 精度更高. 用于 GPU 的科学计算.

LOPS (Logical Operation Per Second): 每秒可执行逻辑操作数. 用于 DSP 和 FPGA 计算设备.

### CPU 硬件厂商

|                    | Intel                                  | NVIDIA                   | AMD                               | Qualcomm                   | MediaTek                         | Apple |    
| ------------------ | -------------------------------------- | ------------------------ | --------------------------------- | -------------------------- | -------------------------------- | ----- | 
| 桌面 CPU x86/amd64 | 酷睿 (Core/Ultra, PE 大小核架构): i3~9 |                          | 锐龙 (Ryzen) (Zen 架构)           |                            |                                  |          |
|                    |                                        |                          |                                   |                            |                                  |         |
| 桌面 CPU arm       |                                        |                          | 霄龙 (EPYC)                       | 晓龙 X                            |                                  |  M1~M4         |
|                    |                                        |                          |                                   |                            |                                  |           |
| 移动 CPU arm       |                                        |                          |                                   | 晓龙 (Snapdragon) (全大核) | 天玑 (Dimensity) (Cortex-A 系列) |  A14~A17          |
|                    |                                        |                          |                                   |                            |                                  |           |
| 服务器 CPU         | 至强 (Xeon)                            |                          |                                   |                            |                                  |           |
|                    |                                        |                          |                                   |                            |                                  |           |
| 桌面 GPU           | 锐炫 (Arc)                             | GeForce RTX 40x (CUDA)   | 镭龙 (Radeon) RX7000x (RDNA 架构) |                            |                                  |           |
|                    |                                        |                          |                                   |                            |                                  |           |
| 服务器 GPU         |                                        | Tesla: A100, H100 (CUDA) |                                   |                            |                                  |           |

### DSP

[数字信号](../../robotics/cybernetics/signals.md)处理器 (DSP) 针对通信 / 图像 / 语音 / 视频 领域的算法. 主要是乘法器的优化, 包括 卷积 / 数字滤波 / FFT / 矩阵运算 中的大量重复乘法. 主要是 德州仪器 (TI) 和 美国模拟器件公司 (ADI) 供应.

TI 提供的数字信号处理器平台为 TMS320 TM DSP, 有 2000, 3000, 4000, 5000 等不同系列 (也成为 2x, 3x, 4x, 5x, 6x). ADI 有 16 位定点数字信号处理器 21xx 系列, 32 位浮点数字信号处理器 SHARC 系列.

