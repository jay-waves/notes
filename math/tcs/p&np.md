
<img src="../../attach/img/math/P_NP_NPC_NPH.avif" alt="" width="400">

## P 与 NP

P 和 NP 是判定问题（语言）的复杂度类。

- **P**：若存在确定性图灵机，能够在多项式时间内判定 $x\in L$ 是否成立，则 $L\in P$。

- **NP (Nondeterministic Polynomial Time)**：若满足以下任一等价条件，则 $L\in NP$：
  1. 存在非确定性图灵机，能够在多项式时间内判定 $L$；
  2. 存在多项式时间验证器 $V$ 和多项式 $p$，使得

     $$
     x\in L
     \iff
     \exists y,\ |y|\le p(|x|),\ V(x,y)=1.
     $$

     其中 $y$ 称为 witness。

若 $x\in L$，则至少存在一个可在多项式时间内验证的证书；若 $x\notin L$，则不存在任何能够通过验证的证书。由于确定性计算是非确定性计算的特例，因此

$$
P\subseteq NP.
$$

目前仍不知道：

$$
P\stackrel{?}{=}NP.
$$

### NP-Hard

问题 $L$ 是 **NP-hard** 的，当且仅当对于任意问题 $A\in NP$，都有多项式时间归约

$$
A\le_p L.
$$

这表示在所采用的归约方式下，$L$ 至少和所有 NP 问题一样难。

NP-hard 问题不一定属于 NP，甚至不一定可判定。例如，停机问题是不可判定的，因此不属于 NP，但它是 NP-hard 的。

### NP-Complete

问题 $L$ 是 **NP-complete** 的，当且仅当：

1. $L\in NP$；
2. $L$ 是 NP-hard 的。

即

$$
L\in NP\text{-complete}
\iff
L\in NP\land L\in NP\text{-hard}.
$$

因此，NP-complete 问题既可以在多项式时间内验证，又至少和所有 NP 问题一样难。

**若任意一个 NP-complete 问题存在确定性多项式时间算法，则所有 NP 问题都能在多项式时间内求解**，从而

$$
P=NP.
$$

### SAT 与 Cook–Levin 定理

Cook–Levin 定理证明了布尔可满足性问题 SAT 是 NP-complete 的。这是第一个被证明为 NP-complete 问题的自然问题。

对于任意语言 $L\in NP$ 和输入 $x$，都可以在多项式时间内构造一个布尔公式 $\varphi_x$，使得

$$
x\in L
\iff
\varphi_x\in SAT.
$$

该公式编码了非确定性图灵机在输入 $x$ 上的一次接受计算过程。

因此，如果 SAT 可以被确定性算法在多项式时间内解决，那么所有 NP 问题都可以在多项式时间内解决，即

$$
P=NP.
$$
