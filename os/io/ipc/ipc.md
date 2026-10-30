进程间通信, Inter-Process Communication, IPC. 有两种基本方式:
- 共享内存: 仅建立时需系统调用, 但需并发互斥访问. 数据格式和位置自由, 速度最快, 数据量大.
- 消息传递: 使用"发送/接收消息"原语, 内核持续介入, 耗时多. 但不需避免冲突. 用于较少数据量.

<img src="../../../attach/img/os/os-ipc-communication-modes.avif" alt="" width="400">

在具体实现上, 考虑到两进程状态, 还有同步和异步两种通信模式:
- 同步通信: 通过加锁和循环等待, 使进程阻塞, 直到*消息被接收*或*有消息可用*
- 异步通信: 直接发送消息, 并继续操作. 接收方通过*事件循环与回调*等方式来自动处理消息.

## BSD IPC

Unix BSD 进程通信方法:
- [管道, Pipe](pipe.md) 与命名管道 (named pipe)
- 软中断信号 (signal), 由系统提前定义
- [套接字, Socket](../socket.md)
- RPC

Unix BSD 域内的通信方式比 System V IPC 更加流行.

## SystemV IPC

Unix SystemV 进程通信方法:
- 消息, Message
- [共享内存, Shared Memory](shm.md)
- [信号量, Semaphore](sem.md)
- TLI (也是网络通信工具, 已经被淘汰)

> jweyrich -- [System V IPC vs POSIX IPC - Stack Overflow](https://stackoverflow.com/questions/4582968/system-v-ipc-vs-posix-ipc)
> 1. I believe the major difference is that all POSIX IPC is thread-safe, while most SysV IPC is NOT [[1](https://books.google.com.br/books?id=NzuLDQAAQBAJ&lpg=PT973&ots=rHiDCnbfJa&dq=POSIX%20IPC%20thread%20safe&pg=PT973#v=onepage&q=posix%20ipc%20is%20thread%20safe&f=false)].
> 2. Because of **Unix wars** [[2](http://en.wikipedia.org/wiki/Unix_wars)]. The **Single UNIX specification (SUS)** [[3](http://en.wikipedia.org/wiki/Single_UNIX_Specification)], aka POSIX, was created to standardise interfaces on Unix-based systems.

## Windows IPC

...
