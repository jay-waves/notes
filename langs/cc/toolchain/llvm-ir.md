## Hello World

```llvm
; main.ll
define i32 @main() {
	return i32 0
}
```

`clang main.ll -o main`

### LLVM IR Layout

- Module
	- Target Information
	- Global Sysmbols
		- **Global Variable**
		- **Funciton Declaration**
		- **Funciton Definition**
	- Other Stuff
- Function 
	- **Argument**
	- Entry Basic Block 
	- **Basic Block**
- Basic Block 
	- Label 
	- **Phi Instruciton**
	- **Instruction**
	- Terminator Instruction

### 编译目标平台信息

<img src="../../../attach/img/langs/target-triples.avif" alt="" width="500">

目标的数据布局. 具体而言:

- `e`: 小端序
- `m:e`: 符号表中使用 ELF 格式的命名修饰
- `p270:32:32-p271:32:32-p272:64:64`: 与地址空间有关
- `i64:64`: 将 `i64` 类型的变量采用 64 位的 ABI 对齐
- `f80:128`: 将 `long double` 类型的变量采用 128 位的 ABI 对齐
- `n8:16:32:64`: 目标 CPU 的原生整型包含 8位、16位、32位 和 64位
- `S128`: 栈以 128位 自然对齐

`target triple`: [目标平台](../../../os/libc/libc.md), 如 `aarc64-apple-darwin`, `x86_64-pc-windows-msvc`


> 参考 [LLVM/LangRef/DataLayout](https://llvm.org/docs/LangRef.html#data-layout)

## 符号

以 C 语言为例, 其主要符号类型有:
```c
int a;                 // 定义在当前文件的全局变量, 别的文件也可以使用.
extern int b;         // 定义在其他文件的全局变量, 当前文件需要使用该符号.
static int c;          // 定义在当前文件的全局变量, 别的文件不可使用该符号.
void d(void);          // 定义在别的文件的函数, 当前文件需要使用该符号.
void e(void) {}        // 定义在当前文件中的函数, 别的文件可以使用该符号.
static void f(void) {} // 定义在当前文件的函数, 别的文件不可以使用该符号.
```

翻译为对应的 IR: (IR 中全局变量和函数以 `@` 开头). 

```llvm
@a = dso_local global i32 0, align 4
; dso_local 明确告知 linker 不许抢占
@b = external global i32, align 4
@c = internal global i32 0, align 4

declare void @d()

define dso_local void @e() {
	ret void
}

define internal void @f() {
	ret void
}
```

## 寄存器与栈

LLVM IR 是 SSA (Static Single Assignment) 形式, 这使得数据使用起来像"寄存器". 在编译期后端的"寄存器分配过程"中, LLVM 才决定哪些数据放在寄存器, 哪些数据放在栈中. 

在需要**直接操作地址或需要可变变量**时, 也可如下声明内存变量, 此时返回值是指针. 内存变量 / 全局变量 / 其他指针类型 都需要通过 `load/store` 来访问. 

```llvm
@global_var = global i32 0
%local_var = alloca i32

store i32 1, ptr @global_var

%1 = load i32, ptr @global_var
%2 = add i32 1, %1
```

### SSA

**SSA 中每个寄存器变量在其声明周期内只被赋值一次.** SSA 有利于编译器分析.

```llvm
; 这是非法 IR 程序
%1 = add i32 1, 2
%1 = add i32 3, 4
```

当值可能来在不同指令路径时, 需要使用 `phi` 指令显式合并: 比如这里的 `y` 可能来自 `y1, y2`.

```llvm
define void @foo(i32 %x){
entry:
	%1 = icmp sgt i32 %x, 0
	br i1 %1, label %btrue, label %bfalse

btrue:
	%y1 = add i32 0, 1
	br label %end

bfalse:
	%y2 = add i32 0, 2
	br label %end

end:
	%y = phi i32 [ %y1, %btrue ], [ %y2, %bfalse ]
	ret void
}
```

## 类型系统

官方文档中指出 LLVM 类型有:
- Void Type
- Function Type
- First Class Types
	- Single Value Types
		- Integer Type
		- Floating-Point Types
		- X86_mmx Type
		- Pointer Type
		- Vector Type
	- Label Type
	- Token Type
	- Metadata Type
	- Aggregate Types
		- Array Type
		- Structure Type
		- Opaque Structure Types

IR 的所有变量皆是强类型的, 并且没有隐式类型转换. 

### 数据类型

- 空类型 `void`
- 整型 `i1`, `i8`, `i16`, `i32`, `i64` 等. `i1` 用于标识 true/false.
- 浮点型 `float`, `double`

LLVM IR 默认数字有符号, **以补码形式**存储, 但是提供了针对无符号数的操作符 (如 `udiv`, `add`). 是否要将一个变量视为无符号数, 要看具体参与的指令.

LLVM IR 提供了明确的**类型转换指令**:
1. 长整型变为短整型, 直接裁切掉高位: `trunc i32 257 to i8`
2. 短整型变为长整型, 高位零扩展: `zext i8 -1 to i32`
3. 短整型变为长整型, 符号扩展: `sext i8 -1 to i32`
4. 浮点数和整型间转换, 有: `fptoui .. to`, `uitofp .. to` `sitofp .. to`

### 指针类型

类型 `ptr` 类似 C 语言的 `void *`, 是不包含类型信息的. LLVM 提供指针类型和整型相互转换的指令, 方便灵活操作指针.

```llvm
%x = alloca i32
%addr_x = ptrtoint ptr %x to i64
%also_x = inttoptr i64 %addr_x to ptr
```

> LLVM 11 之前, 指针是有类型的. 新版本, 指针变得"不透明".

### 聚合类型

LLVM IR 也有类似 C 语言的结构体和数组.

```llvm
; 数组
@global_arr = global [4 x i32] [i32 0, i32 1, i32 2, i32 3]

; 字符串初始化, 转义字符 \00 (固定字长为两位)
@global_str = global [12 x i8] c"Hello world\00"
```

```llvm
; 结构体
@global_struc = global {i32, i8} {i32 1, i8 0}
```


LLVM IR 要求: 访问聚合类型时, 必须指明基地址偏移 (用 `getelementptr` 计算偏移). 

```llvm
; MyT { x, y }  <--- t_ptr
%MyT type {i32, i32}

%my_y_ptr = getelementptr %MyT, ptr %t_ptr, i64 2, i32 1
%my_y_val = load i32, ptr %my_y_ptr
```

级联访问:

```llvm
%MyT = type { i32, [5 x i32] }
%t_ptr = alloca [ 4 x %MyT ]

; 取 val[2].y[3]
%1 = getelementptr %MyT, ptr %t_ptr, i64 2, i32 1, i64 3

; llvm12 后, 引入弱类型指针
%arr_ptr = alloca [3 x i32 ]
%2 = getelementptr [3 x i32], [3 x i32]* %arr_ptr, i64 0, i64 0
```

寄存器中的聚合类型, 使用 `extractvalue, insertvalue` 访问:

```llvm
%1 = load %MyT, ptr %t_ptr 

%2 = extractvalue %MyT %1, 1
%3 = insertvalue %MyT %1, i32 233, 1
```

## 函数

函数和全局变量都会被记录进符号表.

```llvm
define dso_local void @foo() #0 {
  ret void
}

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

; #0 称为属性组, 可以代指定义的一长串属性. 属性直接写在函数后也是可行的, 比如:
define dso_local void @foo() noinline nounwind {
	ret void
}
```

```c
// in c
void foo() {}
```

需要使用其他模块的函数时, 需要在本模块先使用 `declare` 声明该函数:

```llvm
declare i32 @printf(i8*, ...) #1
```

LLVM IR 调用函数的方式和高级语言类似:

```llvm
define void @bar() {
	%1 = call i32 @foo(i32 1)
}
```

### 内置函数 (Intrinsics)

LLVM IR 提供了一些内置的基础函数实现, 详见 `include/llvm/IR/Intrinsics*.td`.

内存操作:
- `llvm.memcpy.`
- `llvm.memmove`
- `llvm.memset`
- `llvm.lifetime.start/end` : 标记内存对象声明周期
- `llvm.invariant.start/end` : 标记内存区域只读
- `llvm.prefetch`
- `llvm.atomic.*`

位操作:
- `llvm.ctpop`
- `llvm.ctlz`
- `llvm.cttz`
- `llvm.fshl`

## 控制流

### icmp

```llvm
%result = icmp uge i32 %a, %b
```

`icmp` 接受的第一个参数 `uge` 称为**比较策略**, 有很多种:
- `eq`, `ne` 相等或不相等
- 无符号比较: `ugt` 大于, `uge` 大于等于, `ult` 小于, `ule` 小于等于
- 有符号比较: `sgt`, `sge`, `slt`, `sle`

### BasicBlock

LLVM 的函数由一系列基本块 (Basic Block) 组成, 形成一个 CFG (Control Flow Graph). 每个基本块由一个 label 标识, 以终止指令结束 (通常是跳转指令).

### for 语句

```c
for (int i=0; i<4; i++){
	// for body 
}
// next
```

`i` 是可变变量, 必须声明在内存中. Llvm 不推荐这种方式, 因为内存比寄存器慢.

```llvm
entry:
	%i = alloca i32                   ; int i
	store i32 0, ptr %i               ; i=0
	br label %check
check:
	%i_val = load i32, ptr %i
	%result = icmp slt i32 %i_val, 4              ; test if i <4
	br i1 %result, label %for_body, label %next   ; 条件跳转
for_body:
	%1 = add i32 %i_val, 1            ; %1 <- i+1, 匿名寄存器 %1.
	store i32 %1, ptr %i              ; i <- %1, 从寄存器取数
	br label %check                   ; 无条件跳转
next:
	ret i32 0
```

#### phi 

当多个控制流路径 (分支, 循环) 汇合到一个点时, 由于 SSA 策略, 需要一种机制来选择不同路径上的变量值. `phi` 指令可以根据控制流来向, 选择对应的去向.

用 phi 方式写上述 for 循环:

```llvm
entry:
	br label %check 
check:
	%i_val = phi i32 [0, %entry], [%i_next, %for_body]
	%result = icmp slt i32 %i_val, 4
	br i1 %result, label %for_body, label %next 

for_body:
	%i_next = add i32 %i_val, 1
	br label %check 

next:
	ret i32 0
```

### switch 语句

```c
// in c
int x;
switch (x) {
	case 0:
		// case a
		break;
	case 1:
		// case b
		break;
	default:
		// case c
		break;
}
// next
```

```llvm
switch i32 %x, label %C [
	i32 0, label %A
	i32 1, label %B
]
A: 
	; case a
	br label %end
B:
	; case b
	br label %end
C:
	; default case, must provided
	br label %end
end:
	; next
```

### select 语句

`select` 语句和 `phi` 类似, 但是其仅适用于**二选一**的情况.

```c
// in c
void foo(int x){
	int y;
	if (x > 0){
		y = 1;
	} else {
		y = 2;
	}
}
```

使用 `select` 类似 python/rust 中的单行表达式: `let y = if x>0 {1} else {2}`

```llvm
; use select
define void @foo(i32 %x){
	%1 = icmp sgt i32 %x, 0
	%y = select i1 %1, i32 1, i32 2
	ret void
}
```
