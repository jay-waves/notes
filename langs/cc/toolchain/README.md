
| Level | Purpose              | Tools                                           | 
| ----- | -------------------- | ----------------------------------------------- | 
| 0     | meta-build generator | CMake, gn, Meson, autoconf, VS Generator |    
| 1     | build engine         | make, ninja, MSBuild                            |           
| 2     | compiler frontend    | cl, gcc, clang                                  |          
| 3     | backend toolchain    | cc, ar, ld, lld, llvm-as                        |           

MetaBuild Generator: 用于描述一个跨平台工程，抹平环境差异（见 Triplets 一节），并提供依赖库和编译选项控制。

Build Engine：构建命令细节已经确定后，用于高效地执行构建图。高效地并行编译、增量编译、任务调度。

### Triplets 

Triplets 是指编译过程的”[环境、平台](../../../os/libc/libc.md)“，当前编译机器称为“宿主机平台”，编译产物的目标运行机器称为“目标平台”，两者当然可以不同，被称为交叉编译。现代编译系统用以下几个变量来区分：

Triplets 由以下部分构成
- CPU: x86 (i686, i386), amd64 (x86_64), arm, aarch64 (arm64), riscv64, wasm32
- Vendor: 可以省略. 如 `pc, unknown, apple`.
- OS Kernel: windows, linux, macOS (apple), freebsd
- OS ABI (SDK, C Runtime...): gnu, musl, android, mingw32, msvc, darwin, mingw
- Library Linkage: static, dynamic or mixed-used

例子：
* 安卓手机系统环境：`aarch64-unknown-linux-android` 
* Ubuntu 桌面环境`amd64-unknown-linux-gnu` 

## Build Maker & Generator

推荐使用 Ninja。VS Generator 太慢（可能和 NTFS 有关）。Make 本身包含了太多功能，语法也不太友好。

### [Ninja](https://ninja-build.org/)

google 出的轻量级构建系统，用于取代 make。ninja 将构建复杂性（解析环境和变量，处理条件和逻辑）交给上层 CMake / GN 等工具处理，只专注执行构建图，因此轻量而快速，并发调度好。

## Package Manager

### Meson

Meson, 2012. 

- 脚本语言类似 Python.
- 配置文件为 `meson.build`
- 构建系统生成器仅为 Ninja, 不支持 VS, Make
- 自带依赖管理工具和数据库 WrapDB

### [VCPKG](https://github.com/microsoft/vcpkg)

vcpkg 所有的 traiplets 定义在 vcpkg/triplets/toolchains 目录下, 以 CMake 文件定义. 其实都可以改. vcpkg 对于 llvm，尤其是 libc++ 支持比较差，我经常遇到编译问题。

在 Windows MSVC 环境下，要注意 `VCPKG_CRT_LINKAGE` 这个配置，使用动态链接 CRT，需要指定后缀 `-md`，如 `x86-windows-static-md`。

### CMake FetchContent 

直接用这个也挺好。
