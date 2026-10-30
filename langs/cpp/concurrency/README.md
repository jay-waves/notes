## 并发

并发的模式:
1. 从硬件能力: 并行, 并发, [GPU并行](../../../hw/cuda.md)
2. 从资源规模: [进程, 线程](../../../os/proc/thread.md), 协程. 
3. 从任务类型: 计算密集型 (CPU-bound), I/O密集型 (I/O-bound), 数据密集型 (同类数据的并行处理, 如像素矩阵和数据分析), 任务密集型 (使用分布式系统, 处理大量关联较弱的任务, 如不同网络用户的请求). **主要目的是提高计算速度和响应速度, 避免等待和卡顿**.
4. 从[通信和同步模式](../../../os/io/ipc/ipc.md): 异步共享内存, 同步共享内存, 异步消息传递, 同步消息传递

进程相关: 操作系统负责管理进程, 而不是编程语言, 编程语言通过封装操作系统的*进程通信与同步*相关的系统调用, 来向上提供管理进程的功能. 除了 C/C++, 其他通常不好用.
- 进程间通信 [IPC](../../../os/io/ipc/ipc.md)
- [thread-sched](../../../os/proc/thread-sched.md)
- [thread-sync](../../../os/proc/thread-sync.md)

线程相关: 线程间同步涉及对**同一进程下的共享内存**的访问控制. 从语言实现方面, 线程可能是并行也可能是并发 (Python), 协程是并发.
- [互斥锁与信号量](../../../os/proc/thread-sync.md#信号量)
- [条件变量](../../../os/proc/thread-sync.md#条件变量)
- [读写锁](../../../os/proc/thread-sync.md#读写锁)

协程相关: 线程阻塞时让出 CPU, 是交由操作系统调度器处理的; 而协程是**用户态调度**的, 通过关键字 `yield, await` 主动让出 CPU. 协程也称为用户态线程. 协程本质是单线程的并发协调技术, 不同实现方式间有较大区别.
- Promise/Future 模型, Async/Await 模型. 都是 事件+回调 的同步方式.
- [Python](../../python/py-concurrency.md) 使用生成器来模拟协程, 生成器每次 `yield` 后会暂停, 和协程等待的概念很类似. 虽然但是 pyhton 也提供了原生的 [asyncio](../../Python/并发与并行/asyncio.md)
- [Go](../../go/go-concurrency.md) 使用 Goroutine 轻量协程概念, 并提供了 `channel` 来进行阻塞/非阻塞通信.
- 异步I/O

异步I/O方式(事件驱动+回调)和协程的概念有一些区别, 但是可以用异步I/O来模拟协程. 如: Async/Await 是 Promise/Future 的封装, 但是 async/await 在语义上更接近协程概念.


## C++并发

```cpp
// C++11
#include <atomic>
#include <condition_variable>
#include <future>
#include <mutex>
#include <thread>

// C++17
#include <execution>
#include <shared_muttex>

// C++20
#include <barrier> 
#include <latch>
#include <semaphore>
#include <stop_token>
```

###

C++ 倾向于依赖作用域嵌套来管理对象生命周期, 但异步就像 `goto` 一样, 能轻易地改变作用域的嵌套关系. 基于链式回调的异步函数的执行环境并不是"本地的" (non-local), 连异常都没办法正常使用.

```cpp
boost::future<void> computeResult(State & s);
 
boost::future<int> doThing() {
  State s;
  auto fut = computeResult(s); // future 只确保 then() 在 computeResult() 结束后执行. 
  return fut.then(
    [&](auto&&) { return s.result; }); // future 不确保 then() 在 return 之前执行.
}
```

用协程重写上述函数, 能确保 `computeResult` 在 `doThing()` 退出前执行. 协程的主要目的不是并发, 而是协调各个回调的执行顺序.

```
task<> computeResult(State &s);

task<int> doThing() {
	State s;
	co_await computeResult(s);
	co_return s.result;
}
```

### cotoutine

见 [c++ coroutine](coroutine.md).

## 参考

https://ericniebler.com/2020/11/08/structured-concurrency/

https://vorpus.org/blog/notes-on-structured-concurrency-or-go-statement-considered-harmful/

[Trying out C++26 executors -- Mathieu Ropert](https://mropert.github.io/2025/11/21/trying_out_stdexec/)