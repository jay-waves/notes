从用户态 (User Mode) 切换到内核态 (Kernel Mode) 的方式:

1. [syscall](../libc/syscall.md)
2. 中断

## 中断与异常

现代操作系统的显著特点是: *中断驱动*. 中断是让内核程序夺回 CPU 使用权的唯一途径. 中断包括:  

- 外中断 (硬中断): 由硬件引起, 中断信号来自 CPU 外部. 如:
	- CPU 时钟中断
	- I/O 中断, 键盘鼠标按下
	- 电源掉电
- 内中断 (*异常*, 软中断): 由软件引起, 信号来自 CPU 内部. 如:
	- *陷入*, trap, 程序引发, 请求系统调用.
	- *故障*, fault, 指可被内核程序修复的错误. 如缺页故障.
	- *终止*, abort, 致命错误, CPU 不会再归还使用权, 而直接终止该程序. 如整除 0, 非法使用特权指令.

不同功能的中断由不同的*中断号*, 对应一个*中断处理程序 (Interrupt Service Routine, ISR)*. 两者之间的映射关系, 由内核数据结构 * 中断向量表 (Interrupt Vector Table)* 记录. 由于中断号很有限, 所以系统调用和中断号不是一一对应的, 而是由另一个值决定系统调用号 (如 x86 系统中的 `eax` 寄存器). 

在事件驱动的系统中, 有*轮询 (Polling)* 和*中断 (Interrupt)* 两种响应事件方式. 轮询效率低, 中断则可以实时响应. 中断基本工作原理如下:
1. 事件发生: 触发中断信号
2. 中断检测: 处理器在每个指令周期检测中断标志位
3. 中断响应:
	- 保存当前任务的寄存器和程序计数器 (PC)
	- 跳转到中断处理程序 (ISR) 并执行
4. 返回主程序: 恢复中断前上下文, 继续执行

### 

### 多级中断

...

### I/O 操作 中断处理

<img src="../../attach/img/os/os-io-timing-diagram.avif" alt="" width="400">

1. CPU 通过 I/O 指令通知 I/O 设备控制器.
2. 控制器操作具体设备执行 I/O 操作, CPU 执行其他指令.
3. I/O 完成后, 控制器触发中断, 通知 CPU
4. CPU 根据中断号查询**中断向量表, 执行中断处理程序**.

### 执行系统调用

系统调用过程详见 [syscall](../libc/syscall.md), 常见类 Unix 系统的系统调用列表见 [Appendix/UnixSystemCall](../libc/linux-syscalls.md). 现代 CPU 通常提供多级不同权限的中断 (**特权等级**), 但 
Linux 只使用其中两种, 含义仍是内核空间和用户空间.

<img src="../../attach/img/os/os-user-kernel-mode-switch.avif" alt="" width="500">

![400](../../attach/img/os/os-system-call-process.avif)


