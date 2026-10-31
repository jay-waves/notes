== 这是二级标题

_这是斜体_ 

*这是粗体* 

#highlight[这是高亮]

#underline[这是下划线]

#strike[aaa]

这是#super[上标]

这是#sub[下标]

`inline code`

unordered list:
- item1
- item2 

ordered list:
+ item1 
+ item2 

== 命令/宏

typst 中使用 `#` 前缀来标记命令（表达式）。

#rect(
  width: 2cm,
  height: 1cm,
  stroke: red,
)

=== 图片

```typst
#image("a.png", width: 60%)

#figure(
    image("a.png"),
    caption: [图注],
)
```

不过 typst 不允许加载网络图片，这一点比较坑。另一点是文件间相互引用不好。

=== 表格 

得益于编程性，表格比 Markdown/HTML 强大非常多。

#let rows = (
  (
    [r1c1],
    [r1c2],
    [r1c3],
  ),
  (
    [r2c1],
    [r2c2],
    [r2c3],
  ),
)

#table(
  columns: 3,
  table.header(
    [c1],
    [c2],
    [c3],
  ),
  ..rows.flatten(),
)

== 页面控制

- `#align(center)[xxx]`
- `#box(inset: 4pt)` 行内容器
- `#block(width: 80%)` 行间容器（块级）
- `#h(1em)`  水平空白
- `#v(1em)` 垂直h空白
- `#linebreak()`
- `#pagebreak()`
- `#colbreak()`

== 库

* ctez 
* mermaid (merman)

== 数学

$x^2$ 

$ 
  x^2
$

公式内的字符串用 `""` 包裹，等价于 Latex 的 `\text{}` 

$ "这是文字" $

定义变量、函数时，需要小心数学环境与普通命令环境间的切换：

#let aaa = $x^2$

$ aaa^aaa $

定义变量、函数时，要小心和内置命令冲突，可以用更语义化的名称：

#let sample-count = 100

$ n = #sample-count $

定义数学算子时，推荐明确用 `math.op`，并且避免单字符（会被视作内置符号）：

#let argmin = math.op("arg min", limits: true)
#let KL = math.op("KL")

$
  theta^* = argmin_theta KL(q)
$

复杂公式按推导步骤换行、缩进：

$
  L(theta)
    &= sum_(i=1)^n log p(x_i | theta) \
    &= sum_(i=1)^n
       (log p(x_i) + log p(theta | x_i)) \
    &approx n E_x[log p(x | theta)]
$

复杂公式随行注释：

$
  (a + b)^2
    &= (a+b)(a+b) && "展开平方" \
    &= a^2 + a b + b a + b^2 && "分配律" \
    & = a^2 + 2a b + b^2 && "交换律"
$

明确使用编号，便于自动编码引用:

#set math.equation(numbering: "(1)")

$
  E = m c^2
$ <mass-energy>

 由 @mass-energy 可知……

#set math.equation(numbering: none)

Latex 明确要求 `\left\right` 来拉伸括号，而 Typst 将其作为默认行为。
不过也能用 `lr()` 手动干预

$ (a / lr( (b + c))) $

明确表达附属关系：

$
attach(
  lr(
    x / y |
  ),
  b: "bottom",
)
$

$
attach(
  lr(
    x / y |
  ),
  t: "top",
)
$

Typst 数学字号关系：math size

$
  display("display") > inline("inline") = "default" > script("script") > sscript("sscript")
$

Typst 数学间隙（空格）：

$
  A quad A wide A thin A med A thick
$

Typst 数字字形：

$
  upright(A) italic(A) bold(A)
$

Typst 字形：

$
  serif(A) // 衬线
  sans(A)  // 无衬线
  mono(A)  // 等宽
  frak(A)  // Fraktur
  bb(A)    // Blackboard bold 
  cal(A)   // Calligraphic 
  scr(A)   // Script / roundhand 
$

Typst 输入箭头很方便

$->$

