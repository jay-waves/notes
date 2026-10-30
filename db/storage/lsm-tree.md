[bloom-filter](../../algo/hash-based/bloom-filter.md)

#TODO 

## WAL 

Write-ahead logging appends changes to a durable log before applying them to the data store to guarantee crash recovery and prevent partial writes from corrupting state.

## CheckPoint 

## Log-Structured Merge Tree 

[lsm-tree ascii chart](../../attach/ascii/lsm-tree.md)

LSM Tre is tiered, write-optimized data structure that organizes *key-value* pairs in multiple components, residing partly in memory and partly on disk.
* Each Level of LSM-Tree is tuned to the characteristics of its underlying storage medium
* Data is efficiently migrate across media in *rolling write batches*, using an algorithm reminiscent of [merge sort](../../algo/sort/merge-sort.md)
* Component is maintained as an *append-only sequence*, so new records and updates are written sequentially rather than issuing costly random writes to persistent media. 


### MemTable 

*MemTable, the in-memory component*, absorbs incoming udpates. When it fills, it is flushed to a table on disk, creating an *immutable sorted strings table (SSTable)* file. Successive tables accumulate at level 0 until a background compaction thread merges them into the next level. Each level is larger than the one above by a configurable fan-out factor. 

Dozens of overlapping SSTables must be merges, rewritten and re-indexed, which means one record might be rewritten 3~10 times before it settles in coldest level.

The tree never overwirtes data in place, the design vaoids read-modify-write penaltis inherent in traditional B-Tree systems and scales on SSD or HHD.

### SSTable 

SSTable Compaction (in background):
* Leveling: L0 --> L1 --> L2.. . SSTables are **non-verlapping in key ranges within a level, but different levels can overlap with each other**. 
* Tiering: merge little tables into fewer large ones.

### Trade-Off

*Read Amplification* : A point lookup in LSM Tree may need to check multiple SSTables across multiple levels with many unnecessary disk reads. Hence, [Bloom Filter](../../algo/hash-based/bloom-filter.md) is introduced to check whether the key is present in this SSTable. Although Bloom Filter accelerate the point lookup, ranges lookup still suffers.

Best suited for: 
* **Write-Heavy** systems, and **Random Writes are expensive**.
* tolerant potentially read latency and complex background gc 

## Reference 

* 1996 -- O'Neil -- The Log-Structured Merge-Tree (LSM-Tree)
* [2023 -- fackbook -- RocksDB Overview](https://github.com/facebook/rocksdb/wiki/RocksDB-Overview)
* https://totoro-jam.github.io/battle-tested-patterns/zh/patterns/lsm-tree/