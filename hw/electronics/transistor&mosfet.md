## 晶体管

### 双极性晶体管

<img src="../../attach/img/hw/bjt.avif" alt="" width="300">

双极性晶体管 (Bipolar Junction Transistor, BJT) 是电流控制型器件, 通过基极电流 $I_{B}$ 控制集电极到发射极的电流 $I_{C}$ . 有三个引脚: *发射极 (Emitter), 基极 (Base), 集电极 (Collector)*. 由硅制成, 相邻区域形成两个 PN 结 (Base-Emitter, Base-Collector).

两种类型:
- NPN: N Emitter -> P Base -> N Collector
- PNP: P Emitter -> N Base -> P Collector

工作机制:
- *截止区 (Cut-off)*: BE 结无正向偏置 (NPN 中 $V_{BE}<0.7V$), 集电极和发射极间无电流 $I_{C}\approx 0$, 开关断开.
- *饱和区 (Saturation)*: BE 结正向偏置 (NPN 中 $V_{BE}>0.7V$), BC 结反向偏置. 发射极注入电子到基极, 由于基极很薄, 大部分电子被集电极的高电压吸收, 形成 $I_{C}$. 此时 $I_{C}$ 最大, $V_{CE}$ 较小, 开关闭合.
- *线性区 (Active)*: BE 结正向偏置, BC 结反向偏置. 由基极电流 $I_B$ 控制集电极电流 $I_{C}$, 关系为 $I_{C}=\beta\times I_{B}$, $\beta>20$ 为电流增益. 此时晶体管作用为放大信号.

#### 电压

- Vdd (Voltage Drain Drain, 漏极电源电压). 用于 MOSFET. 是电源正端, 连接 N 沟道 MOSFET 的漏极 或 P 沟道 MOSFET 的源极. 典型值是 1.8V, 3.3V, 5V.
- Vcc (Voltage Collector Collector, 集电极电源电压). 用于 BJT. 是电源正端, 连接到 NPN BJT 的集电极. 典型值是 5V (TTL) 或 12V.
- Vss (Voltage Source Source, 源极电源电压). 用于 MOSFET. 是电源的负端或接地, 连接到 N 沟道 MOSFET 的源极或 P 沟道 MOSFET 的漏极.典型值是 0V 或负值.

### 场效应晶体管

<img src="../../attach/img/hw/mosfet.avif" alt="" width="300">

*场效应晶体管 (Field-Effect Transistor, FET)*, 是电压控制型器件. 主要类型是 *MOSFET (金属氧化物半导体 FET)*. FET 有三个引脚: *源极 (Source), 栅级 (Gate), 漏极 (Drain)*, 通过栅极电压 $V_{GS}$ 控制源级到漏级的电流 $I_{DS}$.

|          | BJT                 | FET                         |
| -------- | ------------------- | --------------------------- |
| 驱动方式 | 基极电流 $I_B$      | 栅极电压 $V_{GS}$           |
| 输入阻抗 | 几百欧姆            | $>10^{9} \Omega$            |
| 功耗     | 较高 (基极电流损耗) | 较低 (无栅极电流, 电压驱动) |
| 应用     | 放大器, 老式电路    | CMOS 数字电路                            |

#### MOSFET

以 N 沟道为例, 源极和漏极是 N 型区, 基底是 P 型. 栅极和基底间有绝缘层 (SiO2 氧化物), 形成电容 (`I_G = 0`).

设阈值电压 (V_th) 为 1V 至 4V
- *截至区 (Cut-off)*. 当 $V_{GS}<V_{th}$, 栅极无电场, 源极-漏极间无导电沟道, $I_{DS}\approx 0$, 晶体管关闭.
- *饱和区 (Saturation)*. 当 $V_{GS}>V_{th}$, 且 $V_{DS}$ 较大, 栅极电压形成导电沟道 (N 型), 电子从源极流向漏极, 开关闭合. 此时 $K_{DS}$ 由 $V_{GS}$ 控制, 与 $V_{DS}$ 无关.
- *线性区 (Triode/Ohmic)*. 当 $V_{GS}>V_{th}$, 且 $V_{DS}$ 较小. 沟道完全导通, $I_{DS}$ 与 $V_{DS}$ 成正比, 像可变电阻.

## 电子器件

- 单极 (Unipolar) 电子器件: 只依赖一种载流子 (如 电子, 或空穴)
	- CMOS
- 双极 (Bipolar) 电子器件: 同时依赖两种载流子 (电子, 空穴)
	- RTL (Resistor-Transisitor Logic)
	- DTL (Diode Transistor Logic)
	- TTL (Transistor-Transistor Logic)

### CMOS

### RTL

### TTL

## 电阻

上拉电阻 (Pull-up Register): 电源到器件引脚之间的电阻. 将引脚拉到高电平, 同时防止短路.

下拉电阻: 地到器件引脚之间的电阻, 将引脚拉到低电平. 