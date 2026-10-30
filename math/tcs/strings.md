## 字符串 String

$\Sigma$ 为字符有限集合, **字符串**由其中有限序列连接. 不包含任何字符成为空串$\epsilon$, 包含空串的 $\Sigma$ 上字符串全体记为 $\Sigma ^*$.

### 字符串操作

#### 连接

- 连接: $abc$
- 方幂: $x^{n}, x=abc$

#### 集合乘积

集合乘积: $AB=\{xy\ \vert\ x\in A, y\in B\}$

#### 集合闭包

- 闭包: $V^{*}=V^{0}\cup V^{1}\cup V^{2}\cup\dots$
- 正闭包: $V^{+}=V^{1}\cup V^{2}\cup \dots$, $V^{+}=V^{*}-\{\epsilon\}$

$V=\{a, b\}$, $V^{*}=\{\epsilon, a, b, aa, ab, bb, ba, aaa, \dots\}$

### 正则表达式 Regular Expression

通过递归定义 $\Sigma$ 上的一些子集(正则集). 定义如下:

1. 空集 $\varnothing$ 和 空串 $\epsilon$ 是正则式, 对应正则集为 $\varnothing$ 和 $\{ \epsilon \}$
2. 任意 $x\in \Sigma$, x为正则式, 正则集为 $\{ x \}$
3. 如果 $X, Y$ 是 $\Sigma$ 上正则式, 并且对应正则集为 $U, V$, 那么: $X\vert Y, X\cdot Y, X^{*}$ 也是正则式, 对应正则集为 $U\cup V, U\cdot V, U^{*}$

**正则表达式等价于[有限自动机](automata.md)**

