[不同乔姆斯基层次的形式语言](formal-languages.md)恰好被不同自动机所识别:

| 文法类型           | 识别器类型     | 
| ------------------ | -------------- | 
| (0) 无约束文法     | 图灵机 $(Q,\Sigma,\Gamma,\delta,q_{0},q_{acc},q_{rej})$        |    
| (1) 上下文有关文法 | 线性带限自动机 |    
| (2) 上下文无关文法 $(V,\Sigma,R,S)$ | 下推自动机 $(Q,\Sigma,\Gamma,\delta,q_{0},F)$     |
| (3) 正则文法       | 有限自动机 $(Q,\Sigma,\delta,q_{0},F)$  |   

自动机区别在于信息存储能力:
- DFA 只能用**状态**来存储信息
- PDA 用**状态+栈**
- 线性带限自动机用**状态+输入/输出带本身**
- 图灵机存储空间没有限制.

## 确定性有限自动机

Definite Automata, DFA, $M=(\Sigma, Q, \delta, q_{0}, F)$:
- 字母表 $\Sigma$ 是输入符号的有穷集合
- 状态集 $Q$ 是有限状态集合
- 起始状态 $q_{0}\in Q$ 是初始状态
- 接受状态集 $F$ 是终止状态, $F\subseteq Q$
- 转移函数 $\delta :=Q\times \Sigma \to Q$

$\sigma_{9}(q, a)=q'$ 描述为: 
<img src="../../attach/img/math/math-automata-transition-function.avif" alt="" width="300">

DFA例子:
<img src="../../attach/img/math/math-automata-dfa-example.avif" alt="" width="300">

由有限自动机 $M$ 定义的语言 $T(M)=\{ x\vert \sigma(q_{0}, x)\in F \}$

### 非确定性有限自动机

Non-definite Automate, NFA, $M=(\Sigma, Q, \sigma, q_{0}, F)$. 其中 $\sigma:= Q\times \Sigma \to 2^{Q}\text{ or }P(Q)$, 即状态转移 $\sigma(q, a)$ 是一个状态*集合*, $\sigma(q, a)=\{ q_{1},q_{2},\dots,q_{k} \}, k\geq 1$ 状态 q 接受输入符号 a 转移时可以选择 $q_{1},q_{2},\dots,q_{k}$ 中任一状态. 其中 $P(Q)$ 称为 Q 的幂集 (power set), 是 Q 所有子集的集合, 总包含 $2^{\vert Q\vert}$ 个元素.

**如果 L 是被 NFA 接受的语言, 那么存在一个 DFA 也接受 L. 即 DFA 与 NFA 能力等价**

**如果 G 是一个正则文法, 那么存在有限自动机 M, 使 $T(M)=L(G)$**

| DFA                               | NFA                                            |
| --------------------------------- | ---------------------------------------------- |
| $\Sigma$ 每个符号恰有转移箭头射出 | $\Sigma$ 每个符号可能有 0,1 或多个转移箭头射出 |
| 所有状态转移皆接受 $\Sigma$ 中符号  | 存在状态转移不接受任何 $\Sigma$ 中符号, 记为 $\epsilon$                                               |

### 泵引理

泵引理用于证明某个语言是否是正则语言. 

**若 A 是一个正则语言, 则存在数 $p$ (泵长度) 使得: 如果 $s$ 是 $A$ 中任一长度不小于 $p$ 的字符串, 则 $s$ 可被分为三段, 即 $s=xyz$, 满足:**
1. $\forall i\geq 0$, $xy^{i}z\in A$
2. $|y|>0$
3. $|xy|\leq p$

## 下推自动机

Push-Down Automata, PDA, 是**带有栈存储器的有限自动机**. $M=(\Sigma, Q, \Gamma, \sigma, q_{0}, Z_{0}, F)$:
- $\Gamma$ :下推存储器(栈)符号的有穷集合
- $Z_{0}\in \Gamma$ 下推存储器顶端符号
- $\sigma:= Q\times(\Sigma\times \{ \epsilon \})\times \Gamma\to Q\times \Gamma^{*}$
- $F$ 终止状态集合. PDA 既可以通过终止状态接受, 也可以通过空栈接受. 两者等价 (即对于通过空栈终止的 PDA, 总存在一个等价的通过终止状态的 PDA).

$\sigma(q, a, Z)\to\{ (q_{1},\gamma_{1}), \dots \}$ 指在状态 q 面临输入 a 时, 进入 $q_{i}$ 时, 用 $\gamma_{i}$ 代替栈顶端符号 Z, 同时移动输入头. $\gamma_{i}$ 中符号按从左到右顺序依次推入栈中. a 可以为 $\epsilon$, 表示不获取输入, 只改变栈信息; Z 不能为空, 可通过 $Z\to Z\gamma$ 的方式来变相完成不弹出只压栈的操作.

<img src="../../attach/img/math/math-automata-pushdown-automaton.avif" alt="" width="300">

下推自动机接受的语言定义为: $T(M)=\{ x\vert\ x:(q_{0},Z_{0})\ \substack{*\\ \vdash \\ M}\ (q, \gamma),\ \gamma\in \Gamma^{*},\ q\in F \}$. 非确定性下推自动机恰好能识别上下文无关文法生成的语言.

### 上下文无关语言的泵引理

如果 $A$ 是上下文无关语言, 则存在*泵长度 $p$*, 使得 A 中任何长度不小于 $p$ 的字符串 $s$ 都可以划分为五段: $s=uvxyz$, 满足:
1. 对于每个 $i\geq 0$, $uv^{i}xy^{i}z\in A$
2. $|vy|>0$
3. ${} |vxy|\leq p {}$

## 线性带限自动机

Linear Bounded Automation, LBA. 是一种特殊图灵机, 其磁带空间限制为输入长度的线性函数.

## 图灵机

[图灵机](turing-machine.md)
