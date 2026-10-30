## 网络加密方式

在链路加密中, 报文完全加密, 每个节点收到加密报文后, 先(用和上一跳共享的密钥)解密以查看路由下一跳节点, 然后(用和下一跳共享的密钥)加密以转发给下一跳节点. 链路加密中每两个节点直接有独立的加密密钥. 在端到端加密中, 报文仅载荷部分加密, 路由部分 (报头部分) 以明文传输, 每个中转节点仅查看报头来决定下一跳节点. 负责加密的只有一次报文传输的收发两端, 网络中节点只负责路由转发.

链路加密的节点是一个泛化概念, 可以指: 路由器, 交换机, 一个小型公司网络. 报文先由节点中的专用密码机解密, 然后传递给路由设备修改路由 (修改 MAC 地址), 再交由密码机加密, 节点内部中消息是明文的. 如果加密解密仅由节点中一个安全模块负责, 在节点内部仍是加密传输, 被称为*节点加密*, 节点加密通常也要求报头 (路由信息) 以明文传输. 

洋葱加密 (The Onion Routing, Tor) 使用多层加密技术, 在端到端加密的同时隐藏路由细节. 发送者选择一条路由路径, 然后用和路径上每个节点的共享密钥对数据包和路由信息进行多层加密: `{ { {A}_ka, B}_kb, C}_kc`. 当数据包经过节点 C 时, 它仅能解密出局部路由信息 `C`, 其中包含该包的去向节点. 也就是说, 中继节点仅能直到节点的上一跳来源和下一跳去向, 而无法追踪数据的完整路由 (实际来源和最终目的). 当路径中较多节点被攻击者控制时, 洋葱路由的路由保密性易受标记攻击和时序攻击的影响.

|                  | 链路加密                | 端到端加密       | 洋葱加密                 |
| ---------------- | ----------------------- | ---------------- | ------------------------ |
| 加密             | 中继节点和收发端负责            | 仅收发端负责     | 仅收发端负责                         |
| 密钥分配         | 中继节点间各自共享密钥    | 收发端间共享密钥 | 发送端和各个中继节点共享密钥 |
| 路由路径选择     | 网络自动选择            | 网络自动选择     | 用户选择                 |
| 中继节点所知     | 完整路由信息 + 数据载荷 | 完整路由信息     | 仅上一跳以及下一跳路由信息 |


```
Now datagram on Node2:

Link Encryption:  

| hop1: Node1 --> Node2 |  <- encrypted with K_{Node1, Node2}, decrypted by Node2
| hop2: Node2 --> Node3 |  <- encrypted with K_{Node1, Node2}, decrypted by Node2
| hop3: Node3 --> Node4 |  <- encrypted with K_{Node1, Node2}, decrypted by Node2
|      Data Payload     |  <- encrypted with K_{Node1, Node2}, decrypted by Node2

, then Node2 will encrypt datagram with K_{Node2, Node3}

E2EE: 

| hop1: Node1 --> Node2 |  
| hop2: Node2 --> Node3 |
| hop3: Node3 --> Node4 |
|      Data Payload     |  <- encrypted with K_{Node1, Node4}


Tor: 

| hop2: Node2 --> Node3 |  <- encrypted with K_{Node1, Node2}, decrypted by Node2, stripped off by Node2
| hop3: Node3 --> Node4 |  <- encrypted with K_{Node1, Node3}
|      Data Payload     |  <- encrypted with K_{Node1, Node4}
```

共享的密钥数量越多, 意味着密钥同步的次数越频繁. 为削减成本和隐藏网络细节, 端到端加密被更广泛地应用.

[RFC4949, 2007] 中对流量保密性的描述:

> However, operational considerations can make TFC
>       difficult to achieve. For example, if Alice sends a product idea
>       to Bob in an email message, she wants data confidentiality for the
>       message's content, and she might also want to conceal the
>       destination of the message to hide Bob's identity from her
>       competitors. However, the identity of the intended recipient, or
>       at least a network address for that recipient, needs to be made
>       available to the mail system. Thus, complex forwarding schemes may
>       be needed to conceal the ultimate destination as the message
>       travels through the open Internet (see: onion routing).
> 
> A [TFC](../../sec/README.md) service can be either full or partial:
>       -  "Full TFC": This type of service conceals all traffic
>          characteristics.
>       -  "Partial TFC": This type of service either (a) conceals some
>          but not all of the characteristics or (b) does not completely
>          conceal some characteristic.
> 
> On point-to-point data links, full TFC can be provided by
>       enciphering all PDUs and also generating a continuous, random data
>       stream to seamlessly fill all gaps between PDUs. To a wiretapper,
>       the link then appears to be carrying an unbroken stream of
>       enciphered data. In other cases -- including on a shared or
>       broadcast medium, or end-to-end in a network -- only partial TFC
>       is possible, and that may require a combination of techniques. For
>       example, a LAN that uses "carrier sense multiple access with
>       collision detection" (CSMA/CD; a.k.a. "listen while talk") to
>       control access to the medium, relies on detecting intervals of
>       silence, which prevents using full TFC. Partial TFC can be
>       provided on that LAN by measures such as adding spurious PDUs,
>       padding PDUs to a constant size, or enciphering addresses just
>       above the Physical Layer; but these measures reduce the efficiency
>       with which the LAN can carry traffic. At higher protocol layers,
>       SDUs can be protected, but addresses and other items of PCI must
>       be visible at the layers below.


