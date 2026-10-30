![linuxperf](linux-perf-tools.avif)

核心工具：
* **`htop`** 任务管理器
* `mpstat` 多核利用率和软中断
* `pidstat` 精确统计 CPU、IO、上下文切换
* **`perf record/stat/top`** 分析 CPU HotSpot、Cache Miss、上下文切换
* `free`  查看内存
* **`vmstat`** 查看内存 SWAP、IO Wait 行为
* **`iostat, iotop`** 查看磁盘 IO 瓶颈
* `fio` 磁盘 IO 的主动压测（benchmark）工具 
* `blktrace` 内核块设备延迟
* **`ss`** 查询网络链接状态
* `tcpdump` 抓包
* `strace` 系统调用分析，排查程序阻塞、颠簸等
* `lsof` 排查文件描述符泄漏
* `bpftrace` 利用 eBPF 的动态追踪：syscall 统计、IO 统计、延迟

## 高频问题排查

### 1. IO 吞吐下降

### 2. CPU 满载但程序慢

### 3. perf 定位热点

详见 [进程调试-perf](proc-stat.md)

### 如何判断瓶颈是 CPU 还是 IO？

`perf stat` ：
* IPC 低，cache-miss 高，说明是 IO 瓶颈
* branch-miss 高，说明是分支预测问题
* context-switch 高，说明是调度问题
* spin-lock 高，说明在频繁锁竞争

### 多核扩展性差？核增加没有提升

参考我设计的[线程池](../../algo/concurrency/thread-pool-work-stealing.md)，可能的原因：

* 频繁的锁竞争
* 内存瓶颈
* 多核间缓存不一致（false sharing）
* 调度器在核间迁移线程

### 如何设计一个 benchmark？

1. **配置**，固定频率，绑定 CPU 核，去除干扰任务
2. **预热**，让分支预测、缓存进入稳定状态，避免冷启动的干扰
3. **计时**，
4. **统计**，P50/P90/P99 
	* P50 操作延迟的*分位数*，即中位数
	* P90，第 90% 位置的数，表示尾部情况

### 系统占用 CPU 过高？

`perf` 中 `system%` 过高，原因：
* syscall 密集，如网络栈、频繁 IO 请求
* 内存 Page Fault 过多

### 驻留内存（RSS）持续增长？

查看是否有内存泄漏：
* 开 ASan 
* 查看 Page-Fault ，如果页缓存也在增长，一般没问题。否则是程序的堆内存泄漏。

### 磁盘吞吐量不够

* 顺序读取还是随机读取？
* direct IO 