汇编语言 (Assembly Language) 是机器码指令的助记符, 与机器语言直接对应. 随着*平台, 架构*演进而不断变化. 一条汇编指令由两部分组成: 助记符 (mnemonic), 操作数 (operands).

按指令集架构 (ISA, Instruction Set Architecture) 分类, 可以分为:
- CISC, 复杂指令集, 指令复杂长度不固定, 功能强大. 如 x86.
- RISC (Reduced IS Computer), 精简指令集, 指令集精简, 效率高功耗低. 如 ARM, MIPS, RISC-V, SPARC.
- DSL (Domain Specific Language): 特定领域的语言, 更好地暴露硬件能力.

按汇编语法分类, 不同平台和公司的开发者会设计不同的汇编语言语法. 

| 架构   | 汇编语言语法 | 平台      | 汇编器                      |
| ------ | ------------ | --------- | --------------------------- |
| x86    | AT&T         | Unix-like | GAS (GNU Assembler)               |
|        | Intel        | Windows   | MASM (Miscrosoft Assembler) |
| ARM    | ARM          |           |                             |

按处理器架构分类, 不同处理器支持功能不同, 汇编语言的指令集也不同. 总体而言, 同架构的处理器保持了指令后向兼容性.

| 位数 | 架构    | 汇编语法    | 实例处理器                  |
| ---- | ------- | ----------- | --------------------------- |
| 16b  | x86-16  | Intel       | Intel 8086, 80286           |
| 32b  | x86-32  | Intel, AT&T | Intel 80386, 80486, Pentium |
|      | MIPS    |             |                             |
|      | ARM     |             | ARM7, ARM9                  |
| 64b  | x86-64  | Intel, AT&T | AMD64, Intel Core...        |
|      | ARM64   | ARM         | ARM Coretx-A...             |
|      | RISC-V |             |                             |

Linux 较早有对 32 位 `ARMv7` 指令集的支持, 而 Windows 和 macOS 则从 `x86` 直接转向 64 位的 `ARMv8`. macOS 的架构称为 `ARM64`, 而 Windows 的架构称为 `AArch64`.

### Load-Store 

RISC 架构常见的内容模型, 指大部分指令都用于操作寄存器, 只通过 LOAD/STORE 指令和内存交互. 好处是指令集极大简化, 减少隐式访存行为, 便于流水线设计和编译优化.

## 参考

Intel 和 AT&T 语法区别. https://imada.sdu.dk/u/kslarsen/dm546/Material/IntelnATT.htm.

Intel® 64 and IA-32 Architectures Software Developer Manuals. https://www.intel.com/content/www/us/en/developer/articles/technical/intel-sdm.html

A friendly introduction to assembly for high-level programmers. https://shikaan.github.io/assembly/x86/guide/2024/09/16/x86-64-conditionals.html.