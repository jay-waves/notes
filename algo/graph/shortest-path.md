## Dijkstra

## Bellman-Ford

## A*

A\* 是融合了 Greedy 贪婪算法和 Dijkstra 算法，在寻找最短路径同时，保证了搜索的效率最优 
(Optimal Efficiency). 即，A\* 在**一定假设条件**下，可以扩展尽可能少的节点。[^1]

[^1]: 这并不保证是运行速度最快。

A\* 算法的评价函数（成本估计）:

$$f(n) = g(n) + h(n)$$

其中：
* $g(n)$ 是启动到节点 $n$ 的实际成本。这部分实际是 Dijkstra 算法。
* $h(n)$ 从节点 $n$ 到终点的估计成本 (Heuristic). 

其中 $h$ 需要满足 $$h(n) \leq h^*(n)$$ 

$h^*$ 是节点 $n$ 到目标的真实的最优成本。$h$ 实质是算法选择的用于逼近 $h^*$ 的启发函数。
在简单网格图（代价就是四方形距离）中，$h(n)$ 可以用曼哈顿距离，如图：

<figure>
  <img src="../../attach/img/algo/a-star.webp">
  <figcaption>Source: <a href="https://www.redblobgames.com/pathfinding/a-star/introduction.html">Red Blob Games</a></figcaption>
</figure>



