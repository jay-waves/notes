## 指南

使用 kernel 风格 [kernel-c-style](../langs/c/kernel-c-style.md), 内容为组合优化.

大部分数据结构有三个核心接口:
- `search()`, 最基础的遍历, 用于一窥核心结构.
- `delete()`, 当不适用惰性删除时, 删除通常是最复杂的操作.
- `insert()`, 当键已存在时, 仅更新.

可能会有多个版本的实现:
- 不同编程语言: C, C++, Go. 主语言是 C++, 其他语言版本见 `src/algo/xxx`
- 不同复杂度: 并发版本, 元编程版本
- 不同接口

## TOC 

| toc         | en  | zh         |
| ----------- | --- | ---------- |
| btree       |     |            |
| concurrency |     | 并发算法   |
| graph       |     | 图论       |
| hash-based  |     | 哈希表相关 |
| linked-list |     | 链表结构   |
| sort        |     | 排序算法   |
| string      |     | 字符串算法 |
| tree        |     | 二叉树算           |


## 名词表

- 序列: 指顺序容器, Sequence Containers, 元素按插入顺序存储, 通过索引访问.[^1] 
- 映射: 指关联容器, Assocaiative Containers. 一般基于树结构实现, 存储键值对.
- 散列: 指散列容器, Unordered Containers. 一般基于哈希表实现, 也存储键值对, 但存储位置无序, 由哈希函数决定, 查找较快.
- size, 指当前结构中有意义的元素个数.
- capacity, 指当前结构中可容纳的最大元素个数. 当实际开辟内存空间大于实际使用空间时, capacity 指实际开辟的空间.
- peek, 指从当前数据结构中挑选出首个元素, 但不移除.
- pop, 指从当前数据结构中挑选出首个元素, 同时移除.
- push, 指向当前数据结构压入一个元素.
- xxx_init, 指某数据结构的初始化方法, 仅初始化数值, 不开辟内存.
- new_xxx, alloc_xxx, create_xxx, 指开辟内存 (声明对象) 同时对其初始化.
- num, 当数组元素类型不明确时, 如 `void *`, size 应表示单个数组元素的字节大小, num 表示数组元素数量. 
- sort, 排序
- swap, 交换两元素在内存中的位置.

[^1]: 详见 [readme](../langs/cpp/data-types/stl/readme.md)d)

### 数据结构列表

- 栈 (Stack)
- 队列 (Queue), [循环队列](linked-list/queue.md), [双端队列](linked-list/deque.md), [优先队列](tree/binary-heap.md)
- 链表 (Linked List). 循环链表, [双向链表](linked-list/doubly-linked-list.md), 十字链表, 跳表, 邻接表. 
- [哈希表](hash-based/hash-table.md), (Hash Table, Map, Dictionary, Symbol Table)

### 错误码

使用 C POSIC LIB `errno.h` 中定义的部分错误状态码. 详见 [src/errno.h](../attach/src/kernel/errno.h)
- `-ENOMEM` 内存不足, 无法分配内存. 即 `malloc` 失败时返回.
- `-EINVAL` 无效参数.
- `-ENOENT` 资源不存在, 如查找操作未找到指定键, 或数据结构已空.
- `-ENOSPC` 空间不足, 数据结构已满.
- `-EBUSY` 资源忙, 数据结构已被其他操作锁定.
- `-EEXIST` 资源已存在, 如插入操作中发现已有相同键.

这些错误码都是宏定义的负数整型, 但我们并不能保证某操作的正常返回值一定不是负数. 具体情境请具体分析, 如使用指针传参而不是返回值的形式.

## 参考

wiki

*Introduction to Algorithms*. Thomas H. Cormen.

*Data Structures and Algorithm Analysis in C*. Mark Allen Weiss. 2019 2rd.

OI Wiki. https://github.com/OI-wiki/.
