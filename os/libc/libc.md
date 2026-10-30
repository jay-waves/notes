## 何为 C 标准?

C 语言诞生于 AT&T 的贝尔实验室, 但功能不完善. 1983 年美国国家标准协会 (ANSI) 
成立 C 语言标准委员会, 于 1989 年建立第一个完整的 C 语言标准, 称为 ANSI C89, 
其中包括了标准函数库[^7].

C/C++ 语言标准运行库 (CRT) 主要包含以下功能:
- 启动和退出: `xxx_crt_entry()`, `exit()`, `atexit()`
- 标准函数: 由 C 语言标准规定的函数实现. 
- 扩展函数, 如编译器的内置函数.
- 系统调用接口.
- 线程和并发支持.
- I/O (文件): `fopen(), fread(), fwrite(), fclose(), fseek()` (注意, 并非文件系统)
- I/O (字符串): `strcpy(), strlen(), strcmp()`
- I/O (格式化与输出): `printf(), sprintf()`
- 堆: 动态内存支持 `malloc(), free()`
- 调试

编译器实现的运行时库, 一般是 语言标准 的超集, 提供了各种扩展和平台相关支持. 另外, 启动代码 (crt0.S), 连接脚本 (link.ld) 不属于标准库, 而是 *BSP (Board Support Package)* 的一部分.

| 操作系统                       | 编译环境   | C 标准实现                 | C++ 标准实现 | 解释                                                                      |
| ------------------------------ | ---------- | -------------------------- | ------------ | ------------------------------------------------------------------------- |
| GNU/Linux                      | GCC        | glibc                      | libstdc++    | Linux libc 目前使用 glibc2.x                                                                        |
| GNU/Linux                      | Clang/LLVM | <nobr>llvm-libc[^2]</nobr> | libc++       | 较旧版本的 LLVM 仍使用 glibc, 而 libc++ 是 LLVM 独立实现的现代 C++ 标准库 |
| Alpine Linux                   |            | musl libc                  |              | Alpine 发行版使用 musl libc                                               |
| BSD (FreeBSD, NetBSD, OpenBSD) |            | BSD libc                   |              |                                                                           |
| macOS, iOS                     | Clang/LLVM | apple libc                 | libc++       | macOS 前身基于 BSD, 因而 Apple libc 基于 BSD libc                         |
| Windows                        | Clang/LLVM | MSCVrt [^3]                | MSVC++       | 一套标准实现就支持*多平台*是 LLVM 的设计目标                              |
| Windows                        | GCC/MinGW  | MSVCrt                     | MSVC++       | 借助 MinGW 模拟 GNU[^1]                                                 |
| Windows                        | MSVC[^6]   | MSVCrt                     | MSVC++       | Microsoft Visual C, 原生库和集成环境                                      |
| Embedded System, Bare Metal    |            | newlib                     |              |                                                                           |
| Embeeded System, Linux         |            | eglibc                           |              |                                                                           |

### MSVC CRT 

以 Visual C++ 2005 为例, 标准库实现如下. 

| 文件名      | DLL              | 属性                   | 编译选项 | 预编译宏            |
| ----------- | ---------------- | ---------------------- | -------- | ------------------- |
| libcmt.lib  |                  | 多线程[^9], 静态链接       | /MT      | `_MT`               |
| msvcrt.lib  | msvcrt80.dll[^8] | 多线程, 动态链接       | /MD      | `_MT, _DLL`         |
| libcmtd.lib |                  | 多线程, 静态链接, 调试 | /MTd     | `_DEBUG,_MT`        |
| msvcrtd.lib | msvcr90.dll      | 多线程, 动态链接, 调试 | /MDd     | `_DEBUG, _MT, _DLL` |

MSVC 也提供的 C++ 标准库, 称为 C++ CRT. 这里的 C++ 运行时只能支持 C++98, 无法支持 C++11 以后的高级功能.

| 文件名       | DLL          | 属性                   | 编译选项 | 预编译宏     |
| ------------ | ------------ | ---------------------- | -------- | ---------- |
| libcpmt.lib  |              | C++, 多线程, 静态链接       | /MT      | `_MT`        |
| msvcprt.lib  | msvcp90.dll  | C++, 多线程, 动态链接       | /MD      | `_MT, _DLL`  |
| libcpmtd.lib |              | C++, 多线程, 静态链接, 调试 | /MTd     | `_DEBUG, _MT` |
| msvcprtd.lib | msvcp90d.dll | C++, 多线程, 动态链接, 调试 | /MDd     | `_DEBUG, _MT, _DLL`           |

在 Windows10 较新版本中, 引入了新的标准库 UCRT (Universe C Runtime) 和 C++ 运行时库. C++ 运行时库包括了异常处理 / RAII / 内存分配等语言内置功能, 而 C++ STL 则是标准库头文件的实现. C++ STL 依赖于 C++ 运行时, C++ 运行时依赖于 C 运行时, 但动态链接时它们都是并行导入的.

| 文件                         | 线程属性 | 链接属性 | 外部依赖                                           |
| ---------------------------- | -------- | -------- | -------------------------------------------------- |
| `libucrt.lib`                | 多线程   | 静态     |                                                    |
| `ucrt.lib`                   | 多线程   | 动态     | `ucrtbase.dll`                                     |
| `vcruntime.lib` (C++ 运行时) | 多线程   | 动态     | `ucrtbase.dll`, `vcruntime140.dll`                 |
| `msvcp.lib` (C++ STL)        | 多线程   | 动态     | `msvcp140_x.dll`, `vcruntime140_x.dll`, `ucrtbase.dll`                                                   |
| `libcpp.lib` (C++ STL)       | 多线程   | 静态     | `libvcruntime.lib` (C++ 静态运行时), `libucrt.lib` |

Windows 的运行库版本和属性不一致时, 会出现莫名其妙的链接问题. 解决办法是尽量使用同一版本的 CRT, 并在发布时将对应版本的 CRT DLL 同程序一起分发给用户.

Windows 允许同一程序链接**使用不同版本 C 运行时的动态库**, 各个 `.dll` 都有相对独立的 `.CRT` 和地址空间; 而 Linux 下默认 `main` 和 `.so` 共享同一个进程地址空间, 即运行时库只会被加载一次, `main` 和 `.so` 的标准库版本不一致可能导致崩溃, `main` 和 `.so` 的全局符号也可能冲突. 当使用不同版本 C 标准库的 `.dll` 链接在一起时, 不能跨模块共享对象和异常.

同理, Windows 下的 Debug/Realse 版本也会使用不同的标准库文件, 当混用 debug 和 release 的 `.dll` 时, 同样存在上述问题.

### 多线程支持

C 标准以及 C++ 标准的较久版本 (C98, C++03, C++98) 都不提供多线程功能. 多线程/网络/图形等基础库的接口, 都是系统提供的, 即平台相关的. C/C++ 运行时, 虽然不提供多线程函数接口, 但要保证程序在多线程环境下可以正常运行.

早期的 C/C++ 运行时在多线程下并不安全, 换言之, 这些函数是不能重入的.
- 错误代码都放在全局的 `errno` 全局变量里.
- `malloc/new, free/delete`, 不是线程安全的, 分配的内存可能混叠.
- 异常处理: 早期 C++ 抛出的异常, 在不同线程中抛出的异常可能彼此冲突.
- `printf` 不是线程安全的, 多个线程同时输出时, 信息会混杂在同一控制台.

在线程安全的 C/C++ 版本中, 不可重入的的函数会在函数起始和结束时加锁, 全局状态变量则放在 TLS (线程局部存储, Thread Local Storage) 中. 要将一个全局变量定义为 TLS 变量, 需要用编译器提供的宏, 此后每个线程都会有该全局变量的独立副本.

```c
__thread int number; // GCC 

__declspec(thread) int number; // MSVC 2008+
```

操作系统提供的线程库是比较陈旧的, 为了跨平台和封装更高层的语义, 推荐使用新版本 C/C++, 或者流行的开源库 (libuv, asio 这类).

## 系统调用

因为 C 语言是系统级语言, 除了通用标准库 libc 外, 编译器还需要实现大量系统调用. 如在类 Unix 系统上 (BSD, Linux, MacOS), 常使用 POSIX 标准定义的 API; 在 Windows 上, 则使用 Windows API.

| 系统调用标准                                    | 维护组织           | 解释                                       | 平台支持      |
| ------------------------------------------- | ------------------ | ------------------------------------------ | ------------- |
| POSIX (POSIX Operating System API)                                     | IEEE               |                                            | Unix-like     |
| Windows API                                 | Microsoft          |                                            | Windows       |
| LSB (Linux Standard Base)                   | Linux 基金会       | 提高 Linux 不同发行版之间的兼容性          | Linux         |
| SVID (System V Interface Definition)        | AT&T, Unix SystemV | 不常见, 仅兼容[^5]            | Unix SystemV |
| RTOS (Real-teim Operating System Standards) |                    | 在嵌入式系统中, 用于提供更低延迟和更高确定性 |               |
| XPG, SUS                                     | The Open Group     |   不常见                                         | Unix[^4]          |

**不同的平台和工具链, 会导致不同的ABI/API. 和软件的兼容性休戚相关.**

例子: llvm 预编译安装包命名为: `llvm-18.1.8-x86_64-pc-windows-msvc.tar.xz`, 软件名及版本为 `llvm-18.1.8`, CPU指令集及字长为 `x86_64`, 平台为 `pc`, 系统为 `windows`, 编译工具链为 `msvc`.

其他, `llvm-18.1.8-aarch64-linux-gnu`, `llvm-18.1.8-armv7a-linux-gnueabihf`, `llvm-18.1.1-powerpc64le-linux-rhel-8.8`. powerpc64le -> PowerPC 64-bit Little Endian, linux-rhel -> Red Hat Enterprise Linux 8.8

### 系统调用头文件

SVID 系统调用头文件: Unix 系统最早由 AT&T 开发, 后续分支有 BSD 和 System V. System V 接口标准为 SVID, 也有其他不同接口标准.

```c
#include <sys/ipc.h>   // 进程间通信
#include <sys/shm.h>   // 共享内存
#include <sys/sem.h>   // 信号量
#include <sys/msg.h>   // 消息队列
```

POSIX 系统调用头文件: IEEE 在 1988 年制定了 POSIX 标准用于统一 UNIX 系统的接口, 主要是基于 System V 和 BSD 接口.

```c
#include <unistd.h>    // 系统调用, 进程管理, 文件输入输出
#include <fcntl.h>     // 文件控制
#include <sys/types.h>
#include <sys/stat.h>  // 文件类型
#include <pthread.h>   // 线程
#include <signal.h>    // 错误处理
#include <errno.h>     // 错误码
```

LSB 系统调用头文件: Linux 参考 POSIX 标准, 同时也为了兼容性, 大量引入 System V 接口.

```c
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sys/syscall.h> // 直接系统调用
```

[Windows API](windows-api.md)

当然, 如果想在 Windows 上使用 POSIX 系统调用, 可以使用 Cygwin 或 MinGW 等提供 POSIX 接口的兼容层; 或者使用 Boost, Qt 等上层库. 对于文件, 线程管理等功能性接口, 使用 C/C++ 语言标准库也可以屏蔽平台的差异.

## 参考

https://users.cs.cf.ac.uk/Dave.Marshall/C/. Dave Marshall. 1999-03.

https://learn.microsoft.com/en-us/cpp/c-runtime-library/crt-library-features?view=msvc-170

[^4]: SUS 和 XPG 都是针对**正式 UNIX** 系统的, 而不是类 Unix 系统. 

[^5]: System V 是 AT&T 开发的 UNIX 版本, 其 System V IPC (跨进程通信) 和 SystemV Init (系统进程启动和管理) 接口影响广泛. 但现在影响力已较弱, 如 SysV IPC 被 POSIX IPC 取代, SysV Init 被 systemd 取代.

[^6]: MSVC: MicroSoft Visual C/C++ 集成开发环境, 现已集成到 MiscroSoft Visual Studio 中. 相关编译器工具可以用 Developer Command Prompt for VS 直接访问.

[^1]: 注意: MinGW  (Minimalist GNU for Windows) 并不能完全移植 Unix-like 系统上的 C 程序到 Windows. MinGW 仍使用 Windows 系统 API, 而仅**部分**兼容 POSIX API, 其旨在提供类 GNU 的开发链条, 方便开箱即用, 但是不适合大型程序. 如果需要兼容完整 POSIX 环境, 即提供完整 POSIX API 到 Windows API 的翻译, 可以用 **Cygwin**.

[^2]: llvm-libc 正在开发中, 不稳定; llvm-lld 也不稳定. 所以现在在 windows 上用不了.

[^3]: MSVCrt (microsoft visual c runtime) 指 `msvcrt.dll`, 是 Windwos 系统对 libc 的实现. 在 Windows10 之后, 引入了 UCRT 的现代版本 libc 实现, 提供了对现代 C 标准更好的支持. 都不开源...

[^7]: 具体函数库内容详见 [C/StandardLib/ReadMe](../../langs/c/README.md) 语言标准库, libc++ 指 C++ 标准库. 语言委员会提供一套标准库函数标准, 但不规定底层究竟如何实现 (比如在 linux 和 windows 上, `printf()` 可能会调用不同的系统调用来达成功能), 所以不同编译器和操作系统都会有独立的实现.

[^8]: 运行库的命名办法: `libcpmtd.lib`, `p` 指 C++, `mt` 指 Multi-Thread 支持多线程, `d` 支持调试. 动态链接库命名前缀为 `msvc`, 还会加上版本号, 如 Visual C++ 2005 内部版本号为 8.0, 其多线程动态链接版的 DLL 命名为 `msvcrt80.dll`.

[^9]: 自 MSVC8.0 (Visual C++ 2005) 之后, MSVC 不再提供静态链接单线程版的运行库. 微软认为改进后的多线程运行库, 在单线程模式下运行速度已经接近单线程版本. 此后默认版本为 libcmt.lib
