## 进程

**进程的定义:** 一个程序在一个数据集上的一次执行.  
注意区分程序和进程, 程序是**静态**存储在磁盘上的可执行文件, 进程是**动态**保存在内存中的程序的一次执行过程.

### 内存中结构

进程资源:
- 代码段, Text, 存放指令序列
- 数据段, Data, 全局变量和静态变量
- 堆栈段, 栈一般又编译器自动分配, 堆则由程序员动态分配.

<img src="../../attach/img/os/os-process-control-block.avif" alt="" width="150">

进程控制块, PCB, Process Control Block:

操作系统用于存储进程相关信息的数据结构, 存放在独立内存区域. 

<img src="../../attach/img/os/os-process-memory-layout.avif" alt="" width="150">

### 进程的创建, 终止, 唤醒, 切换, 阻塞

1. `ps` 查看进程
2. `pstree` 查看进程树. linux 初始进程是 init

`fork()` 系统调用, 调用一次, 返回两次. 用于创建父进程的完整副本. 返回值用于区分父子进程, 父进程返回新建子进程id, 子进程返回0, 出错返回-1.

`clone()`调用, 创建轻量级**线程**, 有选择地继承父进程资源.

```c
int main(void)
{
    pid_t pid;
    const char *message;
    int n;

    pid = fork();

    if (pid < 0) {
        perror("fork failed");
        exit(EXIT_FAILURE);
    }

    if (pid == 0) {
        message = "This is the child\n";
        n = 6;
    } else {
        message = "This is the parent\n";
        n = 3;
    }

    return 0;
}
```

`exec()` 系统调用, 将进程**完全**替换为新程序的进程.

`exit()`系统调用, 中止进程. 

`wait()`, `waitpid()`系统调用, 父进程等待子进程执行结束, 并获取其返回值.

进程唤醒指将进程**从阻塞态变为就绪态**, 切换则指**就绪态和运行态的转换.** [操作系统并发](irq.md)需要**进程上下文切换 (Context Switch):**

```mermaid 
flowchart LR
    main((main)) --> fork((fork))
    fork -->|Child| childExit((exit))
    fork -->|Parent| parentExit((exit))
```

## 线程

随着 [CPU 单核频率](../../hw/computer/cache.md)接近上限 (<8GHz), 多核心并行执行越发重要, 多线程是多核并行执行的方法之一. 线程是 CPU 调度基本单元, 拥有独立的"线程 ID, 线程状态, 程序计数器 PC, 寄存器组, 栈空间", 多线程可隶属于同一进程. 线程控制块称为 TCB (thread control block).

进程是资源分配的基本单位, 内核级线程则是 CPU 调度的基本单位:

|                            | threads of the same process | process     | examples                                      |
| -------------------------- | --------------------------- | ----------- | --------------------------------------------- |
| address                    | shared                      | independent |                                               |
| heap                       | shared                      | independent | malloced array                                |
| stack, registers           | independent                 | independent | function parameters, local variables, PC, esp |
| runtime                    | shared                      | independent | my_program.exe                                |
| data, bss, mmap            | shared                      | independent | static/global variables, opened files,        |
| TLS (thread local storage) | independent                 | independent |                                               |
| os resources               | shared                      | independent | file handlers, socket handlers                                              |

<img src="../../attach/img/os/os-thread-process-resource-mapping.avif" alt="" width="400">

### 多线程调度

操作系统的特征是 **[共享](../README.md)**. 同时运行多个程序时, 为了防止系统响应变差甚至阻塞, 不能让某个程序异常地抢占资源 (空耗, 而不让出控制权). 因此, 抢占调度, 对多任务并发和共享资源而言是必要的.

线程是*抢占调度的 (Preemptive)*, 方法为[时间片调度](thread-sched.md). 调度时机不可预料, 因此, 访问共享资源时, 需要用[锁](thread-sync.md)来避免竞争. 

### 多线程优势

- 耗时任务或轮询时, 单线程陷入等待状态. 多线程可高效利用等待时间, 例如等待大量网络响应.
- 线程资源比进程轻量, 所以其创建与上下文切换更经济. 
- 同一进程下的线程数据共享比进程间数据交换更方便.

### 多线程实现模型

多对一模型: 指用户线程, 线程在用户空间管理, 内核只支持进程. 线程切换无需内核参与, 但线程无法并发, 单线程阻塞会导致整体阻塞. 

```
  T1 ─┐
  T2 ─┼──> [线程库]
  T3 ─┘         │
────────────────┼───────────── Kernel 
                │
               (P)
```

一对一模型: 并发性好, 但内核模式切换开销较大, 线程总数量受到内核限制. 系统 API 创建的线程一般为一对一线程, 如 linux 下的 `clone()`, windows 下的 `CreateThread()`.

```
  T1       T2       T3
  │        │        │
──┼────────┼────────┼───────── Kernel 
  │        │        │
 K1       K2       K3
   \       |       /
    \      |      /
          (P)
```



多对多模型: 这里用户线程指"代码逻辑", 而内核线程则指"运行机会". 该模型没有被操作系统广泛使用: [^1]
* 内核线程和用户线程都需要调度, 导致调度方式很复杂
* 用户线程没有和内核资源绑定, 导致有安全性和 IPC 问题. 
* 用户线程的阻塞操作也会阻塞内核线程, M:N 模型要求此时内核线程可被调度到别处, 先前阻塞的任务完成后需要回调机制来通知用户线程调度器 (实际上难以实现).

一些语言运行时库 (如 GO, C#) 支持这种调度方式, 被称为*[协程 ](green-thread.md)*, 但不是在 pthread 层面实现的, 并且仍假设用户不会执行大量阻塞操作. 

```

  T1 ─┐
  T2 ─┼──> [线程库]
  T3 ─┘      /    \
────────────/──────\─────── Kernel 
           K1      K2
             \    /
              (P)
```

[^1]: M:N 调度模型的实现方式, 见 @shiina2021