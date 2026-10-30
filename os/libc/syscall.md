通过触发中断来作为系统调用入口, Linux 使用 `0x80` 作为系统调用入口, Windows 采用
`0x2e` 号中断作为系统调用入口. 

Windows 平台主要使用在系统调用上再次封装的 Windows API, 而不是直接调用系统调用. 
就像, 类 unix 平台都会或实现或封装 POSIX API, 来保证代码的跨平台兼容性.

系统调用接口原始, 而且跨平台兼容性查. 因此在其上设计了语言运行库, 加强可用性和跨
平台性. 当然, 运行库在不同编译器和平台间的特性也不一定兼容.

## Linux 系统调用

### i386_linux.2.4.x

```c
/* 
 * i386 _syscall0() 展开后会形成一个和传入 name 同名的函数
 * 如标准库 fork() 定义为 _syscall0(pid_t, fork);
 */
#define _syscall0(type, name)        \
type name(void)                      \
{                                    \
    long __res;                      \
    __asm__ volatile ("int $0x80"    \
        : "=a" (__res)               \
        : "0"  (__NR_##name));       \
    __syscall_return(type, __res);   \
} 

/* 其中 __asm__ 为 gcc 关键字, 用来嵌入汇编代码. volatile 告知 gcc 不对代码进行优化
 * "int $0x80" 是汇编内容, 即调用 0x80号汇编
 * "=a" (__res) 表示用 eax 寄存器输出返回数据并存储在 __res 中
 * __NR_##name 为输入, "0" 指示由编译器选择和输出相同的寄存器 (即 eax) 来传递参数
 等价于声明了: */

pid_t fork(void)
{
    long __res;
    $eax = __NR_fork
    int $0x80
    __re = $eax
    __syscall_return(pid_t, __res);
}

// in linux/include/asm-x86/unistd_32.h 定义了 linux-x86 的系统调用号
#define __NR_restart_syscall  0
#define __NR_exit             1
#define __NR_fork             2
#define __NR_read             3
#define __NR_write            4

#define __syscall_return(type, res)                       \
do {                                                      \
    if ((unsigned long)(res) >= (unsigned long)(-125)) {  \
        errno = -(res);                                   \
        res = -1;                                         \
    }                                                     \
    return (type) (res);                                  \
} while (0)                                               \


```

上述 `fork()` 函数最终形成的汇编如下:
```asm
fork:
    mov eax, 2
    int 0x80
    cmp eax, 0xffffff83
    jb syscall_noerror
    neg eax
    mov errno, eax
    mov eax, 0xfffffff
syscall_noerror:
    ret
```

<img src="../../attach/img/os/linux-syscall.avif" alt="" width="500">

对于有参数的系统调用, 生成宏如下. 依次用 `ebx, ecx, edx, esi, edi, ebp` 存储传入系统调用的参数. 

```c
#define _syscall1(type, name, type1, arg1)                \
type name(type1, arg1)                                    \
{                                                         \
    long __res;                                           \
    __asm__ volatile ("int $0x80"                         \
        : "=a" (__res)                                    \
        : "0"  (__NR_##name), "b" ((long)(arg1)));        \
    __syscall_return(type, __res);                        \    
}
/*
 * 对应的汇编如下, "b" 代表 ebx 寄存器
 */
push ebx
eax = __NR_##name
ebx = arg1
int 0x80
_res = eax
pop ebx
```


i386 架构的中断向量表在 linux 源码的 `linux/arch/i386/kernel/traps.c` 中:
```c
void __init trap_init(void) 
{
	...
	set_trap_gate(0, &divide_error);
	set_intr_gate(1, &debug);
	set_intr_gate(2, &nmi);
	set_system_intr_gate(3, &int3);
	set_system_system_gate(4, &overflow);
	set_system_gate(5, &bounds);
	set_trap_gate(6, &invalid_op);
	set_trap_gate(7, &device_not_available);
	set_task_gate(8, GDT_ENTRY_DOUBLEFAULT_TSS);
	...
	set_intr_gate(14, &page_fault);
	...
	/* in linux/include/asm-i386/mach-default/irq_vectors.h:
	 * #define SYSCALL_VECTOR 0x80
	 */
	set_system_gate(SYSCALL_VECTOR, &system_call);
	}
```

`system_call` 也就是系统调用中断程序, 定义如下:
```asm
ENTRY(system_call)
	....
	SAVE_ALL
	...
	cmpl $(nr_syscalls), %eax
	jae syscall_badsys

syscall_call:
	call *sys_call_table(0, %eax, 4)
	..
	RESTORE_REGS
	..
	iret

.data
ENTRY(sys_call_table)
	.long sys_restart_syscall
	.long sys_exit
	.long sys_fork
	.long sys_read
	.long sys_write
```

执行系统中断时, 栈由用户栈切换为内核栈 (一个进程一个内核栈):
1. 在内核栈压入寄存器 SS, ESP, EFLAGS, CS, EIP.
2. 将 ESP, SS 的值设置为内核栈的对应值.

上述完整的 linux `fork()` 完整调用路径如下:
1. `fork()`
2. `%eax=2, int 0x80`
3. `call *sys_call_table(0, %eax, 4)`
4. `sys_fork()`

### pentium4_linux2.5.x




### 其他处理器架构

amd64 (x86_64) 架构中的系统调用原理类似. 所使用的寄存器和指令有所演化, 传参寄存器
变得更多, 设计了系统调用指令 `syscall`, 优化了用户模式和内核模式的切换过程.

| 架构 | 系统调用号寄存器 | 参数传递寄存器 | 系统调用触发指令 |
| --- | ------- | ------ | ---- |
| x86 | `eax`   | `ebx, ecx, edx, esi, edi` | `int 0x80` |
| amd64 | `rax` | `rdi, rsi, rdx, r10, r8, r9` | `syscall` |
| arm | `r7` | `r0-r6` | `svc` (supervisor call) |


AMD64 上 Linux 系统调用号被重新分配, 此时 `fork()` 调用汇编如下:

```asm
mov rax, 57
syscall
```

ARM:

```assembly
mov r7, #1         ; 系统调用号1 (sys_exit)
mov r0, #0         ; 参数：退出状态码0
svc #0             ; 触发系统调用
```

