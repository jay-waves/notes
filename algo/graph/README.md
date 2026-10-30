## 图

定义 $G=(V,E)$, 其中：
* $V$ 是非空点集合，每个元素称为 *顶点（vertex）* 或 *节点（node）*
* $E$ 是边集合。*边（edge）* 可以无方向，记为 $(u,v)$；也可以有方向，记为 $u\to v$，其中 $u$ 称为 *前驱节点*，$v$ 称为 *后继节点*；也可以有 *权*，记为 $e_{k}$
* $|V|$，节点数称为图的 *阶（order）*。

### 相邻

若存在边 $(u,v)$，则称节点 $u,v$ 是 *相邻的（adjacent）*。

一个点集 $S$ 的*邻域（neighborhood）*是所有与其中至少一个点相邻的顶点所构成的集合，记作 $N(S)$.

### 度数

与一个节点 $v$ 相邻的边数，称为该节点的 *度（degree）*，记作 $d(v)$。有向图中，以 $v$ 为起点的边数，称为 *出度（out-degree）*；以 $v$ 为终点的边数，称为 *入度（in-degree）*

**握手定理（图论基本定理）**：任何无向图 $G$，有 $\sum d(v)=2|E|$


### 稀疏图

若图满足 $|V|^{2}\approx |E|$，则称其为 *稠密图（dense graph）*；反之，${} |V|^{2}\gg|E| {}$，称为 *稀疏图（sparse graph）*。相关算法主要讨论 $O(|V|^{2})$ 和 $O(|E|)$ 的效率差异。

### 连通

若无向图 $G$ 满足任意两个顶点间，均存在一条路径相连，则称其为 *连通图（connected graph）*。在有向图中，如果所有顶点均两两可达，则称图为 *强连通图*。


## 图数据结构

### 邻接表

Adjacency List. 每个顶点维护 `vector<pair>`, 适合稀疏图. 

```cpp
// i ---(w)--> j
vector<pair<j, w>>
```

### 邻接矩阵

Adjacency Matrix: `m[V][V]`, 适合稠密图 (边接近 $V^{2}$). `m[i][j]` 表示从节点 `i -> j` 的边, 无权重则存储 `INF`.

## 图的遍历

DFS + `visited[]` 。图比二叉树的复杂性在于，图可能包含环。

## 最小生成树

最小生成树 (Minimum Spanning Tree, MST) 是指在**连通加权无向图** $G=(V,E)$ 中, 找到一个树 (无环连通子图), 包含图中所有节点, 并且边的权重之和最小. 属于贪心算法.

### Kruskal 算法

```cpp 
class Graph {
private:
	int V; // 节点数
	vector<tuple<int, int, int>> edges; // (w, u, v)
public:
	Graph(int v) : V(v) {}
	
	void addEdge(int u, int v, int w) {
		edges.push_back({u, v, w});
	}
	
	int MST();
};

```

使用 [并查集](union-find.md) 来判断两个节点是否处于同一连通分量, 并检测加入边是否会形成环. 整体均摊复杂度为 $O(E\log E)$.

```cpp

int Graph::MST() {
	sort(edges.begin(), edges.end()); 
	
	UnionFind uf(V);
	int mstWeight = 0;
	vector<tuple<int, int, int>> mstEdges;
	
	for (auto [w, u, v] : edges) {
		if (uf.unite(u, v)) { // 无环
			mstWeight += w;
			msgEdges.push_back({u, v, w});
		}
	}
	
	return mstWeight;
}
```

### Prim 算法

从一个节点开始, 每次选择与当前生成树连接的权重最小的边. 使用优先队列选择最小边时, 复杂度为 $O(E\log V)$.

```cpp
class Graph {
private:
	int V;
	vector<vector<pair<int, int>>> adjList; // (u, w)
public:
	void addEdge(int u, int v, int w) {
		adjList[u].push_back({v, w});
		adjList[v].push_back({u, w});
	}
	
	int MST();
};
```

```cpp
int Graph::MST() {
	vector<int> key(V, INT_MAX); 
	vector<bool> inMST(V, false); // 是否在生成树中
	vector<int> parent(V, -1); 
	// 最小堆
	priority_queue<pair<int, int>, vector<pair<int, int>>, greater<>> pq; 
	
	key[0] = 0; 
	pq.push({0, 0}); 
	
	while (!pq.empty()) {
		int U = pq.top().second; 
		pq.pop();
		
		if (inMST[u]) continue; 
		inMST[u] = true; 
		
		for (auto [v, w] : adjList[u]) {
			if (!inMST[v] && w < key[v]) {
				key[v] = w;
				parent[v] = u;
				pq.push({w, v});
			}
		}
	}
}
```

## 深度优先搜索

## 广度优先搜索

## 有向无环图
DAG 

## 哈密顿图

包含所有边的路径: 高斯路径. 是 $O(n)$ 可解的.

包含所有顶点的路径: 哈密顿路径. 被认为没有指数时间解法.

## 图着色问题

### 有环判定

Kahn 算法：(自底向上遍历)
* 将无入度的叶节点压入**队列**
* 弹出队列，根据边消除它出度指向的节点的入度
* 将新的无入度节点压入队列
* 队列空后，判断是否处理了所有节点。有节点未处理，则有循环依赖。