STL (Standard Template Library) 是 C++ 标准库的一部分, 提供一系列模板化的数据结构和算法.

由于标准确立较晚, C++ STL 有较多的流行版本. 最初版本是 HP STL, 创始人离开惠普加入 SGI 后, 创建 SGI STL, 是 Linux/GCC 平台下比较流行的版本, 开源并且代码优秀. 

主要部分为:
1. 容器, Containers
	- [sequence-container](sequence-container.md): 存储序列, 允许双向遍历. `vector`, `list`, `deque`, `array`, `forward_list`
	- [associative-container](associative-container.md): 存储键值对, 根据键排序. `map`, `multimap`, `set`, `multiset`
	- [hash-container](hash-container.md): 即无序关联容器 `unordered_map`, `unordered_set`, `unordered_multimap`, `unordered_multiset`
	- [container-adapter](container-adapter.md): `queue`, `priority_queue`, `stack`, `bitset`
2. 算法, Alogirithms
3. 迭代器, Iterators. 重载了 `*, ->, ++, -` 等指针相关操作.
4. 函数对象, Funciton Objects. 重载了 `()` 操作的类或类模板.
5. 适配器, Adapters, 将某种容器的接口适配成另一种容器.
6. 空间分配器, Allocator. 内存空间动态管理.

|          | 关联容器           | 散列容器                              | 顺序容器 |
| -------- | ------------------ | ------------------------------------- | -------- |
| 顺序     | 有序, 按键值排序   | 无序                                  | 有序, 按插入顺序         |
| 实现方式 | 红黑树             | 哈希表                                | 数组或双向链表         |
| 查找时间 | $O(\log n)$        | 平均 $O(1)$, 最坏 $O(n)$              |          |
| 插入时间 |                    |                                       |          |
| 删除时间 |                    |                                       |          |
| 空间     |  高                  | 高 (存储哈希表, 同时预留空间防止碰撞) |          |
| 场景     | 有序存储, 范围查询 | 查找和更新速度                        |          |

在 C++98 标准中, 传统 STL 头文件包括:

```cpp
#include <vector>
#include <deque>
#include <queue> // queue + priority_queue
#include <stack> 
#include <list>
#include <set>   // set + multiset 
#include <map>   // map + multimap

#include <bitset>

#inlcude <algorithm>   // sort, swap, compare, merge, search, reverse
#include <numeric>     // math operations
#include <funcitonal>  // functor, reload () as class method 

#include <iterator>
#include <memory>      // memory allocator for containers and auto_ptr
#include <utility>     // *pair*, operations reload
```

随着 C++ 标准发展, 加入了新容器和特性:

```cpp
// C++11
#include <forward_list>  
#include <array>
#include <unordered_map>
#include <unordered_set>
#include <tuple>

// C++17

// C++20
#include <ranges>

// C++23
#include <flat_map> // C++23
#include <flat_set> // C++23
```

## 容器

| 名称           | 分类              | 头文件     | 特性                           |
| -------------- | ----------------- | ---------- | ------------------------------ |
| vector         | sequence          | `<vector>` | 可变大小数组                   |
| deque          | sequence          | `<deque>`  | 支持队列开头结尾的高效插入删除 |
| queue          | adapter           | `<queue>`  | 队列                           |
| priority_queue | adapter           | `<queue>`  |                                |
| stack          | adapter           | `<stack>`  | 栈                             |
| list           | sequence          | `<list>`   | 任意位置插入删除的链表         |
| set            | associative array | `<set>`    | 升序存储唯一值                 |
| map            | associative array | `<map>`    | 升序存储唯一键值对             |

### Almost Containers

| 名称              | 头文件      | 特性                                  |
| ----------------- | ----------- | ------------------------------------- |
| `array<T, N>`     | `<array>`   | 固定大小顺序容器, 支持常量化          |
| `bitset<N>`       | `<bitset>`  | 位图                                  |
| `vector<bool>`    |             | 位图, 比普通 `vector` 更紧凑. 不建议. |
| `pair<T, U>`      | `<utility>` |                                       |
| `tuple<T...>`     |             |                                       |
| `basic_string<C>` |             |                                       |

## 迭代器

见 [iterator](iterator.md) 一节. 

## 线程安全问题

STL 不保证线程安全，即，存在多线程对同一容器的数据竞争。C++ 没有规定对同一容器内部不同位置的并发访问是否是竞争行为，一般也认为是不安全的。


## 常见操作方法

#### 通用

`size_t size() const noexcept` 

`size_t capacity() const noexcept` 

`void resize(size_t cnt, /* const T& value */)`  修改 `size` 并用 `value` 填充

`void reserve(size_t cnt)` 分配 `capacity` 

`bool empty() const noexcept`

`void clear() noexcept` 清空内容，但不释放内存

`It begin() noexcept` `It end() noexcept`

`It insert(/* It pos, */ const T& value)` 在指定位置插入元素

`It erase(It pos)` `It erase(It first, It last)` 移除元素

`void swap(T& other) noexcept` 交换元素 

`T& data() noexcept` 直接获取内部数据，仅 `vector, string, array`

`It emplace(const It pos, Args&&... args)` 原地构造元素

`shrink_to_fit()` 缩减容器 `capacity`，使其接近 `size`

`T& at(size_t pos)` 随机访问。 有越界检查, 抛出 `out_of_range` 异常。

#### only sequences-containers

`void push_back(cont T& value)`

`void pop_back()`

`T& front()`

`T& back()`

#### only associative-containers

`It insert(It pos, const T& value)` 插入元素，如果已经存在则无动作。

`It find(const T& key)` 

`size_t count(const T& key) const` 返回键为 `key` 的元素个数，一般用于判断存在性。

`It lower_bound(const T& key)` 参考 [algorithm, lower_bound](algorithm.md)

#### only hash-containers

`size_t bucket_count() const` 


## 参考

https://www.cnblogs.com/Gou-Hailong/p/14293766.html

https://blog.csdn.net/qq_42322103/article/details/99685797