**BGP (Border Gateway Protocol) , OSPF (Open Shortest Path First) 和 RIP (Routing Information Protocol) ** 是三种常见的路由协议, 用于在不同规模的网络中管理路由信息. 

## BGP

*边界网络协议 (Border Gateway Protocol, BGP)* 是一种*外部网关协议 (EGP)*, 用于*互联网自治系统 (AS, Autonomous System)* 之间的路由交换. 属于互联网的 "骨干协议", 用于全球范围的路由信息传递. 

BGP 使用路径矢量算法, 每条路由信息包含经过的所有自治系统列表（IP 前缀列表）. 允许管理员基于策略控制路由选择, 如考虑政府政策因素的路由控制.


## OSPF  

*开放最短路径优先协议 (Open Shortest Path First, OSPF)* 是一个**内部网关协议 (IGP)**, 在单一自治系统 (AS) 内实施路由决策, 用于企业或校园大型局域网.

每个 OSPF 路由器都保存有全网链路信息的*链路状态 (Link-State)* 数据库, 通过 [Dijkstra 算法](../../algo/graph/shortest-path.md)计算网络拓扑中最短路径. 

OSPF 步骤: (很复杂...不填)
1. OSPF 区域划分
2. OSPF 的链路状态广播
3. OSPF 建立邻居关系
4. OSPF 建立邻接关系, 同步链路状态数据库 (LSDB)
5. OSPF 定期更新链路状态, 根据 Dijkstra 算法进行路由计算.

OSPF 缺点也是：需要维护AS 内的所有路由拓扑，在比较扁平的数据中心场景可能负担很重。

## RIP 

*RIP (Routing Information Protocol)* 是早期的动态路由协议, 也是内部网关协议 (IGP) 的一种, 用于小型网络的路由更新. 

RIP 使用距离矢量算法, 基于路由跳数来选择路由路径, 最多支持 15 跳, 16 跳视为不可达. *RIP 用了 Bellman-Ford 动态规划的思想, 认为当前节点到目的地的最小距离, 等于我到邻居的距离与邻居到目的地最小距离之和的最小值 (可能有多个邻居)*

更新时间较长, 每 30 秒发送一次更新, 导致网络拓扑收敛速度较慢, 但配置简单, 适合小型网络.