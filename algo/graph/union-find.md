UnionFind 的主要用途是：检查图的连通性。

_并查集 (Union-Find)_ 并查集的数据包含若干 *不相交集合 (disjoint sets)*，每个集合描述为一个树，树根节点为集合的 *代表元素 (Canonical Element)。*

- `find(x)` 查找元素所属集合的代表元素 `O(1)`
- `union(x, y)` 合并两个集合， `O(1)`，注意标准并查集不支持分裂，仅支持合并。

要查询 $u, v$ 是否属于同一个集合，应比较 `find(u)` 和 `find(v)` 的值。

```cpp
class UnionFind {
private:
	vector<int> parent, rank;
public:
	UnionFind(int n) {
		parent.resize(n);
		rank.resize(n, 0);
		
		// 每一个元素开始时都是独立集合，没有 parent，即 parent 是自己
		for (int i = 0; i < n; ++i) 
			parent[i] = i;
	}
	
	int find(int x);
	
	bool unite(int x, int y);
};
```

```cpp
/*
	递归找到代表元素。
	同时压缩路径：路径上所有元素此后全部指向根元素
*/
	int UnionFind::find(int x) {
		if (parent[x] != x) 
			parent[x] = find(parent[x]);  
		return parent[x];
	}
	
```


```cpp
	bool UnionFind::unite(int x, int y) {
		int px = find(x), py = find(y);
		if (px == py) 
			return false;  // 两元素本就属于同一集合
		
		// 比较 rank，rank 小的树挂在 rank 更大的树下面	
		if (rank[px] < rank[py]) 
			swap(px, py);
		parent[py] = px;
		
		// 如果 rank 相等，新的根 rank++
		if (rank[px] == rank[py]) 
			rank[px]++;
		return true;
	}
```

![union-find](../../attach/img/algo/20260308210719646.avif)

## 参考

https://blog.csdn.net/liujian20150808/article/details/50848646 

[并查集从入门到出门](https://leetcode.cn/discuss/post/3566044/bing-cha-ji-cong-ru-men-dao-chu-men-by-y-dghs/)
