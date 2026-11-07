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

#let select = math.limits(sym.sigma)
#let project = math.limits(sym.pi) // inline: false
#let join = math.limits(sym.bowtie.big) // inline: false

= TL;DR


= 定义

关系模式 (relation schema)  记为 $R(U, F)$: 

- $R$：关系名。
- $U$：一组属性 (Attribute)，各来自某个 Domain （即某种数据类型）。
- $F$：属性组 $U$ 上的一组数据依赖（约束关系）。

#table(
  columns: (1fr, 1fr, 1fr),
  table.header([*关系代数术语*], [*表术语*], [表示]),
  [关系模式, Relation], [Table Schema], [$R$],
  [关系], [表], [$r$],
  [元组, Tuple], [行], [$t in r$],
  [属性, Attributes], [列], [$A$],
  [域, Domain], [数据类型], [$D$],
  [分量, Value], [某个列值],[$t[A]$],
)


= 查询

查询运算：

- 逻辑和算术运算符。谓词条件记为 $P$
- 集合运算符。
- 专有关系运算符：选择 $sigma$、投影 $pi$、连接 $join$、除 $div$ (全称条件）、拼接 $parallel$

$t_1 parallel t_2$：元组的连接（拼接），其中 $t_1 in R, t_2 in S$，连接后的列数为 $R$、$S$ 列数之和。

== 集合运算

- 并：$R union S$，两个关系必须具有相容的属性及对应的域。
- 差：$R - S$，即在 $R$ 中存在、在 $S$ 中不存在的元组构成的集合。
- 笛卡尔积 (Cartesian Product)：$R times S$，两个关系的笛卡尔积。
- 交：$R inter S = R - (R - S)$。

详见 #link("https://notes.jay-waves.cn/math/algebra/set.md/")[集合]。

== 选择

选择 (select)，从 $r$ 中选择出满足谓词条件的行：

$ select_P (r) = { t | t in r and P(t) } $

> SQL 中笛卡尔积显然是代价很大的操作。应尽早过滤行和投影，再进行连接等操作。

== 投影

投影 (projection) 指从 $r$ 中选择若干列，并去除重复行：

$ project_A (r) = { t[A] | t in r } $

== 连接

连接 (join) 指从两个 $r$ 的笛卡尔积中选出满足谓词条件的元组：

$ r_1 join_P r_2 = select_P (r_1 times r_2) $

=== 等值连接

Equi-Join:

$ r join_(r[A] = s[B]) s = select_(r[A] = s[B]) (r times s) $

=== 自然连接

Natural Join 将 $r(A,B)$, $s(B,C)$ 中共有属性的值都相等的元组拼接，并去除重复的共有属性。

$ r join s 
  &= { t_r [A,B] parallel t_s [C] | t_r in r, t_s in s, t_r [B] = t_s [B] } \
  &=  project_U (select_(t_r [B] = t_s [B]) (r times s))
$

其中：
- $U = {B,C} union {A,B}$ 
- $B = {B,C} inter {A,B}$

=== 外连接

$r join s$ 时，可能存在 $r$ 中的元组在 $s$ 中找不到匹配元组而被舍弃，称为#strong[悬浮元组] (dangling tuple)。保留悬浮元组的操作称为#strong[外连接] (outer join)：

- 左外连接 (left outer join)：保留 $r$ 中无匹配的元组，$s$ 中无匹配元组时对应列置为 `NULL`。
- 右外连接 (right outer join)：保留 $s$ 中无匹配的元组，$r$ 中无匹配元组时对应列置为 `NULL`。
- 全外连接 (full outer join)：保留左右两边的所有元组，未匹配列置为 `NULL`。

== 除法

给定关系 $r(A, B)$ 和 $s(B)$，除法 (division) $r div s$ 找出*所有*这样的 $a$：
对 $s$ 中每个 $b$，组合后的 $(a, b)$ 都在 $r$ 中。

$ r div s = {
  a in pi_A (r) | forall b in s, (a, b) in r
} $

也可以用德摩根律，理解为：选出不存在缺失组合 $(a, b)$ 的 $a$

$ r div s = {
  a in pi_A (r) | exists.not b in s, (a, b) in.not r
} $

除法可用投影、笛卡尔积和差表示：

$ r div s
  = pi_A (r) - pi_A ((pi_A (r) times s) - r) $


=== 小例子

例如，查询*选修了所有课程的学生*。学生选课表 $r$：

#dataframe(
  table.header([*UID*], [*Course*], [*Name*]),
  [21371000], [english], [yjw],
  [21371000], [chinese], [yjw],
  [21371000], [math], [yjw],
  [21371100], [english], [alice],
  [21371050], [chinese], [bob],
)

课程表 $s$：

#dataframe(
  table.header([*CID*], [*Course*]),
  [1], [english],
  [2], [chinese],
  [3], [math],
)

设 $r("UID", "Name", "Course")$ 是选课表，
$s("Course")$ 是课程表，则

$ r div s $

得到选修了所有课程的学生（$"UID"$ 和 $"Name"$）。

