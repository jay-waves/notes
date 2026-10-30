---
revised: 26-01-24
---

布隆过滤器（bloom-filter），用于在极小空间复杂度下，判断元素的存在性。提供如下接口：
* `insert(t)` 用某种不可逆的哈希函数，将 `t` 映射为 `bitset` 中某些位。
* `test(t)` 通过对比哈希，检查 `t` 是否存在。
* 不支持删除，因为哈希函数不可逆。

布隆过滤器效率类似[哈希表](hash-table.md)，但内存占用极小。常用于在实际查询前，过滤数据请求。

## insert x

设比特集合大小为 `m` 比特，初始化为零。相互独立的 `k` 个哈希函数 $h_{1}(x),h_{2}(x)\dots h_{k}(x)$ ，每个哈希都能将 `x` 均匀映射到 $\set{0,1,\dots,m-1}$ 并将对应*位*置一。

## test existence of x

计算 `x` 的哈希 $h_{1},h_{2},\dots,h_{k}$ ，如果所有对应位**皆**为一，返回 `true`；否则返回 `false`。布隆过滤器是一种概率性数据结构，当 $\set{0,1,\dots,m-1}$ 中对应位被其他元素占用，可能误报；不可能漏报。

为了降低误报率，需要保证 `m` 大小适中，同时哈希函数有足够的随机性。

### Kirsch-Mitzenmacher Method

**用两个独立函数 $h_{1},h_{2}$ ，通过 $h_{i}=h_{1}+i\ h_{2}$ 来生成 $k$ 个哈希值。** 效果与使用独立的 `k` 个哈希基本等价。该方法也被称为[*两次哈希*](hash.md)。

### parameters selection 

设：预计插入数据个数 $n$ ，目标误报率 $p$ ；假设哈希函数均匀，即比特为 `1` 概率为 $\frac{1}{m}$ 

插入 $n$ 个元素，共进行 $nk$ 次置位后，某个比特为 `1` 的概率为： 

$$1-（1-\frac{1}{m})^{kn}$$

误判率（对一个未插入元素做查询时， $k$ 个哈希映射位置恰好全为 $1$）：

$$p=\left( 1-\left( 1-\frac{1}{m} \right)^{kn} \right)^{k}$$

当 $m$ 很大时，由于：

$$\left( 1-\frac{1}{m} \right)^{m}\approx \frac{1}{e}$$

因此：

$$p\approx \left(1-e^{-nk/m}\right)^{k}$$

**[可以求导证明](https://en.wikipedia.org/wiki/Bloom_filter)（我没证），比特 `1` 的个数约占 50% 时，整体误报率足够低**。此时：

$$k=\frac{m}{n}\ln2$$

此时，误报率 $p$ 下所需的集合规模： $$m=-\frac{n\ln p}{(\ln 2)^{2}}$$

## scaling strategy 

固定 $m$ 条件下，如果 $n$ 动态增长直至空间紧张，误判率也会随之升高。

<img src="../../attach/img/algo/20260121212740701.png" alt="wiki" width="600">

固定 $m$，而 $n$ 动态增长的情况下，当旧布隆过滤器接近设计容量时，可以新开一个布隆过滤器，将此后的新元素插入新布隆过滤器。判定时，将多个布隆过滤器并联判断。

```
Bloom1 || Bloom2 || Bloom 3 || ...
```

## Cuckoo Filter 

支持删除。

见 Cuckoo filter: Practically better than bloom. [Fan, 2014] 
