
## 并发缺陷分类

- [数据竞争](data-race.md)
- [原子性违反](atomicity-violation.md), Atomicity Violation. 原子性事务被打断. 属于语义上的错误.
- 偏序性违反, Order Violation. 两个事务的顺序被颠倒. 比如释放后使用, 初始化前使用.
- [死锁, Deadlock](../../../os/proc/thread-sync.md)

死锁类缺陷占总并发缺陷的 31%. 大部分 (97%) 非死锁类并发缺陷, 都属于 原子性违反和偏序性违反两类.[^2] 数据竞争只是"缺乏同步的访问", 其是否是恶性的, 仍取决于高层次的语义.

投资*系统可靠性*的性价比比投资并发缺陷检测高. 15年之后, 研究分布式系统, 异步事件系统和硬件并发的工作更多. 

## 并发缺陷来源

### 多线程

### 外部中断 [^1]

中断不会导致数据竞争, 因为中断会 (在指令边界) 打断当前控制流. 
中断会导致[原子性违反](atomicity-violation.md). 
为了提高系统的整体响应性, 在大部分架构上, 中断允许嵌套, 即允许更高优先级的中断打断当前的低优先级中断. 

另一种缺陷是: 在初始化之前或资源销毁后, 未正确关闭中断, 导致中断使用了未定义数据. 

只有很少一部分并发缺陷和中断嵌套相关 [^1], 但是修复非常棘手.

### 分布式系统 

TanakornLeesatapornwongsa,Jeffrey FLukman,ShanLu,andHaryadiSGunawi. 2016. TaxDC: A taxonomy of non-deterministic concurrency bugs in datacenter distributed systems. In Proceedings of the Twenty-First International Conference on Architectural Support for Programming Languages and Operating Systems. 517–530. https://doi.org/10.1145/2872362.2872374

### Actor-based 

Carmen Torres Lopez, Stefan Marr, Elisa Gonzalez Boix, and Hanspeter Mössen böck. 2018. A study of concurrency bugs and advanced development sup port for actor-based programs. In Programming with Actors. Springer, 155–185. https://doi.org/10.1007/978-3-030-00302-9_6

## 原子性违反检测

(大部分)原子性违反属于语义上错误. 常见检测方法, 要求用户明确"标注"原子区域.

## 动态数据竞争检测

### 观察点检测

观察点检测 (watchpoint detection) 设置程序中观察点或断点, 暂停某一线程执行, 观察是否有其他线程也访问了同一内存位置, 并且符合数据竞争模式.

* 通过 gdb, lldb. 在用户态, 有内核调度介入, 可能效果不好.
* 直接在内核态做: [windows data-collider](data%20collider.md), [linux-kcsan](../tools/sanitizers.md)

### 锁集分析

锁集分析 (Lockset Analysis) 追踪每个变量的锁集合, 如果一个变量在不同线程中被访问, 其锁集交集为空, 那么就可能存在竞争条件. 锁集分析是静态的, 会有误报.

- [Savage, 1997](eraser.md), (SBN+, 1997)

### 发生序关系

发生序关系 (Happens-Before Relation) 关注程序中多个事件的偏序关系. Happens-Before 算法是动态检测算法, 理论上没有误报. (但是数据竞争大部分是无害的)

- Vector Clocks, [M, 1988](Vector%20Clocks.md)
- Happens Before, [Lamport, 1978](happens-before.md), [Flanagan, 2009](FastTrack.md)

```
Data Race:
T1 : W(x) --> R(x)
T2 :    W(x)

No Data Race:
T1 : W(x) --> R(x) --> S(a)
T2                     S(a)  -> W(x)

No Data Race:
T1 : W(x) -> S(a) -> R(x)
T2           S(a) -> R(x)

No Data Race:
T1 : W(x) -> S(a)
T2 :         S(a) -> S(b)
T3 :                 S(b) -> R(x)
```

## 内存一致性模型

[内存一致性模型](../../../db/sql/transaction-concurrency.md), Memory Consistency Models

***

### 并发保护工具

加锁在大部分情况无法解决并发缺陷, 也不是最佳方法. [^2] 更常见的修复方法: 条件变量, 直接调整语句顺序, 重新设计算法 (比如参考 Rust 的内存模型). 

- 同步锁 Mutex Lock
- 自旋锁 Spin Lock
- 读写锁 
- 条件变量
- 原子操作 Atomic
- 信号量 Semaphore
- 内存屏障 Memory Barrier
- 读复制更新 RCU

|            | 同步锁         | 自旋锁           |
| ---------- | -------------- | ---------------- |
| 获取方式   | 获取失败则休眠 | 获取失败则忙等待 |
| 获取速度   | 较慢           | 较快             |
| 临界区大小 | 无特殊限制     | 普遍较小         |
| 使用场景   | 无特殊限制     | 主要用于内核     |
| 休眠操作   | 可使用         | 不可使用                 |

非内核的锁其实都是伪锁, 因为操作系统时间片用完都会强行切走.

## 参考

[^1]: An Empirical Study on Concurrency Bugs in Interrupt-Driven Embedded Software. ISSTA 2023. 

[^2]: Learning from Mistakes, Study on Real World Concurrency Bug Characteristics. Shan Lu, Soyeon Park. ASPLOS 2008.

