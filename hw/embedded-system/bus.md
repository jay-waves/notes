Intel X86 提供了直接操作 I/O 端口的指令 `in/out`, 但是 RISC 指令集皆通过内存呢单元和内存映射来操作外设.

## GPIO

GPIO (通用可编程 I/O), 由一组控制寄存器和一组数据寄存器控制.
- 当引脚设置为输出时, 
	- 向数据寄存器写入 1, 引脚产生高电平.
	- 向数据寄存器写入 0, 引脚产生低电平.
- 当引脚设置为输入时, 读取数据寄存器的对应位, 以获取引脚电平.

## 电平标准

电平高低通常代表数字 0 和 1, 但是不同技术下定义的电平标准不同, 其功耗 / 速度 / 稳定性 等也有区别. 

CMOS (Complementary Metal-Oxide-Semiconductor) 电平: CMOS 是电压控制元件.
- 高电平: 接近 Vdd (电源电平, 常见 1.8V, 2.5V, 3.3V, 5V)
- 低电平: 接近 0V
- 静态时几乎不消耗电流. 是现代数字电路最常见技术.

静电放电 (ESD) 会短暂产生高电压. CMOS 主要由 [MOSFET](../electronics/electronics.md) 构成, 其栅极的氧化层很薄, 
容易被高电压击穿, 造成损坏. 

TTL (Transisitor-Transisitor Logic): TTL 是电流控制元件, 由 [BJT](../electronics/electronics.md) 组成. CMOS 的功耗比 TTL 小, 抗干扰性强, 但是比较贵.
- 高电平: 2.4V 至 5V
- 低电平: 0V 至 0.8V
- 通常使用 5V 电源, 电压范围窄. 消耗更大电流, 但电平切换速度更快.

RS-232C 串口协议的电平: 全双工, 至少有 RT,TX,GND 三条线.
- 高电平: -3V 至 -15V. 通常是 -12V. (负逻辑)
- 低电平: 3V 至 15V. 通常是 +12V.
- 由于使用正负电压, 使得信号能在较长距离传输, 不必担心衰减 (从高电平变为零).

对于更长距离传输 (千米外), 还可以采用 RS-485 标准 (半双工) 或 RS-422 (双绞线, 全双工). 在极近距离, 并行通信效率当然更高; 但远距离条件下, 并行通信不如串行差分通信的抗干扰能力强. 因此, USB, SATA, 以太网等仍采用串行通信.

## 串口

RS-232C 是流行的串行数据接口标准 (EIA, 1969), 负责连接 DTE (数据终端设备) 和 DCE (数据通信设备):
- RTS (请求发送流控制): DTE 请求 DCE 发送数据.
- CTS (清除发送流控制): DCE 准备好接受 DTE 发送的数据, 是对 RTS 的响应信号.
- RxD (数据接受): DTE 通过 RxD 接受从 DCE 发送来的串行数据.
- TxD (数据发送): DTE 通过 TxD 将串行数据发送到 DCE.
- DSR (数据终端就绪流控制): 有效 (ON), 表示 DCE 可以使用.
- DTR (数据设置就绪流控制): 有效 (ON), 表示 DTE 可以使用.
- DCD (数据载波检测, 也叫 RLSD): 本地 DCE 接受到对方 DCE 设备送来的载波信号, 使 DCD 有效, 通知 DTE 准备接受, 并且由 DCE 将接受到的载波信号解调为数字信号, 经 RxD 发送给 DTE.
- Ringing-RI (振铃指示): 当调制解调器收到交换台送来的振铃呼叫时, 使该信号有效 (ON), 通知终端已被呼叫.
- SGND (信号接地)

<img src="../../attach/img/hw/rs232c-io.avif" alt="引用 2, 图 2.9" width="600">

CPU 是并行的, 一次处理 64 位数据. 串口则是串行的, 一次处理一位. CPU 向串口发送数据时, 先通过 *UART (通用异步收发器)* 将并行数据转换为串行数据, 并按 RS-232C 协议的格式进行编码. 接着, 将 CMOS/TTL 电平转化为 RS-232C 电平.

RS-232C 总线的传输距离不超过 15m, 最高传输速率为 20Kbps. 低电平在 `5~15V`, 高电平在 `-5~-15V`. 也因此不能直接连接 TTL 电路. RS232C 规定 25 针接口, 但常用的只有 9 根.

<img src="../../attach/img/hw/rs-232c.avif" alt="" width="400">

## UART

通用异步收发器 （UART， Universal Asynchronous Receive/Transmitter). 通用同步和异步收发器 （Universal ASynchronous and Synchronous Receive/Transmitter, USART). CPU 将数据总线并行数据送至 "缓冲区", 然后控制 TxD 线按位送出, 转化为串行数据. 每帧的起始位和停止位由 UART 自动添加. 接受数据时, UART 监听 RxD 线, 当有低电平 (起始位) 时开始接受一帧数据, 直至数据帧完全读取至 "缓冲区", 通过中断促使 CPU 取走数据.

<img src="../../attach/img/hw/uart.avif" alt="" width="400">

UART 按时钟 (RxC) 上升沿采用 RxD 线, 当连续采集到 RxD 上 K 个低电平 (一般设置为起始位的二分之一时间) 后, UART 确认对方在发送数据 而不是干扰信号. 

#### UART 波特率

波特率 (Baud Rate) 在通信双方需要保持一致. 常见有 4800/9600/115200/12800 bps. 波特率有一定允许误差范围, 但是太快会导致误码.

#### UART 帧格式

1. 起始位 
2. 数据位: LSB 在前, MSB 在后. 一般数据位有 8b 
3. 校验位: 奇偶校验等. 
4. 结束位

## I2C 

I2C (Inter-Integrated Circuit, IIC) 是低速串行半双工同步总线协议, 由 Philips Inc. 开发. 只有两根线:
1. SCL (Serial cLock), 默认高电平. 
2. SDA (Serial Data), 默认高电平.

每种从机 (slave) 都有独立总线地址, 在启动时由主机配置. 主机向从机发送数据时, 首先, 发送 START 条件码并取址从机, 然后传送数据, 用 STOP 条件码结束. START 条件码指 SDA 向下跳变同时 SCL 保持高电平. STOP 条件码指 SDA 向上跳变同时 SCL 保持高电平. 每个时钟传输一个比特, 字节的 MSB 在前. 每个字节传输成功后, 主机释放 SDA, 从机向主机发送一个 ACK (低电平); 否则被视为一个 NACK (高电平).

每字节数据可能有三种用途: 
- 从机地址 (编号): 7b 或 10b. 后紧跟着一个 R/W 使能位.
- 从机内的寄存器地址: 1B 或 2B
- 将向从机内寄存器写入的数据

读数据:
```
主 START | SlaveAddr | RW=0 ---> RegAddr --> Data Bytes ... --> STOP 

从                          ACK          ACK            ... ACK
```


写数据:
```
主 START | SlaveAddr | RW=0 --> RegAddr -->  START (repeated) | SlaveAddr | RW=1                         --> NACK | STOP

从                          ACK         ACK                                      --> ACK --> Data Bytes... 
```

SPI 不规定工作频率, 但 I2C 设定了五种速率模式:
- Standard, 100kbps
- Fast, 400kbps
- Fast-Plus, 1Mbps 
- High-speed, 3.4Mbps 
- Ultra-Fast, 5Mbps (仅单向传输)

## SPI 

SPI (Serial Peripheral Interface, 串行外设接口) 是高速全双工同步串行接口, 由 Motorola Inc. 推出. 主控作为 SPI 的主机 (Master), 外设作为 SPI 的从机 (Slave). SPI 定义有四根线, 也可以合并 MISO/MOSI 变为半双工.

- 串行时钟线 (SCLK)
- 主机输入/从机输出数据线 (MISO), 不使用时保持高组态.
- 主机输出/从机输入数据线 (MOSI), 传输数据和操作码.
- 低电平有效的从机选择线 (SS)

<img src="../../attach/img/hw/spi-io.avif" alt="引用 2, 图 2.9" width="400">

通过配置 输出串行同步时钟极性 (CPOL) 和相位 (CPHA), SPI 可以配置适应不同外设的频率, 采样时刻. 
- CPOL=0, 串行同步时钟的空闲状态为低电平
- CPOL=0, 串行同步时钟的空闲状态为高电平
- CPHA=0, 串行同步时钟的第一个跳变沿 (上升或下降) 数据被采样.
- CPHA=1, 串行同步时钟的第二个跳变沿 (上升或下降) 数据被采样.

SPI 一般用来连接 EEPROM, Flash, RF 等外围设备.

## USB

USB (通用串行总线，Universal Serial Bus) 的目的是统一不同外设种类的插槽类型. 有速率高, 易扩展, 即插即用和热插拔 等特点.

不同代 USB 的差别:
- USB1.1 有全速 (12Mb/s) 和低速模式 (1.5Mb/s)
- USB2.0: 480 Mb/s, 半双工. 4 线.
- USB3.0: 5Gb/s, 约 640MB/s, 全双工. 8 线.

电路板挂接外部 USB 设备, 需要提供 USB 主机控制器; 若作为 USB 设备, 则需要提供 USB 设备设配器. 
在 USB 设备组成的树形设备拓扑中, 为每个设备预留固定带宽, 但有不同的传输控制方式:
1. 控制传输方式 (Control): 双向传输, 数据量小.
2. 同步传输方式 (Isochronous): 用于即时传输, 提供了确定的带宽和间隔时间. 如语音业务.
3. 中断传输方式 (Interrupt): 中断是单向的, 定时由 USB 设备向主机输入. 如: 键盘, 鼠标.
4. 批量传输方式 (Bulk): 传输批量数据组成的数据流. 如: 打印机, 扫描仪.

USB 总是支持热插拔 (Hot-Plugging) 和 即插即用 (Plug-and-Play), 即不需要重启设备就能识别到外设的挂载与接入. 有几个技术:
1. USB 引脚 (VBUS, GND, D+, D-) 中, 电源引脚比数据引脚更长. 插入时, 电源先连接, 数据后链接.
2. 插入设备后, 主机通过 USB 协议进行重新枚举, 接着分配地址和加载驱动. USB 设备按树型结构排布。


## 以太网接口

IEEE 802.3 定义了以太网接口 (数据链路层). 以太网接口由 MAC (以太网媒体接入控制器) 和 PHY (物理接口收发器), 两者之间使用 MII (媒体独立接口) 连接, 包含一个双工数据接口和一个管理接口.

数据接口包含接受和发送两个独立信道, 每个信道有独立的数据 / 时钟 / 控制信号; 管理接口包含一个时钟信号和一个数据信号. 因此 MII 接口总共包含 16 个信号. 通常网卡会集成 MAC 和 PHY.

<img src="../../attach/img/hw/ethernet-io.avif" alt="" width="600">

## ISA 

比较老的计算机总线。

## PCI

PCI (外围部件互连, Peripheral Component Interconnect) 是 Intel 1991 年推出的总线标准, 各个设备皆并行连接在总线上.  PCI-E (Express) 是新一代 PCI, 设备间不再共享总线资源, 而是有自己的专用连接, 串行传输数据.


## SD

SD (Secure Digital) 是 Flash 存储卡的设计标准. SDIO 则是 SD 标准上外设接口标准, 

eMMC (Embedded Multi Media Card) 是移动设备本地存储标准, 封装了 NAND Flash, 闪存控制芯片等.

## CAN 

CAN （Controller Area Network）总线是一种广泛应用于汽车行业的串行通信网络。采用 [NRZ 编码](../../net/physical-l1.md)，同步依靠本地时钟以及一些微调方法。

<img src="../../attach/img/hw/can-bus.png" alt="" width="600">

CAN 总线始终在广播报文，每个 CAN 节点有一个*接收滤波 ID 表*，过滤出包含感兴趣 ID 的报文。

#### CAN 帧格式

主要帧类型：
* 数据帧，
* 遥控帧，接受单元向发送单元请求数据，没有数据段。
* 错误帧

![](../../attach/img/hw/20260323123433732.avif)

* SOF, Start of Frame. 1b
* ID. 11b
* DLC. 4b. 编码数据段长度。
* Data 0~64b. MSB 在最前
* 15b CRC + 1b DEL

#### CAN 仲裁与同步

CAN 总线的电平分为两类：
* *隐性（recessive），1*
* *显性（dominant），0* 。任一节点发送显性位，总线整体即变为 0。

当检测到总线空闲，多个发送节点同时开始发送数据，通过对比帧 ID 来仲裁优先级。发送节点按位发送，同时按位从总线监听电平（回读机制），当发送 `0` 时，总线肯定是 `0`，继续；当发送 `1` 时，如果读到 `0` ，输掉总裁，停止发送；因此帧 ID 越小，优先级越高。

如果 ID 相同，遵循：
* 数据帧优先级高于遥控帧
* 标准格式的帧，优先级高于扩展格式的帧、

*位级仲裁* 实际限制了 CAN 的最高速度以及规模，因为存在总线的传播延迟。

## A-D 

ADC (模数转换), DAC (数模转换)

## 参考

Understanding the IIC Bus. Texas Instruments. Jonathan Valdez. 2015.

https://elearning.vector.com/mod/page/view.php?id=4821
