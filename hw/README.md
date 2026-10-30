### 硬件设计思想

#### 面向摩尔定律设计

#### 使用抽象简化设计

较低层向较高层隐藏细节, 提供接口; 从而降低整体设计的复杂度

#### 加速经常性时间

优化罕见情况能提高程序鲁棒性, 但并不利于提高程序性能. 对*经常发生的多数事件*进行优化, 能更好地提高性能

#### 通过并行提高性能

#### 通过流水线提高性能

**流水线 pipelining**, CPU处理当前任务时, 内存已经为CPU准备好了接下来要干的活😿

#### 通过预测提高性能

当预测错误代价不高, 且预测能显著提高性能(时间)时, 采用预测的方法. 例如网页中的预加载机制, 牺牲流量换取速度
> 一般来说, **执行时间**是评价性能的最根本标准

#### 存储层次

容量小(价格贵), 速度快的存储器处于顶层; 而速度慢, 容量大的存储器处于底层相互配合

#### 通过冗余提高可靠性 

在系统失效时, 能够提供替代解决方案

## Glossary

#### MIPS

Million Instructions Per Second, 用于衡量 CPU 每秒执行指令的速度.

#### MSB

most significant bit/byte, 最大影响位.

#### Little-endian

小端字节序, 见 [endianness](endianness.md)

#### Big-endian

大端字节序. 见 [endianness](endianness.md)

#### CTI 

Control Transfer Instructions (CTI) 指汇编语言中跳转类型指令, 打破指令顺序执行.

#### Northbright

北桥, 计算机硬件架构组成部分. 见 [计算机架构](computer/计算机架构.md)

#### Southbridge

南桥. 见 [计算机架构](computer/计算机架构.md).

#### ISA

Instruction Set Architecture (ISA) 定义了处理器的 指令集, 寄存器, 内存结构. 包括指令集如何被执行, 如何影响内存和寄存器.