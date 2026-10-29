
窗口函数 `OVER` 不会聚合合并行，而 `GROUP` 会聚合并减少行数。

* `PARTION BY` 分组。当没有分组时，所有行就会属于同一组，不重置窗口函数值
* `ROWS` 在每个组内，规定滑动窗口大小，比如从组开始到当前行的后一行，不跨组
* `ORDER BY` 组内排序（非组排序）
* `QUALIFY` 用于对每组的内部行进行二次筛选

```sql
foo() OVER (
    PARTITION BY ... [, ...]
    ORDER BY ....
    ROWS BETWEEN ... AND ...
)
[QUALIFY ...]
```

`foo()` 是指窗口函数，有以下四类：
- 排名函数 `ROW_NUMBFER()`, `RANK()`
- 偏移函数 `LAG()` 上一行，`LEAD()` 前一行
- 普通聚合函数 `SUM(), COUNT()`
- 分布比例函数 `NTILE(), PERCENT_RANK(), CUME_DIST()`


```sql
SELECT
    customer,
    month,
    amount,
    LAG(amount, 1) OVER (
        PARTITION BY customer
        ORDER BY month
    ) AS prev_amount
FROM orders;
```

计算最近三行的滚动销售额：

```sql
SUM(amouont) OVER (
    PATITION BY customer
    ORDER BY month
    ROWS BETWEEN 2 PRECEDING and CURRENT ROW 
)
```

**注意，窗口函数的执行顺序相对靠后**：

FROM/JOIN  >  WHERE  >  GROUP BY ... HAVING  >  Window Function  >  SELECT  >  DISTINCT  >  ORDER BY
