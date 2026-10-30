形式语言 $G=(N, \Sigma, P, S)$, 其中:
- $N$: 非终结符的有限集合
- $\Sigma$: 终结符的有限集合, $N\cap \Sigma=\emptyset$, $V=N\cup \Sigma$ 成为总词汇表
- $P$: 重写规则的有限集合 $P=\{ \alpha \rightarrow \beta \}$, $\alpha$ 至少含有一个非终结符号.
- $S\in N$: 初始符

**例子:**

$G=(\{ A, S \}, \{ 0, 1 \}, P, S)$, 有: $P: S\rightarrow 0A1,\ 0A\rightarrow 00A1,\ A\rightarrow 1$

## 推导(派生)定义

对于文法 $G$, $V^{*}=(N\cup \Sigma)^{*}$ 上定义
- 直接派生或推导: $\substack{\Longrightarrow\\G}$, 单步派生
- 按非平凡方式派生: $\substack{+\\ \Longrightarrow\\G}$, 多步派生 ($N\ge 1$)
- 派生: $\substack{*\\\Longrightarrow\\G}$ , 自反或多步派生 ($N\ge 0$)

推导方式:
- **最左推导**: 每步推导只改写最左边的非终结符.
- **最右推导**: 每步推导只改写最右边的非终结符.
- **规范推导**: 即最右推导.

由文法生成的语言: $L(G)=\{ x\vert\ x\in\Sigma, S\substack{*\\ \Longrightarrow \\ G} x\}$

## 句型与句子

乔姆斯基语法理论中, 文法分为四类:
- 3 型文法 -> 正则文法
- 2 型文法 -> 上下文无关文法
- 1 型文法 -> 上下文有关文法
- 0 型文法 -> 无约束文法 (递归可枚举语言, 图灵可识别语言)

$L(G_{3})\subseteq L(G_{2})\subseteq L(G_{1})\subseteq L(G_{0})$, 对文法分类时自顶向下.

### 3 正则文法

正则文法 $G=(N, \Sigma, P, S)$ 的规则集 P 中规则均满足:
- $A\rightarrow Bx$ (左线性), 异或: $A\rightarrow xB$ (右线性)
- $A\rightarrow y$, 其中 $A, B\in N$, ${} y\in\Sigma$

> 又见 [字符串正则表达式定义](strings.md).

正则文法不允许嵌套或递归结构, 如 $A \to A$. 正则语言在 并 / 连接 / 星 运算下封闭.

### 2 上下文无关文法

上下文无关文法 (context-free grammar, CFG) 的规则集 P 中规则均满足:   
$A\rightarrow \alpha$, 其中 $A\in N, \alpha\in (N\cup \Sigma)^{*}$

上下文无关文法生成的**句子**可用派生树表示:
<img src="../../attach/img/math/math-formal-languages-derivation-tree.avif" alt="" width="450">

如果一个句子可以由不止一个派生树生成, 就称该文法有**二义性**.

典型例子: ${} \set{a^{n}b^{n}|n\geq 0} {}$

### 1 上下文有关文法

上下文有关文法 (context-sensitive grammar, CSG) 的规则集 P 中规则均满足:  

$\alpha A\beta \rightarrow \alpha \gamma \beta$, 其中 $A\in N,\ \alpha,\beta,\gamma\in (N\cup \Sigma)^{*}$

另一种定义: iff $x\rightarrow y,\ x\in (N\cup \Sigma)^{+},\ y\in (N\cup \Sigma)^{*},\ \vert y\vert \ge \vert x\vert$

典型例子: ${} \set{a^{n}b^{n}c^{n}|n\geq 0} {}$

### 0 无约束文法

无约束文法 (无限制重写系统) 的规则集 P 中规则均满足: $\alpha \rightarrow \beta$, $\alpha, \beta$ 是字符串
