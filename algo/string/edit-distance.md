---
source: https://en.wikipedia.org/wiki/Levenshtein_distance
revised: 24-08-07
---

## Levenshtein Distance

编辑距离, 指将字符串 `a` 转化为 `b` 的最小操作数. 最常见的是 Levenshtein Distance, 由 Vladimir Levenshtein, 1965 提出. 算法允许对 `a` 进行三种操作:
1. 删除一个字符
2. 插入一个字符, 等价于 `b` 删除一个字符
3. 替换一个字符

在 `a, b` 字符串间的 Levenshtein Distance 表示为:

$$lev(a,b)=\begin{cases}
\vert a\vert & \text{if } \vert b\vert = 0,\\
\vert b\vert & \text{if } \vert a\vert = 0,\\
lev(tail(a), tail(b)) & \text{if } head(a)=head(b),\\
1+\min\begin{cases}lev(tail(a), b),\\lev(a, tail(b)),\\lev(tail(a), tail(b))\end{cases} & \text{otherwise}.
\end{cases}$$

其中, $\vert a\vert$ 为字符串长度, $tail(a)=tail(a_{1}a_{2}\cdots a_{n})=a_{2}a_{3}\cdots a_{n}$ , $head(a)=a_1$. 

```haskell
levensh :: Eq a => [a] -> [a] -> Int
levensh [] t = length t  -- If s is empty, return |t|
levensh s [] = length s  -- If t is empty, return |s|
levensh (a : s') (b : t') =  -- head : tail
	if a == b
		then levensh s' t' -- If first chars are the same, can be ignored
		else
		 1 + minimum [ -- try all three possible acitons, select the best 
			    levensh (a : s') t', -- b inserted
			    levensh s' (b : t'), -- a deleted
			    levensh s' t'        -- a replaced with b
			  ]
```

## Wagner Fischer Algorithm

在[动态规划算法](../algorithm.md)中，高效的算法需要缓存计算中间结果。Wagner Fischer Algorithm 算法就是针对这一点对 Levenshtein Distance 的改进。

```javascript
// pseudocode
function LevenshteinDistance(char a[1..m], char b[1..n]):
  // for all i and j, d[i,j] will hold the Levenshtein distance between
  // the first i characters of a and the first j characters of b
  declare int d[0..m, 0..n]
 
  set each element in d to zero
 
  // source prefixes can be transformed into empty string by
  // dropping all characters
  for i from 1 to m:
    d[i, 0] := i
 
  // target prefixes can be reached from empty source prefix
  // by inserting every character
  for j from 1 to n:
    d[0, j] := j
 
  for j from 1 to n:
    for i from 1 to m:
      if d[i] = d[j]:
        cost := 0
      else:
        cost := 1

      d[i, j] := minimum(d[i-1, j] + 1,         // deletion
                         d[i, j-1] + 1,         // insertion
                         d[i-1, j-1] + cost)    // substitution
 
  return d[m, n]
```

注意易错点：空前缀也要占用一个 dp 状态
