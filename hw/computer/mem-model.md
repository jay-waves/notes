## TSO Memory Model

x86 TSO (Total Store Order) 内存模型. 每次处理器读操作时, 会参考主存和自己独立的*未提交写队列 (存储缓冲区, Store Buffer)*; 但是无法看到其他处理器的写队列. 所有处理器对存储操作顺序达成全局一致, 并允许读操作绕过写操作. 

<img src="../../attach/img/hw/Snipaste_2025-04-02_15-29-40.avif" alt="" width="675">

TSO 不保证 Store->Load 这种操作的顺序: `store x` 时, x 可能被存储在 store buffer 中, 未写回内存; 此时 `load x`, 实际读取了 `store x` 发生之前的值.

```
Litmus Test:

// Thread 1
x = 1
r1 = y

// Thread 2
y = 1
r2 = x

Can this program see r1=0, r2=0?
- x86: yes 
- arm: yes
```

实际上, 现代 x86/amd64 架构都是 PSO 模型, 内存一致性更弱. PSO 和 TSO 的区别:
- single-writer-multiple-readers locks 编程模型在 PSO 和 TSO 均有效.
- write-locks only (without reader locks) 编程模型在 PSO 可能失效, 在 TSO 有效. 除非 PSO 下对共享数据添加内存屏障.


### Spin Locks

使用 Sparc v8 架构汇编实现, 借助 `swap` 原子指令,`swap` 原子地将一个寄存器和一个内存地址处的值交换.

```sparc
lock_with_swap(lock, old)
retry: 
	mov -1, %l0
	swap [lock], %l0
	tst %l0
	be out 
	nop 
loop: 
	ld [lock], %l0
	tst %l0
	be loop
	nop 
	ba,a retry
out:
	st %l0, [old]

unlock_with_swap(lock, new)
	ld [new], %l0
	stbar               # for PSO 
	st %l0, [lock]
```

### ConditionVariable 

假设有 N 个线程 `count=N`, 当所有线程均执行到 `barrier` 后再执行下面的逻辑.

```c 
barrier_with_swap(int *count) {
	int current_value;
	lock_with_swap(count, &current_value);
		current_value--;
	unlock_with_swap(count, &current_value);
	while(*count > 0) {; /* busy-wait */}
}
```

## Relaxed Memory Model

常见于 Arm 和 PowerPC 架构, 比 TSO 内存模型更松散. 每个处理器有独立的存储副本, 写操作会通知其他处理器, 并可能发生写顺序不一致. 

<img src="../../attach/img/hw/relaxed-memory-order.avif" alt="" width="400">

TSO 不保证 Store->Load 的顺序, 但是其他情况在不同 CPU 核间都是顺序的. 但 WMO (Weak MO) 中, Load/Store->Load/Store 顺序都是可以打乱的, 允许硬件随机调整访存顺序, 除非用内存屏障来主动约定 Happens-Before 关系. 

```
Litmus Test:

// Thread 1
x = 1
y = 1

// Thread 2
r1 = y
r2 = x

Can Thread2 see r1=1, r2=0?
- x86 (TSO): no
- ARM/RISC-v: yes
- modern compiled language: yes
```

- WMO 对不同地址的读写: 乱序执行, 因为缓存情况不一.
- WMO 对同一地址的读: **所有线程对同一个地址的写的观测顺序一致.** 对于单线程的多次读, 只能看到这个写历史的某个前缀, 而不会出现"倒退".

### Invalidate Queue 

在 RMO 中, CPU 可以提前发起 Load, 而不等待其他 CPU 核的 Store 完全同步. 其他核通过 MESI 协议通知本 CPU (某些 Cache 已经失效). 该消息存放在 Invalidate Queue 中, 延迟到必要时处理.

如果 Invalidate Queue 未处理完, 可能缓存中的数据是过时的.

### Data-Race-Free Sequential Consistency (DRF-SC)

由于硬件内存模型的差异性, 上层软件需要和硬件设计者建立更准确的协定, 避免内存模型的强弱可能直接导致软件是否生效. (Sarita Adve, Mark Hill, 1990')[^3] 提出弱一致性模型: 

> Let a synchronization model be a set of constraints on memory accesses that specify how and then when synchronization needs to be done.
> Hradware is weakly ordered with respect to a synchronization model if and only if it apperas sequentially consistent to all software that obey the synchronization model.

大意为, 硬件内存模型可以很松散, 但需要提供同步原语. 如果软件使用同步原语达成了[正确事件偏序关系](../../sec/software-analysis/thread-safety/happens-before.md), 那么硬件至少应该保证这一点. 该模型被称为 DRF-SC (Data-Race-Free Sequential Consistency), 在软件没有数据竞争风险时, 硬件也不会引入内存不一致.

## 内存屏障 (barrier, fence)

**内存屏障主要缓解同一线程/核心内的内存指令重排，确保程序顺序对自身执行结果和对外可见性一致，对象是操作不同内存地址的 load/store 指令顺序。
缓存一致性协议则主要缓解多线程/多核心之间的指令顺序，确保不同核间观察同一内存地址的数据保持一致，对象是操作同一内存地址的 load/store 指令顺序**。

| 线程内指令顺序               | 硬件                                      | x86 TSO | ARM | 避免重排措施                   |
| ---------------- | ------------------------------------------- | ------- | ----------- | ------------------------- |
| `store -> load`  | 前面的 store 还在 Store Buffer，<br>后面的 load 先读 cache | 可乱序      | 可乱序          | release + acquire              |
| `store -> store` | 两个 store 进入对外可见路径的顺序                              | 基本保序    | 可乱序         | release barrier             |
| `load -> store`  | 还没确认 load 结果，后面的 store 先对外可见                           | 基本保序    | 可乱序         | acquire barrier  |
| `load -> load`   | 后面的 load 提前发出或投机完成                               | 基本保序    | 可乱序         | acquire / load-load barrier      |


## 编译器内存模型

编译器提供的内存模型可能比 WMO 更弱. 在下面的例子中, 对同一个地址的写顺序, T3 和 T4 出现了不一致. 原因是, 编译器的某种优化将 T4 的汇编顺序给颠倒了.

```
Litmus Test: IRIW 

//Thread 1
x = 1

// Thread2
x = 2

// Thread 3
r1 = x
r2 = x

// Thread 4
r3 = x
r4 = x

Can this program see r1=1, r2=2, r3=2, r4=1?
- TSO: no 
- ARM: no 
- modern compiled language: yes (thread 4: r3=2, r4=1)
```

### 编译器常量优化

编译器为了减少不必要的内存访问延迟, 使用了 *常量优化* 技术, 将多次对内存的写操作优化为对寄存器的操作, 只在最后将寄存器值写入内存一次. 同时保证语义的等价性. 

但是在有外设和多处理器的硬件上, 常量优化可能导致数据不一致问题:
- 同一内存地址, CPU 可访问, 外设也可能直接访问. 
- 同一内存地址, CPU0 可访问, CPU1 也可能访问.

因此编译器引入 `volatile` 关键字, 保证编译器不进行 "常量优化/常量折叠", 而总是从内存中读取最新的值. 具体而言:
1. 阻止编译器为优化速度, 将变量缓存至寄存器而不写回.
2. 阻止编译器调整标注 `volatile` 变量的指令顺序. (较少)

```
int x;
volatile int done;

// Thread 1
x = 1;
done = 1;

// Thread 2
while (done == 0) { /* loop */ }
print(x)
```

`volatile` 不同于内存屏障, 它只能保证不进行常量优化, 但是不能避免 CPU 乱序执行.  因此, 理论上 Thread2 可能会打印出 `0` 而不是 `1`. 

乱序执行需要使用 `barrier()` 来屏蔽.


## NUMA 

非统一寻址内存模型



## 参考

https://research.swtch.com/hwmm. https://research.swtch.com/plmm. 内存模型区别的具体例子请看这篇.

[A Better x86 Memory Model: x86-TSO. Scott Owens. 2009](https://www.cl.cam.ac.uk/~pes20/weakmemory/x86tso-paper.tphols.pdf)

https://www.cl.cam.ac.uk/~pes20/papers/topics.html#Power_and_ARM

Sparc Architecture Manual v8

[^1]: 程序员的自我修养--编译, 装载与库. 俞甲子等. P25. https://www.zhihu.com/question/388121842/answer/1195382979

[^3]: Weak Ordering - A New Definition. 1990. Sarita Adve, Mark Hill.





