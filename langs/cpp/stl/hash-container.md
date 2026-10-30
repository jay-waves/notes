无序容器 (散列容器, unordered containers) 基于[哈希表](../../../algo/hash-based/hash-table.md)实现, 不进行自动排序. 查找速度最快, 复杂度为 $O(1)$.

核心包含四个部分:
- 哈希函数 `std::hash<K>`. 哈希映射的均匀性直接影响哈希表性能.
- 哈希表: 哈希表大小一般是 ${} 2^n{}$ 或 $prime$, 哈希表每项元素对应一个桶 (bucket)
- 桶数组 (bucket): 
- 碰撞处理策略 (Probing / Chaining): 多个键落入同一个桶时, 要处理"冲突". 

## unordered_set

## unordered_multiset

## unordered_map

## unordered_multimap

## flat_hash 

`std::unordered_map` 的桶仅存储指针, 每个数据必须分配内存, 链式处理哈希冲突; flat_hash 的桶则是平坦数组, 探测法处理哈希冲突, 数据可以存储在桶内. flat_hash 装载比率较高时 (负载因子超过 0.7), 会动态增长数组 (rehash), 短时间要重新计算哈希并复制数据, 有性能抖动, 详见 [Algorithm/哈希表](../../../algo/hash-based/hash-table.md).

不是 STL, 一般由第三方库 abseil, folly, Tessil/robin-map, ska/flat_hash_map 提供.

优点:
- 更快的遍历和查找, 对内存友好
- 内存布局紧凑. 无需存储链表相关数据. 数据量较多时, 节省空间.

缺点: 插入/删除时, 迭代器不稳定. 使用标记删除 (tombstone) 方法, 频繁删除时不要使用.