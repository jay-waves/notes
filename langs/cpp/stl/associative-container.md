关联容器 (associative contianers) 存储**键值对 (key-value)**, 底层基于[红黑树](../../../algo/tree/red-black-tree.md), 元素插入时自动排序. 查找和插入效率都为 $O(\log n)$.

## set

Set 存储非重复元素. set 中**只存储键, 并不是键值对**.

需要使用者提供 `Compare` 函数, 比较元素的键是否相同 `!comp(a, b) && !comp(b, a)`. 

```cpp
#include <set>

template<
	class Key,
	class Compare = std::less<Key>,
	class Allocator = std::allocator<Key>
> class set;

set(cosnt set &st); // 拷贝构造函数
set& operator=(const set &st);
swap(st);
```

set 的迭代器是 `const_iterator`, 因为 set 中直接用元素值进行排序, 所以不能直接修改元素的值.

```cpp
find(key);        // 若存在, 则返回该键的迭代器(位置); 若不存在, 返回 set.end()
count(key);       // multiset only
contains(k);      // C++20
lower_bound(elem); // 返回第一个 >= elem 的迭代器，O(logN)
upper_bound(elem); // 返回第一个 > elem 的迭代器，O(logN)
equal_range(elem); // 返回 == elem 的上下限的迭代器


// 最小值
*s.begin();

// 最大值
*prev(s.end());

// 按顺序遍历，注意复杂度是 O(n)，因为是红黑树的中序遍历
for (auto x : s) {}
```

默认的比较器是 *字典序（lexicographical order）* ，比如传入 `pair<M, N>` ，会先比较 `M` 再比较 `N` ，默认升序。

#### 集合操作

```cpp
#include <algorithm>

bool is_subset = std::include(
	a.begin(), a.end(),
	b.begin(), b.end()
);

std::set_union(
	a.begin(), a.end(),
	b.begin(), b.end(),
	std::inserter(result, result.begin();
);

std::set_intersection(
	a.begin(), a.end(), 
	a.begin(), b.end(),
	std::inserter(result, result.begin())
);

// A-B
std::set_difference(
	a.beign(), a.end(),
	b.begin(), b.end(),
	std::inserter(result, result.begin())
);
```

## multiset

允许存储重复元素. 其他类似 set.

```cpp
multiset<T> mst;
```

```cpp
mst.erase(K); // 删除所有 K 
mst.erase(msg.find(K)); // 删除一个 K （仅传入 Iterator）
```

## pair

将一对不同类型的键值对合成一个值.

```cpp
template <class T1, class T2> struct pair

pair.first
pair.second
```

## map

按键存储唯一**键值对**, 即所有元素类型都是 `pair`, 其中 `pair.first` 被视为键, `pair.second` 被视为值, map 不允许两个相同的键.

### 初始化

```cpp
map<T1, T2> mapTT;
map(cosnt map &mp);

map& operator=(const map &mp);
swap(mp);
```

### 数据存取

插入删除操作之前的迭代器, 在插入删除之后仍然有效, 除了被删除的那个迭代器.

```
....
```

## multimap

