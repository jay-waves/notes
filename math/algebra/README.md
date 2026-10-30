
#### 数学结构

https://en.wikipedia.org/wiki/Mathematical_structure

集合上的结构指集合上附加的, 赋予集合特殊意义的数学对象. 

- 有序 (order)
- 代数
- 拓扑 (topo)
- 测度 (measure)
- 度量 (metric) / 几何
- 等价关系
- 范畴 (category)
- 微分结构

计算机的诞生侧近了离散数学等难以结构化的数学分支, 因此现代不再按*结构*划分数学领域.

#### 代数结构

https://en.wikipedia.org/wiki/Algebraic_structure

- 群
	- 交换群
	- 幺半群
	- ...
- 环
	- 无零因子环
	- 交换环
	- 整环
	- 域
- 模 (Module)
	- 向量空间 (Vector space)
	- 域代数 (Algebra Over a Field)
- 格 (Lattice)

| $(R^{*}, *)$        | 封闭 | 单位元 | 逆元 | 交换 | 例子                                               |
| ------------------- | ---- | ------ | ---- | ---- | -------------------------------------------------- |
| 幺环 (通常意义的环) | Y    | Y      |      |      |                                                    |
| 无零因子环          | Y    |        |      |      | $\mathbb{Z}\times \{0  \}$                         |
| 整环                | Y    | Y      |      | Y    | $\mathbb{Z}, \mathbb{F}_{p}[x]$                    |
| 除环/体             | Y    | Y      | Y    |      |                                                    |
| 域                  | Y    | Y      | Y    | Y    | $\mathbb{R}, \mathbb{Q},\mathbb{C}, \mathbb{R}(x)$ |

域一定是整环, 整环不一定是域 (即, 无零因子, 不意味着一定有逆元)

```mermaid
flowchart TB
    Set["集合<br/>(Set)"]
    Magma["原群<br/>(Magma)"]
    SemiGroup["半群<br/>(SemiGroup)"]
    Monoid["幺半群<br/>(Monoid)"]
    Group["群<br/>(Group)"]

    AbelianSemiGroup["阿贝尔半群<br/>(Abelian SemiGroup)"]
    AbelianMonoid["阿贝尔幺半群<br/>(Abelian Monoid)"]
    AbelianGroup["阿贝尔群<br/>(Abelian Group)"]

    Set -->|"运算二元运算 ⊕<br/>其应有封闭性 closure<br/>∀x,y∈S, x⊕y∈S"| Magma
    Magma -->|"结合律 associative<br/>(x⊕y)⊕z = x⊕(y⊕z)"| SemiGroup
    SemiGroup -->|"含单位元 identity<br/>∃e, ∀x∈S, x⊕e = e⊕x = x"| Monoid
    Monoid -->|"逆元 inverse<br/>∀x∈S, ∃y∈S, y⊕x = x⊕y = e"| Group

    SemiGroup -->|"交换律 commutative<br/>∀x,y∈S, x⊕y = y⊕x"| AbelianSemiGroup
    Monoid -->|"交换律 commutative<br/>∀x,y∈S, x⊕y = y⊕x"| AbelianMonoid
    Group -->|"交换律 commutative<br/>∀x,y∈S, x⊕y = y⊕x"| AbelianGroup
```

```mermaid
flowchart TB
    SG["阿贝尔群<br/>(SemiGroup) (R, +)"]
    M["幺半群<br/>(Monoid) (R, ·)<br/><br/>常见环的乘法大多也满足交换律<br/>矩阵环、四元数环不满足"]
    D["乘法对加法运算有分配律：<br/>∀x,y,z∈S<br/>x·(y+z)=x·y+x·z<br/>(y+z)·x=y·x+z·x"]

    R["环<br/>(Ring) (R, +, ·)<br/>ℤ, ℤ/nℤ"]
    F["域<br/>(Field)<br/>ℝ, ℝ(x), ℂ, ℚ"]
    PF["素域<br/>(Prime Field)<br/>ℚ, 𝔽ₚ"]
    GF["有限域<br/>(Galois Field)<br/>𝔽ₚ, 𝔽ₚⁿ"]

    SG --> R
    M --> R
    D --> R

    R -->|"非零元素乘法逆元<br/>乘法逆元意味着没有零因子<br/>∀x∈R×, ∃y∈R×, x·y=y·x=e"| F
    F -->|"最小子域<br/>注意 ℚ 是特征为 0 的唯一素域"| PF
    PF -->|"素域有限扩展"| GF
```

#### 抽象空间

https://en.wikipedia.org/wiki/Space_(mathematics)

- 代数空间
- 度量空间
- 希尔伯特空间

<img src="../../attach/img/math/math-algebra-vector-space-overview.avif" alt="" width="500">
