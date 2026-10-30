[Redis](https://redis.io/docs/latest/develop/) 更像是一种数据结构服务器, 而不是关系型数据库; 更适合作为缓冲, 而不是存储海量数据. 实现语言是 C, 数据存储在内存中. 官方列举如下用途:
- database
- cache
- streaming engine
- message broker

Redis 的很多类型虽然类似 Python, 但是并不支持复杂的多层嵌套, 每种类型存储的都是 String. 可以借助键顺序 `a:b:c` 来实现类似嵌套字典的功能.

<img src="../attach/img/db/why-redis-so-fast.png" alt="why redis so fast?" width="600">

Redis 的 IO 模型是 [Reactor](../os/io/io-multiplexing.md) + EventLoop 

## 1. Redis 基础数据结构

### IntSet 

```cpp
typedef struct intset {
	int32_t encoding; // 16, 32, 64
	int32_t length;  
	int<T>  contents;
};
```

### SDS

Redis 字符串称为 SDS (Simple Dynamic String), 内部维护了一个内存池 (块大小为 1MB).

```cpp
struct sdshdr {
	int len;    // 已占用空间
	int alloc;  // 可用空间
	char buf[];
	int flags;
}
```

### ZipList 

元素较少时，

### quicklist 

元素较少时, 使用 `ziplist`; 元素较多时, 使用 `linkedlist`


### Stream 

Redis 5.0 后, Pub/Sub 机制默认使用 Stream 来实现.

## 2. Redis 顶层数据结构

- Strings: 表示字节序列 `"xxxx"`
- Lists: 有序列表 `[v1,v2]`
- Sets: 无序无重复字符串集合, Redis 集合的插入/删除/访问操作为 $O(1)$ 时间. `(k1,k2)`
- Hashes: 类字典的键值格式 `{k:v}`
- Sorted Sets: 有序无重复字符串集合, 每个元素有权重参数 `score` 用于排序 `(<k,score>)`
- Streams: 类似仅追加日志, 记录时间顺序并交付处理.
- Geospatial indexes: 空间索引
- Bitmap: 可在字符串上使用比特操作
- Bitfields: 以字节序列组织的多个计数器

| 数据结构          | 底层数据结构         | 命令前缀 |
| ----------------- | -------------------- | ---- |
| String            | SDS                  |  无, 默认    |
| List              | LinkedList + ZipList |  L    |
| Hash              | HashTable + ZipList  |  H   |
| Set               | HashTable + IntSet   |  S   |
| Sorted Set (ZSet) | SkipList + ZipList   |  Z   |

### Set 

```bash
SADD k m1 m2 ...
SREM k m1 m2 ...
SPOP k [count]  # 随机弹出

SISMEMBER k m 
SMEMBERS k # 返回所有成员
SCARD k    # 返回成员个数

SINTER k1 k2 
SUNION k1 k2
SDIFF k1 k2
```

### BitMap 

```bash 
setbit k offset 0/1
bitop or k 
bitcount k

# 例子
setbit 20260301 1333 1
```

### HyperLogLog 

一种概率性结构，用极小的内存估算元素数量。主要用于可忍受一定误差的统计。

## Redis 的对象模型

Redis 是扁平的 KV 数据库，顶层是一个哈希表。没有类似 JSON 那样的对象嵌套结构，而是将不同子对象拆分到独立的键下，将路径直接编码为字符串键。

==注意，Redis 顶层是 KV 结构，顶层 V 可以是 string、hash、list、set 等类型，但是 V 内部不会再存储 Redis 对象，只能是普通数据。因此嵌套结构是不存在的。==

```json
User {
  id: 1001
  name: "Alice"
  profile: {
      city: "Tokyo",
  }
  orders: [
      { id: 501, price: 99 },
      { id: 502, price: 120 }
  ]
}
```

写入数据：

```bash
# 写入数据
# k="user:1001" type=Hash
HSET user:1001 name "Alice" age 25

# k="user:1001:profile" type=Hash
HSET user:1001:profile city "Tokyo"

# k="order:501" type=Hash 
HSET order:501 price 99

# k="order:502" type=Hash
HSET order:502 price 120 

# 用列表构建索引，由 user:1001:orders --> order
RPUSH user:1001:orders 501 502
```

读取数据：

```bash
HGETALL user:1001
HGETALL user:1001:profile 
LRANGE user:1001:orders 0 -1 # 读取完整订单 ID 列表
```

## 3. Redis 部署

### 数据过期时间

* `EXPIRE key seconds` 指定**秒**后过期
* `PEXPIRE key milliseconds` 指定**毫秒**后过期
* `EXPIREAT key temstamp` 指定**时间戳**时过期
* `TTL key` 查询剩余时间

Redis 底层**使用一个字典来保存键过期时间**。如果过期，返回 NULL，但是懒删除。定期再**随机**删除。

一般建议是，不管是否开启 lazy-free，给键设置的过期时间必须是随机的，避免有大量键集中过期。 #BP

### 数据淘汰策略

内存达到阈值后，Redis 触发淘汰策略（maxmemory-policy）。可配置为：
* volatile-lru 从设置了过期时间的数据中，淘汰最近最少使用的数据
* volatile-ttl 从设置了过期时间的数据中，选择将要过期的数据淘汰
* volatile-lfu 从设置了过期时间的数据中，选择最不经常使用的数据
* volatile-random 从过期的数据中随机选择数据淘汰
* allkeys-lru 移除最近最少使用的数据
* no-eviction 禁止驱逐数据，内存不足时写操作直接报错

### Module 

Redis 官方支持的插件，如：
* JSON 支持
* [Bloom 过滤器支持](../algo/hash-based/bloom-filter.md)
* RedisSearch 索引引擎

### 批量操作

* 原生批量操作命令：原子的
* pipeline：将多个命令打包，非原子

Redis Pipeline 不建议使用，通常用 Lua 脚本或在应用层解决。

### 扫描与过滤

或是利用 `SCAN` 命令实现，Redis 保证其不会阻塞服务，每次仅返回一部分元素，同时遍历扫描键。`SCAN` 的 cursor 游标在遍历中不保证强一致性，因此可能有：重复元素、漏掉新增元素。

```bash
cursor = 0
do:
	cursor, keys = SCAN cursor
while cursor != 0
```
