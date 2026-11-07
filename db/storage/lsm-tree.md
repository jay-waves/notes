[bloom-filter](../../algo/hash-based/bloom-filter.md)

#TODO 

## WAL 

Write-ahead logging appends changes to a durable log before applying them to the data store to 
guarantee crash recovery and prevent partial writes from corrupting state.

## CheckPoint 

## Log-Structured Merge Tree 

```ascii
                             MEMORY
--------------------------------------------------------------------------------

      writes
        |
        v
+----------------+        full         +----------------------+
|   MemTable     | ------------------> | Immutable MemTable   |
|   mutable      |                     | frozen, read-only    |
+----------------+                     +----------+-----------+
                                                  |
                                                  | flush
                                                  v

                         PERSISTENT STORAGE
--------------------------------------------------------------------------------

+------------------+                     +----------------------+
| WAL              |                     | Metadata / Manifest  |
| write-ahead log  |                     | version metadata     |
+------------------+                     +----------------------+
        |                                      |
        | recovery                             | tracks:
        |                                      | - SSTables
        |                                      | - level layout
        |                                      | - file add/delete
        |                                      | - checkpoints
        v                                      v

                     +--------------------------------------+
                     |               SSTables               |
                     |        immutable sorted files        |
                     +--------------------------------------+

Level 0: +----------+   +----------+   +----------+
         | SSTable  |   | SSTable  |   | SSTable  |
         +----------+   +----------+   +----------+
         newest flushed SSTables; key ranges may overlap

                   |
                   | compaction
                   v

Level 1: +----------+   +----------+   +----------+
         | SSTable  |   | SSTable  |   | SSTable  |
         +----------+   +----------+   +----------+
         older SSTables; usually non-overlapping key ranges

                   |
                   | compaction
                   v

Level 2: +----------+   +----------+   +----------+   +----------+
         | SSTable  |   | SSTable  |   | SSTable  |   | SSTable  |
         +----------+   +----------+   +----------+   +----------+

                   |
                   v

Level N: +----------+   +----------+   +----------+   +----------+   +----------+
         | SSTable  |   | SSTable  |   | SSTable  |   | SSTable  |   | SSTable  |
         +----------+   +----------+   +----------+   +----------+   +----------+
```

LSM Tre is tiered, write-optimized data structure that organizes *key-value* pairs in multiple 
components, residing partly in memory and partly on disk.
* Each Level of LSM-Tree is tuned to the characteristics of its underlying storage medium
* Data is efficiently migrate across media in *rolling write batches*, using an algorithm 
    reminiscent of [merge sort](../../algo/sort/merge-sort.md)
* Component is maintained as an *append-only sequence*, so new records and updates are written 
    sequentially rather than issuing costly random writes to persistent media. 

### MemTable 

*MemTable, the in-memory component*, absorbs incoming udpates. When it fills, it is flushed to a 
table on disk, creating an *immutable sorted strings table (SSTable)* file. Successive tables 
accumulate at level 0 until a background compaction thread merges them into the next level. Each 
level is larger than the one above by a configurable fan-out factor. 

Dozens of overlapping SSTables must be merges, rewritten and re-indexed, which means one record 
might be rewritten 3~10 times before it settles in coldest level.

> 跨层：数据膨胀到体积限制，从 L1 合并到 L2、再到 L3 
> 同层：数据在 L1，如果 L0 下沉的新数据，与其所在 SSTable 有范围重叠，两者会合并并直接重写该文件。

The tree never overwirtes data in place, the design vaoids read-modify-write penaltis inherent in 
traditional B-Tree systems and scales on SSD or HHD.

### SSTable 

SSTable Compaction (in background):
* Leveling: L0 --> L1 --> L2.. . SSTables are **non-verlapping in key ranges within a level, but 
    different levels can overlap with each other**. 
* Tiering: merge little tables into fewer large ones.

### Trade-Off

*Read Amplification* : A point lookup in LSM Tree may need to check multiple SSTables across 
multiple levels with many unnecessary disk reads. Hence, [Bloom Filter](../../algo/hash-based/bloom-filter.md) 
is introduced to check whether the key is present in this SSTable. Although Bloom Filter accelerate 
the point lookup, ranges lookup still suffers.

Best suited for: 
* **Write-Heavy** systems, and **Random Writes are expensive**.
* tolerant potentially read latency and complex background gc 

## Reference 

* 1996 -- O'Neil -- The Log-Structured Merge-Tree (LSM-Tree)
* [2023 -- fackbook -- RocksDB Overview](https://github.com/facebook/rocksdb/wiki/RocksDB-Overview)
* https://totoro-jam.github.io/battle-tested-patterns/zh/patterns/lsm-tree/
