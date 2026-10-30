## TOC 

| toc        | en                 | zh                    |
| ---------- | ------------------ | --------------------- |
| fs         | file system        |                       |
| io         |                    |                       |
| io/drivers |                    | 硬件驱动              |
| io/ipc     |                    | 进程间通信            |
| libc       |                    |                       |
| linux      |                    | 和 Linux 强相关的内容 |
| windows    |                    | 和 Windows 强相关内容 |
| mem        | memory managemnt   | 内存管理              |
| proc       | process mamagement | 进程管理              |
| shell      |                    | 脚本任务控制          |
| vm         | virtual machine    | 虚拟化                |
| tracing    |                    | 审计、追踪、调试                      |

## 操作系统的特征

**操作系统是**:   
1. 计算机**最基本**系统软件
2. 抽象, 控制和管理系统的**硬件和软件资源**, 组织调度计算机工作和资源分配.
3. 为用户和软件提供**接口与环境**的程序集合, 如 CLI, GUI, API.

其中**并发和共享**是基本特征.

### 并发 Concurrency

操作系统需要**同时执行多个任务**, 如果多个任务在微观上是同时发生的, 称为**并行**; 如果多个任务在宏观上是同时发生, 但微观是在有限的处理资源下交替分时发生, 则称为[**并发**](proc/thread.md).

- 指令级并行: 单处理器通过[**分时**](proc/thread-sched.md)实现并发, 核心是流水线技术.
- 数据级并行: 核心是对称多处理器并行技术.
- 线程级并行: [thread-sync](proc/thread-sync.md)

### 异步 Asynchronism

由于资源有限和处理分时性, 操作系统**无法预知任务的执行顺序, 因此以事件驱动的方式进行调度**, 通过[调度](proc/thread-sched.md)和[中断](proc/irq.md)机制来确保各个任务不会互相阻塞, 阻塞任务让权等待. 

### 虚拟 Virtual

将物理资源**抽象**为虚拟资源, 透明化底层的复杂性. **隔离**某些非临界资源, 让用户和进程在逻辑上独占资源.  

- 虚拟化 CPU
- 虚拟化内存
- 虚拟化外部设备

### 共享 Sharing

一些临界资源无法被彻底虚拟化, 需要多个用户和进程轮流使用 (互斥使用), 操作系统负责协调和分配资源.

操作系统资源不止是 CPU 运行机会, 也包括: 硬盘, 网卡, 内存资源. 多任务并发, 不止是互相抢占 CPU 运行机会, 也在抢占所有硬件资源. 


## 操作系统架构

```
 用户 
-------------
非内核功能
-------------
进程管理  存储器管理  IO 设备管理
时钟管理  中断处理   原语操作
-------------
硬件
```


![Windows 系统架构](../attach/img/os/win-arch.avif)

## 参考

*程序员的自我修养 -- 链接, 装载与库*. 俞甲子, 石凡, 潘爱民.

*Operating Systems, Internals and Design Principles*. William Stallings.

*Operating System Concept*. Abraham Silberschatz.

The Kernel in the mind 

Professional Linux Kernel Architecture. Wolfgang Mauerer. 
