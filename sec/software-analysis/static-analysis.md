
- 常量, 范围传播 --> 基于格的
- 别名/指针分析
- 污点分析
- 后向数据流分析

约束求解 (SMT) 及符号执行

类型分析

控制流分析:
- CFG 
- 可达性分析
- 支配性分析

粒度:
- 上下文敏感 (context)
- 流敏感 (flow-sensitvie): 考虑语句执行顺序
- 路径敏感 (path): 区分分支条件 (一般配合 SMT)
- 字段敏感: 细化结构体字段
- 线程敏感: 并发语义, 发生序关系, 锁集

## 现有框架

- LLVM Builtins: `mem2reg, scalar-evolution, aa`
- [SVF](https://svf-tools.github.io/SVF/): 别名分析, 流分析
- 

## 编译优化的基本问题

- 公共子表达式化简 (common subexpression elimination, CSE)
	- 参数访问
	- 结构体字段访问
	- 数组字段访问
- 常量传播 (constant propagation)
- 死代码消除 (dead code elimination)

循环优化:
- 减少循环代码执行长度
- 减少代码体积

### DAG vs. Value Numbering

代码中的表达式 $T$, 一般被表示为 AST 树形结构. 但树形内部存在结构性冗余, 被称为*公共子表达式*, 在对 AST 树变换时将导致复杂度指数膨胀, 不利于代码复用和代码分析.[^1]

为了消除 CSE, 使用*有向无环图 (DAG)* 来表达 $T$. 每个节点是一个子表达式, 用边表达表达式间的依赖关系. 和树形结构相比, DAG 中的节点可以有多个父节点. DAG 的等价文本形式是 *SLP (Straight-Line Program)*, 在汇编中进一步化简为*三地址码*.

SLP 是一个有限的指令序列 $\mathcal{P}=(I_{1},I_{2},\dots,I_{m})$, 其中每个指令 $I_{k}$ 形式为 $v_{k}\leftarrow \phi_{k}(v_{1},v_{2},\dots,v_{n})$. 也就是定义了变量间的依赖关系. 

除了寻找语法上的冗余, 也要寻找语义的冗余. 换言之, 要找各个表达式是否存在语义等价. 语义等价的算法为 E-Graph, 由一个 *并查集 (Union-Find)* 和一个*典范哈希(Hashcons)* 构成.


### SSA 

DU (Definition-Use) Chains: 变量 X 的定义可见, 如何找到所有对 X 的访问.

UD (Use-Definition) Chains: 变量 X 的某个访问可见, 如何找到所有对 X 的可达定义?

如果允许对变量 X 的重复定义 (赋值), DU 和 UD 关系都会很复杂. 引入 SSA (Static Single Assignment), 以及 PSSA (Partial SSA). 

PSSA 中, 大部分操作使用虚拟寄存器表达, 少部分复杂操作仍保留内存操作. 如果变量 X 的定义来自不同的控制流, 用 $\phi$ 来显式表达. 

## 数据流分析

[data flow analysis](data%20flow%20analysis.md)

### 流敏感

- sensitive to control flow 
- intraprocedural analysis 

一个程序语句 `a = b + c` 对数据流的影响?
1. **使用**了变量 b, c
2. 使变量 a 的原定义值**失效**
3. **新定义**了变量 a 的值

#### Reaching Definitions Analysis 

Transfer functions:
`Out[b] = f(In[b]) = Gen[b] + (In[b] - Kill[b])`
- `Gen[b]` 基本块产生的 definitions
- `In[b]` 从 前序基本块 传入的 definitions
- `Kill[b]` 基本块对变量的重定义, 意味着原 definition 失效.

从控制流入口开始, 正向分析, 研究 "definition" 的有效范围

```
input: CFG = (N, E, Entry, Exit) 

// 初始化
	out[Entry] = {}
	
	For all nodes i
		out[i] = {}
		
	ChangedNodes = N
	
// 工作集迭代
	while ChangedNodes not empty {
		Remove i from ChangedNodes
		in[u] += out[p], for all predecessors p of i
		oldout = out[i]
		out[i] = f(in[i], i) // f = gen[i] + (in[i] - kill[i])
		if (oldout != out[i]) {
			for all successors s of i
				add s to ChangedNodes
		}
	}
```

#### Variables Liveness Analysis 

在某个程序位置 p, var x is live, 意味着从 p 开始的控制流中 x 会被使用. 反向分析, 从变量 x 的使用位置开始, 反向找到它的定义.

`in[b] = Use[b] + (out[b] - Def[b])`
- `Use[b]` 基本块 b 使用的变量 
- `out[b]` 从 后继基本块 传播 (propagate) 来的 var liveness
- `Def[b]` 基本块 b 定义的变量

```
input: CFG = (N, E, Entry, Exit)

// 边界条件
in[Exit] = {}

// 初始化
For each b.b. B other than Exit 
	in[B] = {}
	
// 迭代
While (changes to any in[] occur) {
	For each basic block B other than Exit {
		out[B] += (in[s]), for all successors s of B
		in[B] = f(out[B], B) // f = Use[B] + (out[B] - Def[B])
	}
}
```

什么情况无法收敛? 

### 路径敏感分析

数据流 + 条件可达性分析:
- SAT (命题逻辑公式可满足性判定): 仅限布尔类型的谓词逻辑判定
- SMT (Satisfiability Modulo Theories): 混合类型的谓词逻辑判定, 包括 未解释函数 / 布尔表达式 / 线性算术 / 字符串表达式 / 非线性算术等. 

流行的 SMT Solver 有: CVC4, [Z3](https://github.com/Z3Prover/z3). 

## 别名分析

基于包含, 基于合并

## 过程间分析

考虑函数间的调用关系, 也称为*链接时分析 LinkTime Analysis*. 

## 类型状态分析

状态机形式描述

## Lattice (Order)

指某种*偏序集合* (partially ordered set, poset), 其中任意一对元素有唯一的*上确界* (supremum, least upper bound, join) 和*下确界* (infimum, greatest lower bound, meet). 

表达了一种信息精确性的约束关系, 见 https://en.wikipedia.org/wiki/Lattice_(order).

![](../../attach/img/sec/Snipaste_2025-09-18_14-18-49.png)

$x\leq y$ iff $x\wedge y =x$. 

$x\wedge y\leq x$

## 控制流分析

CFG Analysis:
- Dominator Tree Analysis  / PostDominator
- Loop Info Analysis 
- Branch ProbabilityInfo
- AA Analysis 
- LazyValue Info 
- MemorySSA 

### 如何划分基本块?

**识别所有基本块的起始**:
- 程序第一个指令
- 任意跳转指令的目标指令
- 任意跳转指令的后续指令

### Dominator Tree 

找到那些块一定在执行某块之前

### Loop Analysis 

循环头, 循环体, 反向边

### Path-sensitive analysis

## 形式化验证

BMC (Bounded Model Checking) 是一种形式化验证技术. 通过限制循环等控制流深度, 将模型检查问题约束为可满足性问题 (SAT).

对于给定系统 $M$ 和属性断言 $P$, BMC 展开 $M$ 的状态迁移关系 $k$ 次, 得到一个描述长度为 $k$ 的执行路径的逻辑公式, 同时在其内编码断言 $P$. 如果上述公式可满足, SAT 求解器返回一个实际的违例路径, 表示 $k$ 步以内存在属性违例. 如果公式不可满足, 则逐步增大 $k$ 来扩大整个状态空间的搜索范围.

 [Clarke, 2001]

BMC 的主要缺陷: 随着 $k$ 增加, 状态爆炸. 不具备完备性, 只能找到违例. 

### CBMC 

CBMC [Clarke, 2004] 是第一个可分析 ANSI-C 全集的 BMC 框架.

大概步骤如下:
1. Preprocessed 
2. loop are unwound: `while`, `goto`. 展开到 $n$ 步.
3. (recursive) function calls are expanded: 将函数内联, 将递归限制在 $n$ 步.
4. Transform into SSA form (requiring a [pointer analysis](pointer%20analysis.md))

![](/attach/img/sec/cbmc.avif)

此时程序被形式化为 $C,P$, 接着用 SAT 求解器, 求解合取范式 (CNF): $C\wedge \lnot P$.
- $C$: constraints. 约束, 指程序本身的逻辑约束
- $P$: property. 性质, 如安全条件和用户规定的断言.

### IC3 

[Enn, 2011]


## 参考

将内核编译为 vmlinux.bc : wllvm https://github.com/travitch/whole-program-llvm

CMU15-745. Optimizing Compilers for Moedern Architectures, [Spring 2019](https://www.cs.cmu.edu/afs/cs/academic/class/15745-s19/www/), [Fall 2025](https://www.cs.cmu.edu/~15745/www/)

[^1]: 这个现象被称为 Expression Swell. 参考 [为什么函数求导后, 表达式长度会指数增加?](https://www.zhihu.com/question/609058716/answer/1954152484693058426)