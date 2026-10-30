当程序规模较大时, 将每个源码模块 `.c` 单独编译为目标文件 `.obj`, 然后再按顺序组装目标文件和库, 这个组装过程就是**链接** (Linking). 链接的主要过程包括: 地址和空间分配 (Address and Storage Allocation), 符号决议 (Symbol Resolution, 也叫符号绑定, Symbol Binding, Address Binding) 和重定位 (Relocation).

### 地址和空间分配

```bash
# 将 a.o 和 b.o 链接起来, 用 main 作为程序入口 (默认为 _start)
ld a.o b.o -e main -o ab
```

扫描输入目标文件, 获取各个段信息 (长度, 属性和位置), 并将所有目标文件的符号表合并为全局符号表. 接着, **将各个目标文件的类似段合并**, 并分配虚拟内存空间地址 (VMA). 

在分配地址空间 (链接) 之前, 各个函数的起始虚拟地址都假设为 `0x0000000`, `.text` 段的相关地址引用也用 `0x0` 或其他临时地址代替.

<img src="../../../attach/img/langs/address-space-allocation.avif" alt="地址和空间分配过程" width="600">

### 重定位

链接器根据**重定位表 (Relocation Table)** 对指令中地址进行修正, 重定位表在 [ELF 文件](unix-elf.md)中被称为 `.rela.text` 段. 目标文件中所有引用外部符号地址的指令, 都需要被重定位, 每个需要重定位的地方叫**重定位入口 (Relocation Entry)**. 

重定位过程伴随着**符号解析**, 每个重定位入口都是对一个符号的引用, 链接器会去全局符号表查找对应符号所分配的地址, 然后进行重定向. 不同处理器有不同寻址方式, 数量繁多[^1].

[^1]: 远址寻址, 近址寻址, 绝对寻址, 相对寻址, 不同位数寻址 (8b, 16b, 32b, 64b).

```bash
objdump -r test_elf.o

test_elf.o:     file format elf64-x86-64

RELOCATION RECORDS FOR [.text]:
OFFSET           TYPE              VALUE
0000000000000024 R_X86_64_PLT32    printf-0x0000000000000004
0000000000000040 R_X86_64_PC32     .data
0000000000000046 R_X86_64_PC32     .bss
0000000000000059 R_X86_64_PLT32    func1-0x0000000000000004


RELOCATION RECORDS FOR [.eh_frame]:
OFFSET           TYPE              VALUE
0000000000000020 R_X86_64_PC32     .text
```

`RELOCATION RECORDS FOR [.text]` 指代码段 `.text` 的重定位表, 偏移 (offset) 表示相对于 `.text` 的偏移. 

## 静态库

**静态库是一组目标文件的集合**. 如 glibc 由 `date.o, time.o, scanf.o, malloc.o` 等等组成, 由 `ar` 打包压缩. 

```sh
> ar -t libc.a
init-first.o
libc-start.o
sysdep.o
version.o
check_fds.o
...
```

Linux 常用的 C 语言静态库为 `/usr/lib/libc.a`; Windows 上, Visual C++ 中的运行库如下 (VC2008), 打包工具为 `lib.exe`, 用来创建和获取 `.lib` 文件中的信息.

| C 运行库       | DLL          | 描述             |
| ------------- | ------------ | ---------------- |
| `libcmt.lib`  |              | 多线程静态库     |
| `msvcrt.lib`  | msvcr90.dll  | 多线程动态库     |
| `libcmtd.lib` |              | 多线程静态调试库 |
| `msvcrtd.lib` | msvcr90d.dll | 多线程动态调试库                 |

链接器在链接过程中, 先将 `.a` 静态库文件解压为无数个 `.o` 目标文件, 然后搜索需要用到的符号. 为了避免链接过多不必要的函数, 标准库 `.a` 中的目标文件是高度原子化的, 基本一个函数包装为一个目标文件, 如 `printf()` 包装为 `printf.o`.

### ld脚本

`ld` 根据链接脚本控制链接行为, 默认的脚本存放在 `/usr/lib/ldscripts/` 下, 针对不同平台和不同输出文件格式有不同脚本. 当然, 用命令行参数也能控制大部分行为.

查看默认脚本:

```sh
ld -verbose
```

指定脚本:

```sh
ld -T link.lds
```

脚本文件简单语法如下:
```lds
/* in link.lds */
ENTRY(nomain)
STARTUP(file1.o)
SEARCH_DIR(path...) /* search lib in ..., same as -L... */

INPUT(file,file,...)

SECTIONS
{
	. = 0x08048000 + SIZEOF_HEADERS;
	my_sec : { *(.data) file1.o(.text) file2.o(.rodata, .text) }
	/DISCARD/ : { *(.comment) }
}
```
