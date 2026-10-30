#import "@local/ypst-template:0.1.0" as theme 

#import theme: template, sidenote, theorem

#show: template

#let dataframe(header, ..cells) = {
  table(
    columns: header.children.len(),
    inset: (x: 6pt, y: 2pt),
    stroke: 0.3pt + luma(80%),
    fill: none,
    header,
    ..cells,
  )
}

= 概念

*域* (Domain)：一组具有#emph[相同数据类型]的值的集合。为了区分不同语义下相同值类型的域，可以为域中的不同角色独立命名为#emph[属性 (Attribute)]。

*笛卡尔积* (Cartesian Product)：给定一组（可能重复的）域 $D_1, D_2, dots.c, D_n$，笛卡尔积为

$ D_1 times D_2 times dots.c times D_n = { (d_1, d_2, dots.c, d_n) | d_i in D_i } $

*关系* (Relation)：域 $D_1, D_2, dots.c, D_n$ 上的笛卡尔积的子集称为关系，表示为

$ R(D_1, D_2, dots.c, D_n) $

*元组* (Tuple)：笛卡尔积中每一个元素 $(d_1, d_2, dots.c, d_n)$ 皆为一个 $n$ 元元组。

*分量* (Component)：元组 $(d_1, d_2, dots.c, d_n)$ 中的 $d_i$ 称为一个分量。

#table(
  columns: (1fr, 1fr),
  table.header([*关系代数术语*], [*表术语*]),
  [关系名], [表名],
  [关系模式], [表头（表结构）],
  [关系], [二维表（数据）],
  [元组], [行],
  [属性], [列],
  [分量], [某个列值],
)

== 关系模式定义

关系模式 (relation schema) 是五元组 $(R, U, D, "Dom", F)$，通常记为 $R(U, D, "Dom", F)$：

- $R$：关系名。
- $U$：一组属性。
- $D$：属性组 $U$ 所来自的域。
- $"Dom"$：属性到域的映射。
- $F$：属性组 $U$ 上的一组数据依赖（约束关系）。

简化为 $R(U, F)$，其实例（某个关系，即数据库中的关系数据）记为 $r$，$r$ 包括很多数据元组 $t$（行）。

= 运算

常见关系操作如下，其中数据查询只列出了 5 种基本操作：

#table(
  columns: (1fr, 2.1fr),
  table.header([*常见关系操作*], [*操作*]),
  [数据查询], [选择、投影、并、差、笛卡尔积],
  [数据更新], [插入、删除、修改],
)

关系代数中，基本运算有：

- 逻辑和算术运算符。
- 集合运算符。
- 专有关系运算符，见下。

#table(
  columns: (1fr, 0.7fr, 2fr),
  table.header([*专用关系运算符*], [*名称*], [*对应语义*]),
  [$sigma$], [选择], [`select ... where ...`],
  [$pi$], [投影], [`select ...`],
  [$⋈$], [连接], [`join`],
  [$div$], [除], [全称条件（如“所有”）],
)

== 基础符号定义

设关系模式 $R(A_1, A_2, dots.c, A_n)$：

- $R$：该关系模式下的一个关系。（注意：关系模式是结构，相对固定；关系是数据，可以变化。）
- $t in R$：$t$ 是 $R$ 中一个元组。
- $t[A_i]$：元组 $t$ 中属性 $A_i$ 的分量值。

设属性组 $A = {A_1, A_2, dots.c, A_k}$：

- $t[A]$：元组 $t$ 在属性组 $A$ 上诸分量构成的子元组。
- $overline(A)$：取补，指总属性去掉属性组 $A$ 后的属性组。

$t_1 ⌢ t_2$：元组的连接（拼接），其中 $t_1 in R$、$t_2 in S$，连接后的列数为 $R$、$S$ 列数之和。

$Z_x$：给定关系 $R(X, Z)$，其中 $X, Z$ 为属性组。分量值 $x$ 在 $R$ 中的#strong[象集 (images set)]为

$ Z_x = { t[Z] | t in R, t[X] = x } $

== 集合运算

- 并：$R union S$，两个关系的并集，两个关系必须具有相容的属性及对应的域。
- 差：$R - S$，两个关系的差集，即在 $R$ 中存在、在 $S$ 中不存在的元组构成的集合。
- 笛卡尔积：$R times S$，两个关系的笛卡尔积。
- 交：$R inter S = R - (R - S)$。

详见 #link("https://notes.jay-waves.cn/math/algebra/%E9%9B%86%E5%90%88/")[集合]。

== 选择

选择 (select)，又称 restriction、filter，指选择关系 $R$ 中满足给定条件的各个#strong[行]（元组）：

$ sigma_F (R) = { t | t in R and F(t) = "True" } $

其中 $F$ 为逻辑表达式，基本形式为 $X theta Y$，泛指一个谓词条件。

== 投影

投影 (projection) 指选择关系中若干属性#strong[列]，同时去除重复行（集合性质）：

$ pi_A (R) = { t[A] | t in R } $

== 连接

连接也称 $theta$ 连接 ($theta$-Join)，指从两个关系的笛卡尔积中选择满足条件的元组：

$ R ⋈_(A theta B) S = { t_r ⌢ t_s | t_r in R and t_s in S and t_r[A] theta t_s[B] } $

其中属性组 $A$ 和 $B$ 应该度数相等且可比，$theta$ 为比较运算符。

连接运算不是基本运算，可以被表示为：

$ R ⋈_(A theta B) S = sigma_(t_r[A] theta t_s[B]) (R times S) $

=== 等值连接

等值连接 (equi-join) 指 $theta$ 运算符为 `=`：

$ R ⋈_(A = B) S = sigma_(t_r[A] = t_s[B]) (R times S) $

=== 自然连接

自然连接 (Natural Join) 用共有属性组来连接关系，并将重复列去除。设 $U_R$ 和 $U_S$ 分别为关系 $R$ 和 $S$ 的属性组，$U = U_R union U_S$ 为全体属性集合，$B = U_R inter U_S$ 为共有属性组。自然连接定义为：

$ R ⋈ S &= { t_r ⌢ t_s[U_S - B] | t_r in R and t_s in S and t_r[B] = t_s[B] } \
  &= pi_(U_R union (U_S - B)) (sigma_(t_r[B] = t_s[B]) (R times S)) $

第二式中，笛卡尔积里的同名属性应先加以区分，再进行选择和投影。

$R ⋈ S$ 时，可能存在 $R$ 中的元组在 $S$ 中找不到匹配元组而被舍弃，称为#strong[悬浮元组] (dangling tuple)。保留悬浮元组的操作称为#strong[外连接] (outer join)：

- 左外连接 (left outer join)：保留 $R$ 中无匹配的元组，$S$ 中无匹配元组时对应列置为 `NULL`。
- 右外连接 (right outer join)：保留 $S$ 中无匹配的元组，$R$ 中无匹配元组时对应列置为 `NULL`。
- 全外连接 (full outer join)：保留左右两边的所有元组，未匹配列置为 `NULL`。

== 除法

除运算 (division)：给定关系 $R(X, Y)$、$S(Y)$，且 $pi_Y (S) subset.eq pi_Y (R)$。记 $Y_x$ 为元组在 $X$ 上分量值为 $x$ 的象集。则除法可得到元组在 $X$ 上的投影，该投影满足 $pi_Y (S) subset.eq Y_x$。记为

$ R div S &= { x in pi_X (R) | pi_Y (S) subset.eq Y_x } \
  &= pi_X (R) - pi_X ((pi_X (R) times pi_Y (S)) - R) $

除法适合表达具有全称量词的查询语境，如 `select ... for all`，比如“查询选修了所有课的学生”：$R div S$。

此时有学生选课表 $R$：

#dataframe(
  table.header([*UID*], [*Course*], [*Name*]),
  [21371000], [english], [yjw],
  [21371000], [chinese], [yjw],
  [21371000], [math], [yjw],
  [21371100], [english], [alice],
  [21371050], [chinese], [bob],
)

课程表 $S$：

#dataframe(
  table.header([*CID*], [*Course*]),
  [1], [english],
  [2], [chinese],
  [3], [math],
)

由于课程表 $S$ 还包含 `CID` 列，实际应以 $pi_("Course") (S)$ 为除数，即 $R div pi_"Course" (S)$。结果为学号 `21371000`、姓名 `yjw`。

数据库查询通常没有直接的全称量词 (`for all`)，需要用存在量词等价转换：

$ (forall x) P equiv not (exists x (not P)) $

其中量词 $x in Q$，$P$ 为谓词。举例而言，“选择了所有课程的学生”等价于“不存在有课程没有被该学生选过”，其中 
$x = "Course" in Q = "All Couses"$，$P = "Student select this course"$。












