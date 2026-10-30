
[Lamport, 1978]

## Happens-Before

How to Make a Multiprocessor Computer That Correctly Executes Multiprocess Programs. (Lamport, 1979) 引入了事件偏序关系 (sequential consistency):

> The customary approach to designing and proving the correctness of multiprocess algorithms for such a computer assumes that the following condition is satisfied: the result of any execution is the same as if the operations of all the processors were executed in some sequential order, and the operations of each individual processor appear in this sequence in the order specified by its program. A multiprocessor satisfying this condition will be called _sequentially consistent_.

Time, Clocks, and the Ordering of Events in a Distributed System. Lamport. 1978. 引入了基于偏序的竞争检查算法.

- **并发执行是受通信事件决定的偏序关系, 而程序无法观察无通信事件的并发事件顺序**
- 如果所有互斥访问可以被线性排序 -> 无数据竞争执行
- 如果存在互斥访问不能被排序 -> 可能存在数据竞争

<img src="../../../attach/img/sec/happens-before-ordering.avif" alt="" width="300">

### Algorithm

事件偏序关系检测算法: 通过节点通信维护全局时钟.
```go
// assume N processes in system
const int N = ...;

func initialize_vector_clocks() {
    for each process P
        vector_clock[P] = int[N]
        for i from 0 to N-1
            vector_clock[P][i] = 0
}

// observer has no idea about order of local event in different threads.
func on_local_event(process P) {
    vector_clock[P][P] += 1
}

// observer can only infer order by communication event.
func on_send_message(process P, message M) {
    vector_clock[P][P] += 1
    M.vector_clock = vector_clock[P]
    send(M) // broadcast local clock
}

func on_receive_message(process P, message M) {
    vector_clock[P][P] += 1
    for i from 0 to N-1
        vector_clock[P][i] = max(vector_clock[P][i], M.vector_clock[i])
}

func compare_vector_clocks(clock A, clock B) {
    let A_before_B = true
    let B_before_A = true
    for i from 0 to N-1
        if A[i] > B[i]
            B_before_A = false
        if B[i] > A[i]
            A_before_B = false
    
    if A_before_B and not B_before_A
        report "A happens-before B"
    else if B_before_A and not A_before_B
        report "B happens-before A"
    else
        report "A and B are concurrent"
}
```

共享数据 `x` 竞争检测算法:
```go
// continue...
func is_concrr(clock A, clock B) {
	if compare_vector_clocks(A, B)=="A and B are concurrent"
		return true
	else
		return false
}

// During a write operation on variable x
func on_write(x, clock W) {
    if is_concrr(W, x.last_write_clock)
        report "write-write race"
        
    x.last_write_clock = W
    x.concurrent_read_clocks.clear()
}

// During a read operation on variable x
func on_read_start(x, clock R) {
    if is_concrr(R, x.last_write_clock)
        for read_clock in x.concurrent_read_clocks
            if is_concrr(R, read_clock) // observer more than one
                report "read-write race"
                break
                
    x.concurrent_read_clocks.add(R)
}

// When a read operation finishes
func on_read_end(x, clock R) {
    x.concurrent_read_clocks.remove(R)
}
```

- Slowdown > 50x
- Memory Overhead!
- Improved in [FastTrack](FastTrack.md)

## Vector Clocks

 Virtual time and global states of distributed systems -- Mattern 1998


## FastTrack: efficient and precise dynamic race detection

[Flanagan, 2009]

- [eraser](eraser.md): low cost, low precision
- [happens before](happens-before.md): high cost, high precision
- FastTrack: low cost, high precision

FastTrack: Efficient and Precise Dynamic Race Detection. 是对 [Happens Before (HB)](happens-before.md) 算法的高效实现, 仍是基于逻辑时钟 (Vector Clock 在 FastTrack 中被称为 Epoch). 
- sound & complete: 尽快地在每个变量上发现至少一个数据竞争.
- effcient
- Insight:
	1. Happens-Before 是一种偏序关系.
	2. 但对变量的访问几乎全是有序的.

### Algorithm

为每个线程 `T` 维护一个整型时钟 `c[T]`, `Epoch=(T, c[T])` 来标识逻辑时刻.

对于每个共享内存变量 `X`, 维护其最后一次写入的 Epoch, 以及读者合集 readerEpochs. 只在必要时刻使用完整 vector clock 操作.

### 是否并发?

如何判断两个 Epoch 是否并发? 并发, 当且仅当, 不存在发生序关系. 

对于 `E1 = id1@t1` 和 `E2 = id2@t2`, 满足以下任一条件, 称为 E1 happens before E2 (`E1 -> E2`)
1. t1 < t2, 且 E1 执行在 E2 开始前完成.
2. id1 的优先级高于 id2, 且 e1 在 e2 之前触发.
3. E1 发生在中断被禁用的时间内, E2 发生在中断之后.

如果 `E1->E2` 和 `E2->E1` 都不成立, 两个 Epoch 就是并发的.

### 是否竞争?

如果两个 Epoch 是并发的, 需要进一步判断两者是否存在竞争. 竞争的必要条件是
两个并发事件访问同一共享资源, 至少一个是写操作, 且没有同步机制保护.

对于 E1 和 E2, 检查如下条件:
1. E1 和 E2 访问同一资源 (内存地址, 寄存器)
2. 访问类型冲突:
	- E1 写, E2 写
	- E1 写, E2 读
	- E1 读, E2 写
3. 没有锁 / 中断禁用 等机制来同步.