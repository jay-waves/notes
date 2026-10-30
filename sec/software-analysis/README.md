## 软件安全分类

- 控制流安全: 控制流完整性 (Control FLow Integrity, CFI)-->CFG
- 信息流安全: 机密性, 完整性
- 内存安全: 内存泄漏(生命周期管理), 堆栈溢出保护, 空指针解引用(UAF), 双重释放
- 数据类型安全: 类型检查, 类型转换检查 (如不同时间格式), 
- 系统资源安全: 权限隔离, 资源控制, Profiling, Sandbox

## 软件测试

- 功能测试:
	- 单元测试 (unit test): 单个模块测试
	- 集成/系统测试 (integration teat): 测试模块间的接口和交互
	- 验收测试: 由客户确认软件是否满足需求. 分为 Alpha 测试 (内部) 和 Beta 测试 (外部).
- 非功能测试:
	- 性能测试: 压力测试, 负载测试, 速度测试
	- 安全性测试: 如渗透测试, 模糊测试
	- 兼容性测试
- 维护性测试:
	- 回归测试 (Regression Test): 新版本的修改是否引入缺陷. (Beizer, 1990)
	- ...

### 动态检测 vs 静态检测

- Coverage
	- generalize to addtional traces?
- Soundness
	- every actual data race it reported
- Completeness
	- all reported warnings are actually races
- Overhead
	- run-time slowdown
	- memory footprint
- Programmer Overhead

>  Dijkstra, "Program testing can be used to show the presence of bugs, but never to show their absence."

### 模糊测试

模糊测试发展路径:[^3]

<img src="../../attach/img/sec/fuzzing-evolution.avif" alt="" width="1000">

### 动态插桩方式

编译时插桩: 对源代码或代码中间体 (汇编, IR) 修改. 效率高, 更灵活; 但侵入式更强, 需要改动编译流程.
- [Sanitizers 系列](tools/sanitizers.md)

运行时插桩技术 (DBI, Dynamic Binary Instruction): 在程序执行期间, 通过动态二进制翻译或动态重写指令, 拦截指令. 无需源码, 但性能损耗大.
- Valgrind (Memcheck). 动态翻译为 VEX IR.
- Dyninst
- DynamoRIO
- Intel Pin
- Dr.Memory. 基于 DynamoRIO.


## 检测结果分析

|                   | Error exists   | No Error Exists |
| ----------------- | -------------- | --------------- |
| Error Reported    | True Positive  | False Positive  |
| No Error Reported | False Negative | True Negative                |

- Soundness: report all defects (no false negatives)
- Completeness: every reported defect is an actual defect (no flase positives)

## 内存安全策略

研究表明[^1], 现存漏洞的数量随着代码生命周期指数下降. 假设平均漏洞生命周期为 $\lambda$, 于是漏洞的时间密度满足[指数分布](https://notes.jay-waves.cn/math/prob/distributions/exponential/): $$\mathrm{density}(x)=\frac{1}{\lambda}e^{-\frac{1}{\lambda} x}$$

<img src="../../attach/img/sec/vulnerability-lifecycle.avif" alt="" width="400">

谷歌[^2]认为处理内存安全的策略共有四代:
1. reactive patching. 漏洞和风险曝光后再解决, 软件需要经常打安全补丁.
2. proactive mitigating. 针对漏洞类型, 设计相应的防御技术, 如: stack canaries, control-flow integrity. 由于新型漏洞利用技术不断发展, 软件需要不断加码防御措施, 和攻击者搞军备竞赛, 导致资源消耗和性能瓶颈.
3. proactive vulnerability discovery. 厂商通过测试技术主动寻找漏洞, 如 sanitizers, afl 等模糊测试技术. 这类技术找漏洞效率高, 但没有健壮性, 即没办法证明所有漏洞皆被发现. 并且会加重维护人员负担.
4. high-assurance prevention. 指有内生安全性的**安全编程**. 过往通过 GC 保证内存安全的虚拟机语言被认为是低效的, 但随着编译器技术(静态分析)发展, Rust 这类编译时安全语言的性能逐渐接近系统级语言. 

谷歌认为因为内存漏洞在旧代码中指数级减少, 而更常见于新引入的代码. 只要新代码皆使用内生安全性语言 (Rust), 就可以显著降低总体漏洞数量.

***

> "How long do bugs live?" in os, the median around 1.25y.
> 
> An empirical study of operating systems errors. @chou2001. 

[^1]: Alexopoulos et al. ["How Long Do Vulnerabilities Live in the Code? A Large-Scale Empirical Measurement Study on FOSS Vulnerability Lifetimes"](https://www.usenix.org/conference/usenixsecurity22/presentation/alexopoulos). USENIX Security 22.

[^2]: https://security.googleblog.com/2024/09/eliminating-memory-safety-vulnerabilities-Android.html

[^3]: A systematic review of fuzzing techniques. Chen Chen, Baojiang Cui. 2018.
