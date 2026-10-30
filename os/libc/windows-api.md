
```c
#include <windows.h>    // 核心系统调用
#include <process.h>    // 进程管理
#include <io.h>         // 低级文件 I/O
#include <direct.h>     // 目录操作
#include <winsock2.h>   // 网络编程
#include <synchapi.h>   // 线程同步
#include <errhandlingapi.h> // 错误处理
```

## Windows API

Windows 内核*系统调用 (Windows 称之为 系统服务, System Service)* 并不是公开的. Windows 在其上建立了公开的 API 层. Windows API 之上, 实现了 CRT 和 MFC (C++) 等库. Windows API 以 DLL 形式暴露该开发者, Windows 将一整套文件 / 导出库 / 工具 一起打包分发, 称之为 Windows SDK (Software Development Kit). Windows SDK 通常集成在 Visual Studio 工具链中, 安装 VS 后, 通过导入 `Windows.h` 使用核心部分.

|             | Linux                          | Windows                                |
| ----------- | ------------------------------ | -------------------------------------- |
| Application | `fwrite()` in `./program`                    |`fwrite()` in `program.exe`                          |
| CRT         | `write()` in `libc.so, libc.a` | `write()` in `libcmt.lib, msvcr90.dll` |
| API         |                                | `NtWriteFile()` in `Kernel32.dll`      |
| Int         | `interrupt 0x80` in `libc.a`   | `interrupt 0x2e` in `NTDLL.dll`        |
| Kernel      | `sys_write()` in `/vlinuxz`    | `IoWriteFile()` in `NtosKrnl.exe`        |

Windows 最底层 Windows API 是 `NTDLL.dll`, 它直接和 Windows NT 系统内核调用交互, 其上是 `kernel32.dll, gdi32.dll, user32.dll...`.  

<img src="../../attach/img/os/win-arch.avif" alt="" width="800">

类 Unix 系统, 鼓励用户直接和内核交互, [glibc](libc.md) 也仅薄层封装. 而 Windows 为了提供更强的前向兼容性, 多提供了一层稳定的抽象接口 Windows API, 屏蔽了硬件和内核的变化. 在 Windows 2000 之前, Windows 实际在同时维护 Windows 9x 和 Windows NT 两个不同的内核.

Windows NT 设计了*子系统 (Environment Subsystems)*, 将其他平台的系统调用翻译为 Windows API, 从而实现对其他平台的源码级兼容. 注意, 不是二进制兼容, 而是可以将其他平台的源码中的系统调用 (如 `fork()`) 翻译为 Windows API 实现. Win64 上常见的子系统包括: POSIX 系统, Win32 系统, WSL1 (Windows Linux Subsystem), WSA (Windows fo Android). 

子系统的设计在本质上是为了商业竞争. Windows 成为主流后, 就逐渐放弃了 POSIX 和 OS/2 等子系统的兼容, Win11 又放弃了维护 WSA. WSL2 则迁移到了虚拟化技术 (Hyper-V), Hyper-V 不依赖于子系统, 它是一型裸金属虚拟机, 工作在硬件和内核之间. WSL2 运行完整 Linux 内核, WSL1 只是翻译层, WSL2 必须通过网络协议 9P 实现和 Windows 中文件系统的交互, 而 WSL1 可通过 Windows API 直接访问 Windows 中文件. 

MinGW 是将 GCC/GNU 编译工具链移植到了 Windows, 而 POSIX 系统调用则是通过 Cygwin / MYSYS 等项目提供.