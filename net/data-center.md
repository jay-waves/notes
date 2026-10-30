
Over-subscription: total allocated or promised resources exceed the actual available capacity. providers oversubscribe bandwidt because it's unlikely that all users will consume their maximum bandwidth simultaneously.

数据中心优化的原则：
* 减少过订阅，在极端情况下能尽量满速。
* scale-out better than scale-up. 升级昂贵的高速交换机，不如规模化低成本交换机，网络规模线性增长。
* 提供等价路径 (Equal-Cost Paths, ECMP) 减少单路径热点瓶颈
* 容错和路由错误排查

## Legacy DCN 

<img src="../attach/img/net/legacy-data-center-network.avif" alt="" width="500">

经典树状 DCN ，分为三层：
1. Access Layer. A group of hosts(mostly 16/32) is connected to one switch, called ToR switch (Top of Rack)
2. Aggregation (Dsitrbution) Layer. uses high-end switches aggregating the traffic 
3. Core Layer 

Core (L3) ----> Aggregation (L3 + L2) ----> Access (L2) 

Access-Aggr-Core 网络中，Access 承担 VLAN 划分和二层转发，Aggregation 负责 VLAN 间路由、网关、东西向防火墙功能。Aggr 是有 L3 能力的交换机，和 Access 层通过 L2 交换，和 Core 层通过 L3 交换。跨 VLAN 的服务器间通信（东西向流量）需要 Aggr Switch 甚至 Core Switch 参与。

由于 VLAN 可能跨多个 Access 交换机，需要 STP (spanning tree protocol) 来避免 L2 环路：如 ARP、DHCP 等广播帧没有 TTL，一旦 L2 存在环路，就会形成广播风暴。

Leaf-Spine (见下) 采用了更扁平的设计，Leaf 交换机和 Spine 交换机都是 L3 交换机，Leaf 交换机连接服务器，Spine 交换机连接所有 Leaf，在所有 Leaf 间形成等价路由路径（ECMP）。Leaf-Spine 间采用三层 IP 链路，无需大规模的 L2 广播域（STP + ARP），直接由 [IP Routing 协议](network-l3/routing.md) 计算路由路径。流量也不需要某些单点瓶颈的设备（核心交换机、汇聚交换机）转发。

## Clos-based

### Spine-Leaf

Spine-Leaf 的优势是扩展方便。

虽然 Leaf 数量受限于 Spine 端口数量，但是在规模限制内，接入 Leaf 和 Spine 都很方便，无需重新设计网络的层级规划。主机也扁平地挂在 Leaf 下，一般直接用 Leaf 作为 ToR (Top-of-Rack) 设备，同时兼顾 L2 和 L3 职责。

[source](https://www.corning.com/data-center/worldwide/en/home/solutions/spine-and-leaf-architecture-101.html)

|     |     |
| --- | --- |
| <img src="../attach/img/net/leaf-spine1.webp" width="200"> | Each Leaf is connected to every Spine |
| <img src="../attach/img/net/leaf-spine2.webp" width="200"> |  Spines <br> 4 Line Cards * 36 Ports per Line Card * 100G Port |
| <img src="../attach/img/net/leaf-spine3.webp" width="200"> | Leaf's Uplink Ports to Spine Switches <br> 4 * 100G uplink ports  |
| <img src="../attach/img/net/leaf-spine4.webp" width="200"> | Leaf's Donwloink Ports to End-Devices <br> 48 * 25G downlink ports (to the Servers)  |

* 每个 Leaf 交换机需要连接所有 Spine 交换机，但是同类设备彼此间不需要连接。
* Spine 的端口数量决定了 Leaf 的最大数量
* Leaf 的上行端口（uplink）数量决定了 Spine 的最大数量
* Leaf 的下行端口（downlink）数量 $\times$ 超卖率（oversubscription），决定了终端的最大数量

### Goolge Fat Tree 

<img src="../attach/img/net/google-fat-tree-topo.avif" alt="" width="500">

Fat Tree 提供更多的并行链路，让上层的总带宽变胖，从而避免 Over-Subscription.

### Facebook Fat Tree 

## BCube 

<img src="../attach/img/net/bcube-data-center-topo.avif" alt="" width="400">

BCube 是递归结构，设每个交换机端口数为 $n$ ，每台服务器需要 $k$ 个 NIC 网卡，网卡 $i$ 对应 $BCube_{i}$ 层内的 $i$ 交换机（同层跨集群计数）。$BCube_{0}$ 有一个交换机，星型拓扑连接 $n$ 个服务器，编号分别为 $1\dots n$ 

$BCube_{k}$ 层有 $k$ 个交换机，有 n 个 $BCube_{k-1}$ 子集群。$BCube_{k}$ 层第 $k$ 个交换机的第 $i$ 个网口，连接第 $i$ 个 $BCube_{k-1}$ 集群的第 $k$ 个主机。

$k$ 个网卡的服务器，配 $n$ 个端口交换机，最多在网络中容纳 $n^{k}$ 个主机。

BCube 设计中，由服务器决定转发路径。一个服务器有 K+1 个网卡（或 L2 交换机），服务器和路径中间服务器共同决定转发路径。因此，BCube 是 *Server-Centric* 架构。


## 参考

综述 [Lebiednik, 2016]

文章: 
- [Singh, 2015]. jupiter rising, a decade of Clos Topologies and Centralized Control in google's DAtaCenter Network. Goolge.
- [Greenberg, 2009]. VL2, a scalable and flexible Data Center Network. Microsoft.
