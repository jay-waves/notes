---
revised: 25-01-24 
---

程序 = 数据结构 + 算法 + 胶水逻辑

## 编程范式

|          | C                       | C++              | Go         | Java | Python | JavaScript | Rust              | Haskell |
| -------- | ----------------------- | ---------------- | ---------- | ---- | ------ | ---------- | ----------------- | ------- |
| 类型声明 | 静态                    | 静态             | 静态       | 静态 | 动态   | 动态       | 静态              |         |
| 类型转换 | 弱类型                  |                  |            |      |        |            |                   |         |
| 算法泛型 | 宏, `void*`             | 类多态, 函数重载 |            |      |        |            |                   |         |
| 类型泛型 | `void*`                 | 模板,            |            |      |        |            |                   |         |
| 范式     | 过程式                  |                  | 过程式     |      |        |            |                   | 函数式  |
| 面向对象 |                         | 类               | 结构体方法 | 类   | 类     | 基于原型   |                   |         |
| 资源管理 | 手动管理堆 + 局部作用域 | RAII             |            |      |        |            | 生命周期 + 所有权 |         |
| 编译方式 | AOT                     | AOT              | AOT        | JVM JIT  | Interpreter, PyPy JIT | V8 JIT        | AOT               |         |

图灵完备的编程语言中, 编程范式大概分为:
- 命令式 (Impreative Programming)
	- 过程式 (Procedural), C 
	- 命令式, Matlab
- 声明式 (Declarative Programming)
	- 函数式, Hashkell 
	- 逻辑式, Prolog
- 面向对象, Java 

<img src="../attach/img/langs/programming-paradigms.avif" alt="" width="800">

### 面向对象

原型编程: 不要求子对象有相似的内存结构, 方法和数据皆可以修改 (slots)

### 编译方式

| 特征       | JIT                            | Interpreter       | AOT                        |
| ---------- | ------------------------------ | ----------------- | -------------------------- |
| 编译时期   | 运行时                         | 运行时            | 开发期                     |
| 类型检查   | 运行时                         | 运行时            | 编译时                     |
| 启动时间   | 较慢 (编译热点代码)            | 快                | 快                         |
| 执行性能   | 可以高 (依赖于运行时优化)      | 一般              | 高 (依赖于编译时优化)       |
| 跨平台性   | 高                             | 高                | 低 (需要为每个平台单独编译) |
| 内存使用   | 较高 (存储编译后机器码和字节码)| 低 (直接解释执行) | 中 (编译后可能膨胀)        |

#### AOT

Ahead-of-time 指程序在执行前就编译为可执行文件. (如 C, C++. 也叫静态编译)

AOT 对编译时间不是很敏感, 可以进行复杂高级的优化算法, 得到效率或 codesize 更优的代码. 
但 AOT 无法进行 PGO (profile-guided optimization) 优化

#### JIT

Just-In-Time Compilation (JIT) 在程序运行时，将程序的某种中间代码翻译为目标平台的 native machien code (实际机器指令)，

JIT 能够接触到运行时信息，因此更激进地做运行时优化和推测优化。但是启动时需要先解释中间代码，然后翻译为机器指令，
导致冷启动时间长，内存消耗大。

#### Interpreter 

Interpreter 不会将中间代码翻译为机器指令再执行，而是直接解释执行（按代码行顺序执行）。

## 编程语言

### Python

Python 的默认解释器为 CPython，是将 `*.py` 临时编译为字节码 `*.pyc` 执行的虚拟机。PyPy 则是 JIT，执行速度略快。

Python 的性能优化并不激进，因此更轻量（更慢）。
* 没有 JIT
* 类型系统也更松散（不严格类型检查）
* 仅使用简单计数 GC，
* 不支持实际的多线程并行（仅支持并发），存在 GIL 全局锁

### Java JVM 

Java 最初是为"跨平台"目的设计的 ("Write Once, Run Everywhere"), 也被称为 "二次编译语言", 
其"字节码 `.class bytecode`"实际就是一种精简指令集. 

Java 源码先由 Javac 编译为 `.class`，然后由 JVM 进行解释和编译。

### C# .Net

微软为了凸显自身比虚拟机型语言更**轻量**, 将 C#.Net 环境称为"运行时".


## Reference

https://en.wikipedia.org/wiki/Software_design_pattern 

编程范式游记. 左耳朵耗子. 

重构. Martin Fowler. 2020
