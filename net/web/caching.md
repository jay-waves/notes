## 常见缓存管理策略

#### Cache Aside Pattern

*旁路缓存（Cache Aside Pattern）*，指应用程序直接管理 DB 和 Cache。

应用写操作：
1. 更新 DB
2. 直接删除 Cache 中对应数据（懒删除）

应用读操作：
1. 从 Cache 读取数据
2. 若命中（Hit），直接返回
3. 若未命中（Miss），从 DB 读取数据。将读取的数据写回 Cache，然后返回。

工程上，删除 Cache 后，等待几百毫秒，再次删除一次 Cache。这样可避免并发导致的 Cache 与 DB 不一致：
* A 读，未命中缓存
* A 从 DB 读取数据，还未写回 Cache 
* B 更新 DB，删除 Cache 
* A 写回旧 Cache，和最新 DB 不一致.

#### Write Through

将 Cache 视为主要存储，所有读写请求只和 Cache 交互。DB 对应用程序透明。

该模式并不常见。因为每次写操作都要同时更新 DB + Cache。

#### Write Back

将 Cache 视为主要存储。Write Through 会同时更新 Cache + DB；而 Write Back 只更新 Cache，异步地批量更新 DB。

Write_Back 应用场景有限，因为如果 Cache 挂了就可能丢失数据。

## HotKey 处理策略

#BP #DEBUG

Redis 缓存中某个键被频繁访问。

#### 检测方法

开启 `--hotkeys` 参数，同时配置 `maxmemory-policy` 参数为 LFU 算法（剔除最不常使用键）。

#### 解决方案

解决方案：
1. 读写分离：主节点处理写，从节点处理读
2. 集群：将数据分散存储在多个 Redis 节点

## 缓存击穿问题

问题描述：对于某个 HotKey，其对应的 Redis 缓存突然过期，导致大量请求直接落到数据库上。

解决办法：
1. **数据预热**：针对可能的热点数据，提前（异步地）存入缓存，并设置较长的过期时间
2. 加锁：重复请求只有一个落在数据库上

## BigKey 问题

#DEBUG 

是指某个 K 对应的单个 V 占用内存过大，如 MB 级别的 `String`，或是元素个数超过 5000 的符合类型。BigKey 可能是未及时清理垃圾，或程序规模考虑不足导致的。

```bash
redis-cli -p 6379 --bigkeys
```

## 慢查询问题

#DEBUG 

Redis 中部分命令时 `O(n)` 复杂度：
* `KEYS *` 返回所有匹配的 keys
* `HGETALL`
* `LRANGE` 
* `SINTER` 计算多个 SET 的交集……

执行这些命令前，需要知晓 `N` 的数量级，否则采用 `SCAN` 命令批次遍历。

#### 慢查询日志

在 `redis.conf` 中配置 `slowlog-log-slower-than ...` 以及 `slowlog-max-len` 

所有执行时间超出 `slower-than` 的命令，都会被记录在 slowlog 中。

## 缓存穿透问题

问题描述：客户端请求大量不存在的 Key，既不在 Redis 缓存中，也不在数据库中。导致性能下降。

#BP 

解决办法：加无效 Key 过滤，考虑使用 [布隆过滤器](../../algo/hash-based/bloom-filter.md) 以及用于验证格式的正则表达式。
