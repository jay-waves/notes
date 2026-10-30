
### `sysstat`

`sysstat` 包是收集系统性能和使用情况的工具集, 包括 `mpstat`, `iostat`, `vmstat`, `sar`, `netstat`

`mpstat`, multiprocessor statistics, 报告 CPU 在用户态/内核态/iowait(等待I/O时间)/IDLE(空闲) 状态下所花费时间的百分比.

`iostat`, I/O statistics, 报告 各个设备传输速率, 每次 I/O 操作平均大小, 每秒进行的 I/O 操作数.

`netstat` 显示本机套接字信息, 见[net-stat](net-stat.md).

`vmstat`, virtual memory statistics, 报告关于虚拟内存/进程/CPU活动等信息:

```shell
$ vmstat 5 # 5s 刷新一次
procs -----------memory---------- ---swap-- -----io---- -system-- ------cpu-----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
 0  0   0  14900552  58160 397884   0    0     7     2    2   10  0  0 100  0  0
 0  0   0  14900552  58160 397884   0    0     0     0    3   36  0  0 100  0  0
```

| r                        | b                        | swpd            | free                 | buff       | cache          |
| ------------------------ | ------------------------ | --------------- | -------------------- | ---------- | -------------- |
| 运行队列                 | 等待 I/O 的进程数        | 虚拟内存量      | 空闲内存量           | 缓冲内存量 | 缓存内存量     |
| si                       | so                       | bi              | bo                   | in         | cs             |
| 从磁盘交换到内存数据量/s | 从内存交换到磁盘数据量/s | 读入块数        | 写出块数             | 中断数/s   | 上下文切换数/s |
| us                       | sy                       | id              | wa                   | st         |                |
| 用户态 CPU 时间占比        | 系统态 CPU 时间占比        | 空闲 CPU 时间占比 | 等待 I/O 的 CPU 时间占比 |   被偷取的 CPU 时间(如虚拟机使用的 CPU 时间)        |                |

`sar` 工具是上述工具的一个汇总前端。

### `dstat`, `glances`

`dstat` 可以视作 `sysstat` 的简易现代替代品. 

更深度系统信息则可以使用 [glances](https://github.com/nicolargo/glances), 会展示更多系统级数据.

### `lsxxx` series

查看硬件信息的一系列工具:
- `lsblk` list block devices, 如硬盘驱动器, 固态驱动器和usb等的信息.
- `lshw` list headware, 展示详细系统硬件信息.
- `lscpu` list cpu, 展示 CPU 架构信息
- `lspci` list PCI, 展示PCI总线上设备, 如显卡/网卡/声卡
- `lsusb` 展示 USB 设备的信息.
- `dmidecode` 解析系统 DMI (桌面管理接口), 提供主板/BIOS/处理器/内存信息.

### `lsof`

list open files. 因为 Unix 系统 "万物(硬件, 套接字, 管道)皆文件" 的思想, 该命令常用于调试系统问题.

```bash
# 列出某个用户打开的文件
lsof -u username
# 列出某个端口的进程
lsof -i :port 
# 列出某个进程打开的文件
lsof -p  pid
```

## 操作系统信息 

### uname 

```bash
uname -a 

# Linux ok3588 5.10.209-rt89 #9 SMP PREEMPT_RT Fri Jun 12 16:36:48 CST 2026 aarch64 aarch64 aarch64 GNU/Linux
```

### chrt 

查看调度信息 

```bash
chrt -m

# SCHED_OTHER min/max priority    : 0/0
# SCHED_FIFO min/max priority     : 1/99
# SCHED_DEADLINE min/max priority : 0/0
```

### ulimit

查看系统参数（限制）

```bash
ulimit -a 

# real-time non-blocking time  (microseconds, -R) unlimited
# core file size              (blocks, -c) 0
# data seg size               (kbytes, -d) unlimited
# scheduling priority                 (-e) 0
# file size                   (blocks, -f) unlimited
# pending signals                     (-i) 30402
# max locked memory           (kbytes, -l) 1006072
# max memory size             (kbytes, -m) unlimited
# open files                          (-n) 1024
# pipe size                (512 bytes, -p) 8
# POSIX message queues         (bytes, -q) 819200
# real-time priority                  (-r) 0              < 当前用户不能启动实时线程
# stack size                  (kbytes, -s) 8192
# cpu time                   (seconds, -t) unlimited
# max user processes                  (-u) 30402
# virtual memory              (kbytes, -v) unlimited
# file locks                          (-x) unlimited
```

## 磁盘信息

### `free`

检查运行内存 

### `df`

Shows disk usage. (disk free)

### [`du`](http://www.linfo.org/du.html)

Shows the disk usage of files or directories. 

```bash
du -hs # human readbale + summarize disk space info
```

### `quota`

Shows what your disk quota is.  

### `ldparm`

SATA/ATA 磁盘更改以及性能分析.

## CPU 信息

### lscpu 

```bash
lscpu -e

# CPU SOCKET CORE L1d:L1i:L2:L3 ONLINE    MAXMHZ   MINMHZ MHZ
#   0      0    0 0:0:0:0          yes 1800.0000 408.0000   -
#   1      0    1 1:1:1:0          yes 1800.0000 408.0000   -
#   4      0    0 4:4:4:0          yes 2256.0000 408.0000   -
#   5      0    1 5:5:5:0          yes 2256.0000 408.0000   -
```

## 网卡信息


