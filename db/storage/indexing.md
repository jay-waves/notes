
Query shape | Row store | Column store 
------|-------------|------
Point lookup by k | B+tree | ART on the key, or zoone maps (min-max) if sorted
Range on a key | B+tree | zone maps if sorted
Equality on a low-cardinality column | | dictonary encoding + bitmap
Full scan and aggregate | no index helps; scan | vectorised columnar scan 
Write-heavy inserts | LSM engine (batching) | append new files, compact later |


PostgreSQL Index： 

| Index types | |
---|----
B-tree | `<, =, >`
Hash | `=`
GIN | 倒排索引。用于包含关系
GiST / SP-GiST | 范围关系、相似度
GRIN | 轻量摘要（统计数据）

## Clusted Index (聚簇索引)

MySQL InnoDB 持续维护聚簇索引，写入时位数数据顺序 (sorted)

## BRIN

## Learned CDF

## GIST / SP-GIST

## PGVector (HNSW / IVFFlat)
