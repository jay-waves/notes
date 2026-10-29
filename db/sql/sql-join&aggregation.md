
## 1. JOIN

<img src="../../assets/db/db-sql-join-syntax.avif" alt="" width="500">

套集合关系:

|     | =   | <>     | <    | <=    | >    | >=    |
| --- | --- | ------ | ---- | ----- | ---- | ----- |
| ANY | IN  | --     | <MAX | <=MAX | >MIN | >=MIN |
| ALL | --  | NOT IN | <MIN | <=MIN | >MAX | >=MAX      |


```sql
SELECT vend_name, prod_name, prod_price FROM vendors, products
WHERE vendors.vend_id = products.vend_id
ORDER BY vend_name, prod_name;
```

使用表名来完全限定列名.`vend_id` 是 `vendors` 表的主键, `products`表的外键.

使用 `where` 创建连结, 因为 SQL 实际的工作是将两表的每一行进行匹配. 如果不指定条件, 输出是两表的笛卡尔积, 即所有组合的可能.

上述条件是**相等**, 所以也称为等值连结或内部连结, SQL 对该类型支持一种推荐语法:
```sql
SELECT vend_name, prod_name, prod_price 
FROM vendros INNER JOIN products
ON vendors.vend_id=products.vend_id;
```

上述 `inner join` 指**内部联结**, 若 `vendors` 没有匹配的 `products`, 就不会被打印. 使用**外部联结** `outer join`, 可以打印无匹配的行, 值为 `NULL`. `left outer join` 会打印所有 `vendors`, 如果没有对应 `products` 就会显示 `null`; `right join` 反之, 显示右表的所有行, 左表如果没有匹配, 则显示null.

以笛卡尔积角度理解, 内部联结忽略结果零值, 外部联结会显示为 `null`.

### 1.1 多表联结:

连结: 货物表+订单表+供货商表
```sql
SELECT prod_name, vend_name, prod_price, quantity
FROM orderitems, products, vendors
WHERE products.vend_id = vendors.vend_id
	AND orderitems.prod_id = products.prod_id
	AND order_num = 20005;
```

### 1.2 自联结

常用来替代子语句, 速度更快.
```sql
SELECT p1.prod_id, p1.prod_name 
FROM products AS p1, products AS p2
WHERE p1.vend_id = p2.vend_id AND p2.prod_id = 'hello';
```

### 1.3 全称量词 (For All)

数据库没有全称量词 (for all), 需要用存在量词等价转换: $(\forall x) P\equiv \neg (\exists x(\neg P))$, 其中量词 $x\in Q$, P 为谓词. 举例而言, "选择了所有课程的学生" 等价于 "不存在有课程没有被该学生选过", 其中 $x=\text{课程}\in Q=\text{所有课程集合}$, $P=\text{学生选择了该门课}$.

## 2. Aggregation

### 2.1 GROUP BY ... HAVING 

```sql
SELECT department, COUNT(*) AS cnt
    FROM employees
    GROUP BY department
    HAVING COUNT(*) > 5; -- HAVING 用于分组后筛选分组（过滤组）
```

### 2.2 Aggregation Funcion

聚合函数 | 作用 
-------|------
`COUNT(*)` | 统计总数，包括 `null`
`COUNT(DISTINCT students)` | 统计不重复值
`SUM()` | 求和
`AVG()` | 
`MAX(), MIN()` |
`STDDEV()` | 计算标准差
`VARIANCE()` | 计算方差

### 2.3 GROUPING SETS

自定义分组，如：

```sql
SELECT category, year, SUM(revenue)
FROM movies
GROUP BY GROUPING SETS (
    (category, year), -- 每个类别、每年收入分组
    (category),       -- 每个类别的总收入
    ()                -- 所有电影的总收入
);
``` 

等价于，逐级汇总 (ROLLUP): 

```sql
SELECT category, year, SUM(revenue)
FROM movies
GROUP BY ROLLUP (category, year);
```

同时得到明细、小计和总计：

```
category year revenue
Action	2023	100
Action	2024	200
Action	NULL	300
Comedy	2023	50
Comedy	2024	80
Comedy	NULL	130
NULL	NULL	430
```

`GROUPING()` 用于返回某一列是否参数了当前分组 (`1` 表示没有参与当前分组，已经被汇总掉）。
使用 `GROUPING` 判断，比用 `is NULL` 准确，因为原数据也可能有 `NULL`

GROUPING SETS | GROUPING(category) | GROUPING(year) 
-----|-------------|-------------
(category, year) | 0 | 0
(decade) | 0 | 1
() | 1 | 1

排序时也有用： `ORDER BY GROUPING(year), year`

## 3. UNION

将多个 `select` 语句结果组合为一次查询结果. 在同时从多个表中查询类似数据时, 比 `where` 复合条件简洁.

```sql
select vend_id, prod_id, prod_price from products where prod_price <= 5
UNION -- 组合关键字
select vend_id, prod_id, prod_price from products where vend_id in (1001, 1002);

/* 等价于 */

select vend_id, prod_id, prod_price from products
where prod_price <= 5 OR vend_id in (1001, 1002);
```

`union` 会去掉重复, `unioin all` 则会全部显示. 个别数据库还支持 `minus` 和 `intersect`.
