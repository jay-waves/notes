
为什么用 Sorted 数据不行，必须用 B+tree ？

fan_out

* PostgreSQL / Oracle , heap files. built B+tree Alt.2 indexes on primary keys
* MySQL InnoDB. clusted Alt.1 B+tree indexed (聚簇索引), on primary keys
* SQLite. Alt.1 B+tree, on RowID (may not be primary keys)
* DuckDB, columnar storage (dsm), with ART (adaptive radix tree) + Zone Maps indexes
* RocksDB. LSM Tree
* MongoDB. JSON

