```
    +--------------------------+
    |        Application       |
    +--------+-----------------+
    | (RTOS) | (Network Stack) |
    +---------+----------------+
    |      Device Drivers      |
    +--------------------------+
    |        Hardware          |
    +--------------------------+
```

嵌入式系统评价指标:
1. 处理器性能: 位宽 8bit, 算力 4MIPS 
2. 能效: 10mW/MIPS
3. 内存: 64KB, 1MB  
4. 开发费用: \$100,000
5. 硬件成本
6. 可靠性: 生命时长, 工作温度, 抗辐射强度

## 裸机启动脚本

以 SPARC V8 架构为例, 

1. 设置初始堆栈指针 (sp), 预留初始栈帧空间. 裸机的栈区一般定义在 RAM 末尾.
2. 初始化处理器状态: 各类寄存器, 配置等
3. 将未初始化的数据段 (.bss) 清零.
4. 初始化数据段. 对于哈弗架构的单片机 (ROM, RAM 分离), 数据段 (.data) 在断电时存储在 ROM 中. 上电时, 需要手动将 `.data` 拷贝到 RAM 对应地址中.
5. (不同硬件架构, 会定义一些额外步骤. 比如 SPARC 的中断向量表)
6. 完成硬件初始化后,  跳转到 C 入口函数 `main()` 开始执行程序.
7. 从 `main()` 返回后, 可以进入死循环, 避免跑飞.

```asm
set _stack_top, %sp
sub %sp, 64, %sp  

set _bss_start, %r2
set _bss_end, %r3
mov %g0, %r4          ! 数字零
bss_loop:
	cmp %r2, %r3
	bge bss_done
	st %r4, [%r2]
	add %r2, 4, %r2   ! 下一个数据, 地址4字节对齐
	ba bss_loop
	nop               ! 延迟槽, 不用管
bss_done:
	...

set _data_load, %r2   ! ROM 中数据源
set _data_start, %r3  ! RAM 中目标地址
set _data_end, %r4
data_loop:
	cmp %r3, %r4
	bge data_done
	ld [%r2], %r5
	st %r5, [%r3]
	add %r2, 4, %r2
	add %r3, 4, %r3
	ba data_loop
	nop 
data_done:
	...

call main
nop 

loop: 
	ba loop
	nop
```

## 时序分析

在时钟信号的 有效边沿 到来之前, 数据输入信号必须保持稳定不变一段时间, 被称为 *建立时间 (Setup Time)*. 在时钟信号的有效边沿到来之后, 数据输入信号仍须要保持稳定不变一段时间, 被称为 *采样时间 (Hold Time)*. 只有当建立时间和采样时间满足要求, 触发器才能正确采样并锁存数据.

时序图中, 会展示 *数据信号 (Data)* 和 *时钟信号 (Clock)*, 并标记 $t_{setup}, t_{hold}$

## 参考

[1] Programming Embedded Systems with C and GNU Development Tools. Michael Barr, Anthony Massa. 2nd

[2] Linux 设备驱动开发详解: 基于最新的 Linux4.0 内核. 宋宝华. 机械工业出版社.