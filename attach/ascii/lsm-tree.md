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