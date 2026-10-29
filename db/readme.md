
## DBMS

Database Management Systems (DBMS): 

* Data Modeling & Design
    * Normalization 
    * Relational Agebra
    * Data Dependencies
    * Tables (Schema)
* SQL (Query Languages)
    * CRUD (create, read, update, delte)
    * Key and constraints
* Query Processing 
* Storage & Indexing 
* Transactions & Concurrency & Recovery

Data Processing:
* OLTP (Online Transaction Processing):   
    user facing transactions, realtime, low latency, high-concurrency ( often CRUD small amounts of data)
* OLAP (Online Analytical Processing):   
    decision support, batch and complex analytical queries (ad hoc. full table scans and large data query)
* Vectors

## Data-Intensive Program

数据密集型程序：

* databases：存储数据
* caches：缓存中间结果
* search indexes：数据索引
* stream & batch processing：异步地、批量地 处理数据流

常见数据系统架构：

<img src="../assets/db/ddis-f1-1.avif" alt="ddis-f1-1" width="500">

## Data (Storage) Models 

其他常见的数据存储与交换格式：
* `*.sqlite, *.db` 各类 DBMS 的独占格式，存储关系型数据，一般按行存储 (row-oriented)。
* `*.parquet` 按列存储 (column-oriented), 也适用关系型数据库，针对 OLAP 场景
* `*.yaml, *.json` Self-Contained, Scheme-less. 存储文档型数据，信息局部性最好，文本，树形。 
* `*.xml` 文本，复杂树形
* `*.csv`, `*.excel` 文本
* Graph-based (图数据库)

### Row-oriented Storage

```
+-----------------------------------+
| Row 1: | ID=1 | Name=Alice | Age=25 |
| Row 2: | ID=2 | Name=Bob   | Age=30 |
| Row 3: | ID=3 | Name=Carol | Age=28 |
+-----------------------------------+

Physical layout:
[1, Alice, 25] [2, Bob, 30] [3, Carol, 28]
```

### Column-oriented Storage

```
+-----------------------------------+
| ID:   | 1     | 2   | 3     |
| Name: | Alice | Bob | Carol |
| Age:  | 25    | 30  | 28    |
+-----------------------------------+

Physical layout:
[1, 2, 3] [Alice, Bob, Carol] [25, 30, 28]
 <-- ID -->  <---- Name ---->  <-- Age -->
```

### JSON 

```json
{
	"key" : "value",
	"list" : [],
	"dict" : {}
}
```

### Graph-Based 

当多对多关系复杂时，单次查询就需要多个 JOIN 语句，SQL 需要缓存大量索引来解决性能瓶颈。此时可以使用 Graph-based Data Models，更利于信息遍历和存储“关系”。[邻接表图](../../algo/graph/readme.md)，可用两个关系表表示（节点表和边表），如下：

```sql
CREATE TABLE vertices (
	vertex_id  integer PRIMARY KEY,
	label      text,
	properties jsonb
);

CREATE TABLE edges (
	edge_id     integer PRIMARY KEY,
	tail_vertex integer REFERENCES vertices (vertex_id),
	head_vertex integer REFERENCES vertices (vertex_id),
	label       text,
	properties  jsonb
);

CREATE INDEX edges_tails ON edges (tail_vertex);
CREATE INDEX edges_heads ON edges (head_vertex);
```

以 Neo4j 图数据库的 Cypher 查询语言为例：

```cypher
CREATE
(namerica  :Location {name:'North America', type:'continent'}),
(usa       :Location {name:'United States', type:'country'}),
(idaho     :Location {name:'Idaho',         type:'state'}),
(lucy      :Person {name:'Lucy'}),
(idaho) -[:WITHIN]->  (usa)   -[:WITHIN]-> (namerica),
(lucy)  -[:BORN_IN]-> (idaho)
```

```cypher
MATCH
(person) -[:BORN_IN]->  () -[:WITHIN*0..]-> (:Location {name:'United States'}),
(person) -[:LIVES_IN]-> () -[:WITHIN*0..]-> (:Location {name:'Europe'})
RETURN person.name
```

## 参考

*Designing Data-Intensive Applications*. Martin Kleppmann. 2017. 1e.

https://github.com/ByteByteGoHq/system-design-101

https://aosabook.org/en/v2/zeromq.html

https://aosabook.org/en/posa/high-performance-networking-in-chrome.html

Open-MX-IOAT.pdf

https://aosabook.org/en/posa/secrets-of-mobile-network-performance.html

https://aosabook.org/en/posa/warp.html

[The Architecture of Open Source Applications (Volume 2)
Scalable Web Architecture and Distributed Systems](https://aosabook.org/en/v2/distsys.html)
