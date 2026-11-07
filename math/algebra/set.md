集合中不允许有重复元素.

集合运算符:
- $\cup$ 并
- $-$ 差
- $\cap$ 交
- $\times$ 笛卡尔积

### 并

并 union: 

$A\cup B=\set{t\vert\ t\in A\vee t\in B}$

### 交

交 intersection:

$A\cap B=\set{t\vert\ t\in R\wedge t\in S}$

$A\cap B=A-(A-B)=B-(B-A)$

$A\cap(B\cup C)=(A\cap B)\cup(A\cap C)$

### De Morgan Law 

记 $A^{c}$ 为 $A$ 补。

$(A\cup B)^{c}=A^{c}\cap B^{c}$ 

${} (A\cap B)^{c}=A^{c}\cup B^{c} {}$

### 差

差 difference:

$A-B=\set{t\vert\ t\in A\wedge t\not\in B}$

### 笛卡尔积

笛卡尔积 Cartesian Product:

$$A_{1}\times A_{2}\times \dots \times A_{n}=\set{(a_{1},a_{2},\dots, a_{n})\ \vert\ a_{i}\in A_{i}, i=1,2,\dots,n}$$

如果各个 $A_{i}$ 等价, 也可记为 $A^{n}$. 

如有限域 $GF(p^{n})=\set{(F_{p},F_{p},...,F_{p})\times(1,x,x^{2},...,x^{n})}$

### Power Set 

指 $A$ 的所有子集构成的集合，记为 $P(A)$ 

如 $A=\set{1, 2}$ ，那么 $P(A)=\set{\set{},\set{1},\set{2},\set{1,2}}$

记 $|A|=n$ ，那么 ${} |P(A)|=2^{n} {}$
