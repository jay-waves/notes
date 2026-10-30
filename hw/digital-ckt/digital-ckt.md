
| 数字系统优势       | 缺点                                            |
| ------------------ | ----------------------------------------------- |
| 更准确地表示信息, 提供可靠易用的信息 存储 / 交换 / 处理 方式 | 要求稳定的电压和电流        |
| 对噪音和干扰抵抗力更强       | 从模拟信号转为数字信号时, 存在量化误差          |
| 能处理更复杂的逻辑和数据    | 因为设计和制造的复杂性, 数字系统的开发成本更高. |
| 能耗比更高, 省电        | 由于高度集成, 损坏的数字系统不容易被修复.       |

数字系统的分类:
- 组合电路 (Combinational Digital Systems): 输出只取决于本次输入.
- 时序电路 (Sequential Digital Systems): 输出可能受旧的输入影响, 换言之, 存在存储单元.
	- 同步时序电路 (Synchronous SC): 输入包含一个时钟信号. 速度变慢, 但行为更好预测.
	- 非同步时序电路 (Asynchronous SC): 

## 布尔代数

### 

### K-MAP

Karnaugh Map (K-Map) 是一种化简复杂布尔逻辑的方法. 一般能处理 2, 3, 4, 5, 6 变量的布尔逻辑.

## 组合逻辑

### 逻辑门

详见 [门电路](logic-gates.md)

#### NOT

![](../../attach/img/hw/logic-gate-not.avif)

| In1 | NOT |
| --- | --- |
| 1   | 0   |
| 0    |  1   |

#### AND

![](../../attach/img/hw/logic-gate-and.avif)

真值表:

| In1 | In2 | AND | NAND (NOT + AND) |
| --- | --- | --- | ---------------- |
| 0   | 0   | 0   | 1                |
| 1   | 0   | 0   | 1                 |
| 0   | 1   | 0   | 1                 |
| 1   | 1   | 1   | 0                 |

#### OR

![](../../attach/img/hw/logic-gate-or.avif)

用 AND 门表示 OR 门, 需要使用德摩根定理 (De Morgan's laws): $$\lnot (A \wedge B)=\lnot A\vee \lnot B$$

真值表:

| In1 | In2 | OR  |
| --- | --- | --- |
| 0   | 0   | 0   |
| 0   | 1   | 1   |
| 1   | 0   | 1   |
| 1   | 1   | 1    |

### 加法器

详见 [算术电路](arithmetic-ckt.md)

### 多路复用器 (Multiplexer, Mux)

多路复用器 (Multiplexers) 是一种多对一器件, 从多个输入中选取一个输出. 
包含 n 比特数据输入, m 比特控制输入, 1 比特数据输出. 其中 $n=2^{m}$, 由 m 控制选择哪一个输入.

```verilog 
module mux4to1 (
	input wire d0, d1, d2, d3;
	input wire [1:0] sel, // 复选信号
	output wire y 
);
	assign y = (sel == 2'b00) ? d0 :
			   (sel == 2'b01) ? d1 :
			   (sel == 2'b10) ? d2 :
							    d3;
endmodule
```

$y=(\neg s_{1}\wedge \neg s_{0}\wedge d_{0})\vee(\neg s_{1}\wedge s_{0}\wedge d_{1})\vee(s_{1}\wedge \neg s_{0}\wedge d_{2})\vee(s_{1}\wedge s_{0}\wedge d_{3})$

将两个 mux4to1 和一个 mux2to1 组成 mux8to1 复选:

```verilog 
module mux8to1 (
	input wire [7:0] d,
	input wire [2:0] sel, 
	output wire y
);
	wire y0, y1;
	mux4to1 mux_low (
		.d(d[3:0]),
		.sel(sel[1:0]),
		.y(y0)
	);
	mux4to1 mux_high (
		.d(d[7:4]),
		.sel(sel[1:0]),
		.y(y1)
	);
	
	assign y = (sel[2] == 1'b0) ? y0 : y1;
endmodule
```

### 编码器 (Encoder)

包含 n 比特数据输入, 其中只有一个输入为 1. 输出有 m 比特, 有 $n=2^{m}$, 是对输入的编码

### 比较器

## 时序逻辑

输出不仅受当前输入影响, 还受之前状态影响.

### 锁存器 (Latch)

锁存器能存储 1b 数据, 是一种非同步时序电路, 没有时钟信号.

### 触发器 (Flip-Flops)

触发器能存储 1b 数据, 是有时钟信号的同步时序电路, 在时钟边沿触发.  常见的触发器有 SR 触发器, D 触发器, JK 触发器.

### 移位寄存器

### 计数器

### 状态机

https://www.tutorialspoint.com/digital-electronics/index.htm

## 参考

https://www.tutorialspoint.com/digital-electronics/index.html

图片使用 Draw.io 绘制.
