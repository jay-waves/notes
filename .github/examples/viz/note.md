
The local ES module may import only `d3` and must default-export synchronous `render(container)` to 
draw an SVG with a viewBox. For interaction, export `hydrate(container)` and rebind data.

# 箱型图

四种方案的分布对比（示例数据）。悬停箱体或按 Tab 键查看统计摘要。

<viz src="boxplot.js" width="75%" caption="图 1：四种方案的分布"></viz>

# 四季

静态图，编译后无需 JavaScript：

<viz src="bars.js" caption="图 2：四季数值"></viz>

# 资源分配

<viz src="pie.js" caption="图 3：资源分配比例"></viz>

# 数据趋势

<viz src="line.js" caption="图 4：实验组与对照组"></viz>

# 指标变化

<viz src="waterfall.js" caption="图 5：指标变化构成"></viz>

# 散点分布

<viz src="scatter.js" caption="图 6：样本关系"></viz>

# 热力分布

<viz src="heatmap.js" caption="图 7：月度分布"></viz>

# 环形堆叠

<viz src="donut-stack.js" caption="图 8：各组构成"></viz>

# 桑基流向

<viz src="sankey.js" caption="图 9：流量路径"></viz>

# 小提琴分布

<viz src="violin.js" caption="图 10：方案得分分布"></viz>

# 等值线

<viz src="contour.js" caption="图 11：空间强度等值线"></viz>

# 流程图

<mermaid caption="图 12：处理流程">
flowchart LR
  A[读取数据] --> B[绘制图表] --> C[生成文档]
</mermaid>
