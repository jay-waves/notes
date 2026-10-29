
```
File
 ├── Header
 ├── Row Group
 │    ├── Column Chunk (ID)
 │    │    └── Pages
 │    ├── Column Chunk (Name)
 │    │    └── Pages
 │    └── Column Chunk (Age)
 │         └── Pages
 ├── ... More Row Groups
 └── Footer
      ├── Schema
      └── Row Group / Column Chunk Metadata
```

parquet 文件是自带压缩和索引的，不太适合原地修改，数据库使用 parquet 时一般会单次写入后
不再改变。Footer (元数据) 放在文件末尾就是为了不返回回头修改，直接流式一次性写入。

Parquet 文件的目标就是列式存储，并高效读取与压缩。

元数据包括：
* `RowGroup[]` 
    * `total_byte_size`, `num_rows`
    * `ColumnChunks[]`: `file_offset, ocdec, encodings[], statistics, page_offset`
* `Schema` 
    * `type, num_hcildren, physical_type`

对于查询优化，Statistics 非常有用，每个 `CloumnChunks` 都记录 `min`, `max`, `null_count` 等统计值，
加速 SQL 查询引擎。

## Pages 

Pages 进行实际的数据压缩和编码，定义如下：

```
Pages 
 ├── Repetition Levels ──> Same list or new record?
 ├── Definition Levels ──> Null? Empty? Actual value?
 └── Encoded Data Values
```

Parquet 的一个 Column 允许嵌套数据，即，允许数组、结构体、字典。

```
Entry    Value     DL    RL
-----    -----     --    --
  1      "red"      3     0
  2      "blue"     3     1
  3      "green"    3     0
  4      (none)     1     0
  5      (none)     0     0
  6      (none)     2     0
  7      "gold"     3     1
```

可以恢复为：

```
Row 1: ["red", "blue"]
Row 2: ["green"]
Row 3: []
Row 4: null
Row 5: [null, "gold"]
```

如果 "red" 字符串同时出现在多个 ColumnChunks 中，还会有全局的字典压缩 `(value, cnt)`. 
