
## Atomv 分类

### 1. 单字长单变量

对单变量的有序的读写操作的一致性冲突. 
对同一变量 x 的连续 3 次访问, 有如下 4 种访问顺序组合可能导致有害数据竞争 [^1]. 其中 `*` 代表可以有其他读写操作.
- `R (t1)` --> `* W (t2) *` --> `R (t1)` 
- `W (t1)` --> `* W (t2) *` --> `R (t1)`
- `R (t1)` --> `* W (t2) *` --> `W (t1)`
- `W (t1)` --> `R (t2) *` --> `W (t1)`

该方法最早由 Lu'06[^4] 提出, 可能有误报. 其大致思路如下:
![](/attach/img/sec/AVIO.avif)

举个漏报的例子:
- T1: W1, R1, W2
- T2: R2

其中 (W1,R1,W2) 是原子区. 但是 (W1,R2,R1) 和 (R1,R2,W2) 均不符合检测模型. 实际应该检测的是 (W1,R2,W2). [^3]

### 2. 多字长单变量

对单变量的访问, 在源码中是原子地, 但是在汇编指令中不一定. 比如, 16b 整数, 在 8b 字长的平台上, 需要两次 `MOV` 指令. 如果两次 `MOV` 指令中间, 有中断触发, 可能导致 AtomV.

```c
timer1(void) isr_33 
{
	...
	UL_Time = CAN_Time; 
	/*
		MOV R1, (CAN_Time)
		                     <-----ISR
		MOV R2, (CAN_Time+1)
	*/
	...
}
```

### 3. 多变量语义相关

语法上不要求原子性, 但是语义上可能有关联. 比如: **用一个条件变量保护另一个数据变量; 连续地修改结构体的多个字段** 等. 编程人员通常能, 有意识地用同步机制保护此类行为, 但存在误用.



#### TOCTOU

TOCTOU (Time Of Check To Time of Use) 缺陷. 在检查资源与使用资源之间的短暂窗口, 通过改变资源状态, 导致使用资源时出错. 

### 4. 硬件误用

- 在弱内存一致性模型上, 新数据未刷写内存时, 有中断访问旧内存数据. 用 `volatile` 不能避免这一点, 需要[内存屏障](../../../hw/computer/内存一致性.md). 
- 一些硬件访问行为, 不是原子的, 需要连续的控制行为 (一段指令).

## 修复 AtomV 

屏蔽中断, 或增加其他同步机制. 在嵌入式系统中, 完全屏蔽中断会破坏系统实时性, 修复 AtomV 需要综合考虑. [^2]

## 参考

[^1]: 基于变量访问序模式的中断竞争检测方法. 2016. 陈睿, 杨孟飞, 郭向英. 中国控制工程研究所. 

[^2]: [Li, 2023]. An Empirical Study on Concurrency Bugs in Interrupt-Driven Embedded Software

[^3]: [Yu, 2009]. 

[^4]: [Lu Shan, 2001]. AVIO: detecting atomicity violations via access interleaving invariants

[Vaziri, 2006] Associating synchronization constraints with data in an object-oriented language.
