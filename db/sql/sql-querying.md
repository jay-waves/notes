
```sql
SELECT 
    [DISTINCT] ... 
FROM ...
WHERE ...
ORDER BY ...
[LIMIT #];
```

## WHERE

条件 | 示例 
-----|------
匹配 | `WHERE name = 'yjw'`
通配符匹配 (greed) | `WHERE name like `%Yu%`
通配符匹配 (non-greed) | `WHERE name like `_Yu_`
正则匹配 | `WHERE name regexp '\\([a-z] sticks?\\)`
不匹配 | `WHERE id <> 1003`
范围 | `BETWEEN ... AND ...`
空值 | `WHERE foo is null`
逻辑与 | `WHERE xxx AND yyy`
逻辑或 | `WHERE xxx OR yyy`
集合 | `WHERE xxx (NOT) IN xxx`
存在 | `WHERE () (NOT) exists ()`

## FILTER 

筛选，但是不过滤（删除）

```sql
SELECT
    COUNT(*) FILTER (WHERE revenue > 10000) AS hits
FROM ...
```

## ORDER BY

```sql
SELECT name, id FROM students ORDER BY id;
```

功能 | 示例 
------|----
多列稳定排序  | `ORDER BY math, english, chinese`
降序排序 | `ORDER BY math DESC, english`
最大值 | `ORDER BY math DESC LIMIT 1`


## Complex Querying

### Subquery

```sql
SELECT *
FROM (
    SELECT departmetn, AVG(salary) AS avg_salary
    FROM employees 
    GROUP BY department
) AS dept_avg
WHERE avg_salary > 8000;
```

### WITH (CTE, Common Table Expression)

```sql
WITH dept_avg AS (
    SELECT departmetn, AVG(salary) AS avg_salary
    FROM employees 
    GROUP BY department
)
SELECT *
FROM dept_avg
WHERE avg_salary > 8000;
```
