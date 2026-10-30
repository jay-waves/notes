[storage](storage.md)一览 (2020)

| 存储器      | 硬件介质  | 单位成本 `$/MB` | 随机访问时延        | 常规体积 |
| ----------------- | --------- | --------------- | ------------------- | -------- |
| L1 Cache          | SRAM      | 7               | 1 ns  (1 GHz)       | 32 KB    |
| L2 Cache          | SRAM      | 7               | 4 ns                | 256 KB   |
| L3 Cache          | SRAM      | 7               | 20 ns               | 4 MB     |
| Memoery           | DRAM      | 0.015           | 100 ns              | 8 GB     |
| Disk              | SSD (NAN) | 0.0004          | 150 us        | 256 GB   |
| Disk              | HDD       | 0.00004         | 10 ms               |          |
| CPU               |           |                 | 5.6 GHz (i9-13900k) |          |

<img src="../../attach/img/hw/dram-ssd-hhd-history.webp">

计算机操作延迟一览 (2020) [^1]

| 存储器操作                            | 访问时延 (ns) | 访问时延 (us) | 访问时延 (ms) | 说明                        |
| ------------------------------------- | ------------- | ------------- | ------------- | --------------------------- |
| L1 cache reference                    | 0.5           |               |               |                             |
| Branch mispredict                     | 5             |               |               |                             |
| L2 cache reference                    | 7             |               |               | 14x L1 cache                |
| Mutex lock/unlock                     | 25            |               |               |                             |
| Main memory reference                 | 100           |               |               | 20x L2 cache, 200x L1 cache |
| Compress 1KB with Zippy          | 3,000         | 3             |               |                             |
| Send 1KB over 1Gbps network      | 10,000        | 10            |               |                             |
| Read 4KB randomly from SSD             | 150,000       | 150           |               | ~1GB/sec SDD                |
| Read 1MB sequentially from memory     | 250,000       | 250           |               |                             |
| Round trip within same datacenter[^2]     | 5000,000      | 500           |               |                             |
| Read 1MB sequentially from SSD        | 1,000,000     | 1,000         | 1             | ~1GB/sec SSD, 4x memory     |
| Disk seek                             | 10,000,000    | 10,000        | 10            | 20x datacenter roundtrip    |
| Read 1MB sequentially from disk (HDD) | 20,000,000    | 20,000        | 20            | 20x SSD, 80x memory         |
| Send packet CA->Netherlands->CA       | 150,000,000   | 150,000       | 150              |                             |

## 高速缓存

CPU 频率每年增长 60%, 而内存每年增长 7%, 两者访问性能差距逐年拉大. 为了提高 CPU 访问内存数据的速度, 在主存和 CPU 间增加了 Cache, 也称为高速缓存.

| 缓存   | 索引                           | 描述                    |
| ------ | ------------------------------ | ----------------------- |
| L1 D-Cache | `/sys/d/s/cpu/c0/cache/i0` | 数据缓存, 位于 cpu 内部 |
| L1 I-Cache  | `/sys/d/s/cpu/c0/cache/i1` | 指令缓存, 位于 cpu 内部 |
| L2 Cache    | `/sys/d/s/cpu/c0/cache/i2` | 单核心独有              |
| L3 Cache   | `/sys/d/s/cpu/c0/cache/i3` | 多核心共享                        |

缓存命中率越高, 代码性能越好. CPU 基于*预测*来决定哪些数据和指令提前缓存入 Cache, *预测*则基于程序的局部性. 时间局部性指最近访问的数据容易被再次访问, 空间局部性指和当前数据在内存中连续的其他数据容易被访问.

### 提高数据缓存命中率

访问数据时, CPU 会缓存入内存中临近的其他数据. 此时对内存连续访问, 缓存命中率就高, 程序性能好. 若反而跳转到其他部分内存, 缓存未命中, CPU 需要额外步骤来重新从内存中获取数据. 详见 [内存管理/分页技术](../../System/Memory/分页技术.md). 

```c
/* multiply matrix A and B -> C */
for (i = 0; i < N; i++)
	for (j = 0; j < N; j++) {
		C[i][j] = 0.0;
		for (k = 0; k < N; k++) // bad for visiting B's memory
			C[i][j] += A[i][k] * B[k][j];
	}

for (i = 0; i < N; i++)
	for (k = 0; k < N; k++) {
		double temp = A[i][k];
		for (j = 0; j < N; j++) // good, i-k-j
			C[i][j] += temp * B[k][j];
	}

// 另外, 使用分块法计算大矩阵乘法, 也能充分利用缓存.
```

Bjarne Stroustrup 建议使用 `vector` 而不是 `linked list`, 也是因为链表对数据缓存的利用很差. 详见 [链表 vs 数组](../../algo/linked-list/prefer-array-to-linked-list.md)

### 提高指令缓存命中率

```c
int arr[N];
random_arr(&arr);

// case1: check after sort
sort(arr, arr+N);
for (i = 0; i < N; i++) 
	if (arr[i] < 50)
		arr[i] = 0;

// case2: sort after check
for (i = 0; i < N; i++) 
	if (arr[i] < 50)
		arr[i] = 0;
sort(arr, arr+N);
```

由于 CPU 有分支预测功能, case1 更有规律性, 整体执行速度会比 case2 更快. 编译器为分支预测相关功能提供了宏:

```c
#define likely(x) __builtin_expect(!!(x), 1)
#define unlikely(x) __builtin_expect(!!(x), 0)

if (likely(a == 1))
	...
```

## 主存与缓存的地址映射

### 直接映射

### 全相联映射

full accociate , 每个主存块映射到 cache 任意行

### 组相联映射 

set associate, 每个主存块映射到 cache 的固定组的任意行中.

### 高速缓存替换算法

- 随机替换
- LRU: 最不常使用算法.
- LFU: 最近最少使用算法. 

### 缓存与主存的同步算法

- 写回, write bakc, copy back. 只有当此行被换出时, 才将修改写回主存.
- 全写, write through. 缓存命中时, 先修改缓存, 再同步至主存.
- write around. 同时修改缓存和主存.

## Reference

https://gist.github.com/jboner/2841832

https://tldp.org/LDP/tlk/mm/memory.html

https://colin-scott.github.io/personal_website/research/interactive_latency.html

https://github.com/sirupsen/napkin-math

[^1]: 参考 https://gist.github.com/jboner/2841832 及其他源. 详见 [computer-ops-latencies](../../os/ops-latencies.md)

[^2]: 本地局域网延迟大概为 0.1~1 ms, 无认证访问本地数据中心, 数据中心的热点数据直接缓存在内存中 (如 Redis 技术).
