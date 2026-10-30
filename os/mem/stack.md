## 栈

<img src="../../attach/img/os/os-memory-stack-frame.avif" alt="" width="400">

栈用于保存函数调用信息, 也被称为**堆栈帧 (Stack Frame)**. 内容包括:
- 函数的返回地址和参数.
- 临时变量, 即函数内非静态局部变量和其他编译器自动生成的临时变量.
- 函数调用前后的上下文.

栈使用的 CPU 寄存器有:
- `EBP` Extended Base Pointer, 堆栈帧指针. 初始指向上一个函数堆栈帧基址.
- `ESP` Extended Stack Pointer, 堆栈顶指针. 初始指向函数堆栈帧底部.
- `EIP` Extended Instruction Pointer, 指向下次执行的指令

### 压栈过程

函数 `func(a, b, c)` 被调用时, 

1. 压入参数: 从右开始压入, 使得a离ebp(第一个可知位置)最近.

```assembly
push c
push b
push a
```

2. 压入返回地址: call会自动将下条指令的地址作为返回地址(RA)压入.

```assembly
call func
```

利用 `call` 指令压入返回地址 (Return Address) 获取 PC 的黑魔法:

```assembly
call <get_pc_thunk>

<get_pc_thunk>:
	mov (%esp), %ecx 
	ret
```

`%esp` 指向栈顶, 正好是返回地址, 将其移动到 `%ecx`

3. 初始化栈 (此时已进入被调用函数的汇编)

```assembly
push ebp
mov ebp esp
```

4. 初始化局部变量空间, 编译时其所用局部变量空间就已被固定. (静态空间)

```assembly
sub $0x32 %esp
```

栈从高地址向下发展:

```
...high
[   parameter c       ]
[   parameter b       ]
[   parameter a       ]
[   return address    ]  <-- EBP
[   saved EBP value   ]
[   registers...?
[   local variables   ]  <-- ESP
...low  <-- ESP
```


隐式更新 %esp 的指令:

```assembly
push:
    sub $4, %esp 
    mov %eax, (%esp)

pop:
    mov (%esp), %ebx
    add $4, %esp

call:
    push return_addr
    jmp func_label

leave:
	mov esp, ebp 
	pop ebp

ret:
    pop %eip
```


### 清栈

| 架构   | 返回指令                 | 上下文恢复               | 清栈        |
| ------ | ------------------------ | ------------------------ | ----------- |
| x86    | `ret`                    | |  |
| arm    | `pop {..., pc}`, `bx lr` |          | |
| RISC-V | `jalr x0, ra, 0`         |         | |
| SPARC  | `ret`                    |  |             |
