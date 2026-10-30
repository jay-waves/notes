---
revised: 24-11-29
---

当且仅当两个计算机的性能达到同一级别时, 安全才是值得考虑的事项. 如果一个计算机不能对另一个计算机进行大致模拟, 就不可能利用另一个计算机的安全漏洞.

安全是一个很宽泛的名词, 宏观上, 攻击者旨在破坏某些[安全属性](../readme.md); 微观上, 则是通过各种手段对信息系统的方方面面进行攻击. 从技术层面来看, 有: 网络安全, 应用安全, 系统安全, 物理安全. 从漏洞利用时机来看, 在设计阶段, 实现阶段, 部署阶段都可能存在安全隐患. 从攻击方式来看, 有拒绝服务类, 注入攻击类, 旁路攻击类, 权限提升类等, 以下主要从不同攻击方式介绍安全漏洞.


# 1. 网络安全

| 网络层             | 网络攻击                                                                          |
| ------------------ | --------------------------------------------------------------------------------- |
| Application Layer  | SQL Injection </br> Cross-Site Scripting (XSS) </br> DDos attacks                 |
| Presentation Layer | Character Encoding Attacks </br> SSL Striping </br> Data Compression Manipulation |
| Session Layer      | Session replay </br> Session fixation attacks </br> Man-in-the-middle attacks     |
| Transport Layer    | UDP flood </br> SYN flood                                                         |
| Network Layer      | IP spoofing </br> Route table manipulation </br> Smurf attack                     |
| Data Link Layer    | MAC address spoofing </br> ARP spoofing </br> Switch flooding                     |
| Physical Layer     | Eavesdropping/Tapping </br> Jamming </br> Physical tampering </br> Energy Depletion Attack                                                                             |

## 1.1 DoS

**攻击类型:**
- Syn Flood: 发送大量 [TCP SYN](../net/transport-l4/TCP.md) 报文, 使服务器建立大量半连接状态, 耗尽服务资源. 防御技术为 SYN Cookie, 收到 SYN 报文后, 不建立连接, 而是将头部内容的散列值当作序列号放入 SYN ACK 报文中返回, 之后收到含正确响应编号的 ACK 报文后, 才正式建立连接.
- [ICMP](../net/network-l3/ICMP.md) Flood: 也叫 Ping Flood, 发送大量 ICMP echo request.
- UDP/IP Flood: 发送大量碎片 [UDP](../net/transport-l4/UDP.md) 报文, 占用内存.
- Land: 发送目的地址和源地址相同的报文, 使服务器不断向自己发送数据.
- Tear Drop: 发送伪造的, 含有假 offset 的 tcp/ip 分片报文.
- Ping of Death: 超过 IP 最大长度 65535 的 ping.
- Smurf: 广播源地址为攻击目标的 ICMP echo request, 使攻击目标收到大量 ICMP echo reply.
- Fraggle: 类似 Smurf, 但使用 UDP 替代 ICMP.
- Connection Flood: 开启大量连接, 不释放.
- Reload: 不断请求网页重载 (浏览器 F5).
- ICMP Ping of Death: 蜂鸣攻击, 攻击者发送超大网络数据包, 导致系统缓冲区溢出.
- DDoS: (Distributed Denial of Service): 控制多个僵尸网络 (傀儡机), 对服务器发起攻击

**防御 Dos:**

限制异常的高速的通信流量, 关闭不必要的服务, 避免资源耗尽. 

## 1.2 网络扫描

攻击者发起正式攻击前, 会对攻击对象网络进行扫描, 探明网络拓扑以及各设备对外提供的服务. 扫描对象包括: 设备端口, 设备地址和子网, 网络各类安全设备, 操作系统, 用户账户或权限, 具体服务或应用, 漏洞.

### 1.2.1 端口扫描

常见工具有 Namp, Netcat. 检查目标设备是否开启特定服务, 如 HTTP, FTP, SSH.
- SYN 端口扫描: 发送 `SYN` 报文, 检查服务器是否接受握手.
- FIN 端口扫描: 向服务器发送 `FIN` 报文, 检查是否返回 `RST + ACK` 报文
- *Null 端口扫描*: 发送所有 TCP 头部为 `0` 的报文, 检查是否返回 `RST + ACK` 报文.
- Xmas 端口扫描: 向服务器发送 TCP 头部所有字段为 `1` 的报文, 检查是否返回 `RST + ACK` 报文
- *UDP 端口扫描*: 对 UDP 0~65535 端口进行扫描.
- *Host Sweep*: 向主机发送大量 ICMP 或 TCP 报文, 检测主机是否存在.

### 1.2.2 漏洞扫描

检查设备, 系统, 应用程序中是否存在已知安全漏洞, 即存在已知漏洞但未及时打补丁. 常见工具有 Nessus, OpenVAS 等.

对于 WEB 应用, 也有对特定漏洞 (SQL 注入, XSS, CSRF 等) 进行扫描的工具, 如 Burp Suite, ZAP 等.

### 1.2.3 合规性扫描

...

## 1.3 网络协议缺陷

### 1.3.1 ARP 欺骗

[ARP](../net/network-l3/ARP.md) 协议会信任所有收到的 ARP 响应, 如果更新了错误的 IP-MAC 映射, 会将 IP 包转发到错误的 (恶意的) MAC 地址设备.

### 1.3.2 DNS 欺骗

攻击者给请求者发送错误的响应, 引导用户至恶意网站. 也称为 **DNS 缓存中毒攻击**, **DNS 污染**.

针对 [DNS](../net/app-l5/DNS.md) 不同阶段, 有两种表现形式:
- DNS 缓存投毒: 攻击者给域名服务器注入非法网络域名地址, 使用户跳转到非法地址
- DNS 重定向 (欺骗): 攻击者假冒域名服务器, 受害者的 DNS 请求被重定向到攻击者控制的地址内.

电信运营商出于某些政策目的, 会污染特定网站的 DNS. 解决办法是使用加密 DNS (DNS over HTTPS, DNS over TLS), 或者使用云服务企业提供的 DNS 服务 (如 Google, Cloudflare, Ali DNS). 使用梯子的时候, 仍访问很慢, 需要考虑该问题.

### 1.3.3 DNS 泄露

用户使用 VPN 服务时, 虽然访问的敏感内容被加密, 但向网络服务提供商 (IPS) 发起的 DNS 请求可能被泄露和记录. 这导致服务商可以分析用户经常访问的域名, 从而监控 VPN 用户的网络活动. 另外, DNS 是明文的 UDP 请求, 也很容易被拦截监听. 

理想情况下, DNS 域名查询应是代理服务器代替我们进行查询, 但 VPN 软件分流策略配置不正确, 可能导致本地主机也向内网 DNS 服务器或 ISP DNS 服务器发起了请求. 可以用 <https://browserleaks.com/dns> 网站测试.

注意, 盲目使用国外或不同地区的 DNS, 可能会对网络体验造成负优化. 正确配置如 Clash 等代理软件又比较复杂. 建议工作场所还是不要长期键政摸鱼.

### 1.3.4 ICMP 重定向

攻击者伪造 [ICMP](../net/network-l3/ICMP.md) 重定向消息, 使主机将流量发往攻击者伪造的网关 (某个攻击者控制的 IP), 从而建立恶意路由.

...

### 1.3.5 TCP 连接劫持

TCP 欺骗攻击 (Spoofing), 也叫 TCP 劫持攻击 (Hijacking). 攻击者在两个合法通信方之间插入或篡改数据包, 从而实现窃听和冒充的目的. 攻击原理是, 攻击者监听到双方的通信序列号, 通过构造与通信一方相似的数据包, 使其看起来像是合法一方发出的. 

```
        Evil
     /          \
    /            \
Alice  <--------> Bob
```

- Evil: 
- Evil -> Bob: `SYN=1, seq=a`, 开启同步位, 请求重新发起链接, 不使用原链接. 序列号 `seq=a` 是监听或者预测的.
- Bob -> Alice: `SYN=1, ACK=1, seq=b, ack=a+1`, Bob (服务器) 向 Alice 发出请求确认报文.
- Evil -> Alice: 确认报文该报文被 Evil 截获. 同时, Evil 向 Alice 发起 Dos 攻击, 使 Alice 错误处理 Bob 的请求确认报文.
- Evil -> Bob: `ACK=1, seq=a+1, ack=b+1`, 向 Bob 发出确认报文, 从而在新地址冒充 Alice, 与 Bob 建立了新 TCP 链接.

注意, 发送伪造的 `SYN` 包并不能劫持现有连接, 如果 TCP 连接不唯一, 服务器会向旧连接 (Alice) 发送 `RST` 重置请求.

## 1.4 注入攻击

### 1.4.1 SQL 注入

### 1.4.2 命令注入

LDAP 注入, XML 注入

## 1.5 旁路攻击

也叫侧信道攻击 (Side-Channel Attack), 一般指监控物理硬件的侧信道 (电磁泄漏, 功耗, 时序等) 来提取信息.

### 1.5.1 能耗分析攻击

熔断漏洞 (Meltdown) 和 幽灵漏洞 (Spectre) 利用 Intel 的芯片设计漏洞

### 1.5.2 时间分析攻击

### 1.5.3 错误消息分析攻击

## 1.6 社会工程学攻击

也称为社会工程学攻击 (Phishing Attack)

常见工具集: [SET](https://github.com/trustedsec/social-engineer-toolkit)

### 1.6.1 口令敲诈

### 1.6.2 钓鱼攻击

## 1.7 权限提升

系统配置不当, 访问权限控制不当, 绕过验证

如本地权限提升 (Local Priviledge Escalation) 和远程权限提升 (Remote Priviliege Escalation)

### 1.7.1 跨站脚本攻击

Cross-Site Scripting, XSS, 在网页中插入恶意脚本, 让用户在浏览中无意执行未经授权的代码.

### 1.7.2 跨站请求伪造

Cross-Site Request Forgery, CSRF, 欺骗用户在认证状态下执行未授权操作.

## 1.8 密码学攻击

### 1.8.1 分组密码

#### 1.8.1.1 字典攻击

尝试所有可能的密码组合来破解密码, 称为*暴力破解 (Brute Force Attack)*. 用预定义包含常见密码组合的字典文件来尝试破解, 称为*字典攻击 (Dictionary Attack)*. 用预计算的**哈希值与明文密码的映射表**来破解哈希密码, 加速哈希计算过程, 称为*彩虹表攻击 (Rainbow Table Attack)*.

服务器为减小密码泄露的危害性, 常采用[密码散列](cryptography/msg-digests/msg-digest.md)形式存储密码, 而不使用原始明文值. 为防止彩虹表攻击, 服务器存储密钥时还会加入随机盐值 (salting) 来混淆密码明文和哈希之间的对应关系: $\mathrm{Hash}(salt\ \Vert\ password)$. 注意, 加盐没有额外客户端步骤, 且对暴力破解攻击没有额外抗性.

```
用户ID    | 盐值                  | 哈希密码
user123   | abcd1234              | e99a18c428cb38d5f260853678922e03
```

OTP 技术还能让该散列值不断随时间更新...

#### 1.8.1.2 线性攻击

分析输入和输出比特的线性相关性, 如各类统计结构, 针对分组密码的**混淆性**不足弱点.

#### 1.8.1.3 差分攻击

输入差分定义为: $$\triangle P=P_{1}\oplus P_{2}$$ 输出差分定义为: $$\triangle C=C_{1}\oplus C_{2}$$

差分攻击研究大量**明文对**的差分变化, 如何在算法各个步骤之间传播, 是一种选择明文攻击. 在理想情况下, $\triangle P$ 的传播应该是随机的, 即输入差分 $\triangle P$ 映射到输出差分 $\triangle C$ 的概率 (统计特征) 接近均匀分布, 但是实际**混淆**函数 (如 SBox) 设计可能不完美, 导致出现较高概率的输出差分 $\triangle C$, 攻击者由此反推出部分密钥候选.

差分攻击可以削弱较少轮次的 DES, 但是并没有攻破. 在 DES 颁布之前, NSA 就已经知晓了差分攻击原理, 并将抗差分性质引入到 DES 中, 但是并没有公开; 后该方法被学者独立提出, 证实了同期其他加密算法在抗差分攻击方面比 DES 更脆弱.

#### 1.8.1.4 中间相遇攻击

针对分组密码两轮加密 [2DES](cryptography/block-ciphers/feistel/EDE.md), 从加密和解密两端同时分析, 降低密码复杂度.

#### 1.8.1.5 填充攻击

Padding Oracle Attack

针对分组加密的**填充机制**的攻击, 通过加密软件的**错误响应信息**来推测密文具体内容. 

详见 https://en.wikipedia.org/wiki/Padding_oracle_attack

### 1.8.2 流密码和伪随机数

#### 1.8.2.1 密钥流重用攻击

主要针对流密码, 假设加密方在不同消息流中使用相同的密钥流 $K$ 和初始化向量 $IV$.

加密方: $C_{1}=P_{1}\oplus K$, $C_{2}=P_{2}\oplus K$, 

攻击者: $C_{1}\oplus C_{2}=P_{1}\oplus P_{2}$, 如果有选择明文能力, 选择已知 $P_{1}$, 即可破译 $P_{2}$.

即使攻击者没有选择明文能力, 即不知晓 $P_{1}$ 和 $P_{2}$, 敌手知晓 $P_{1}\oplus P_{2}$ 也非常不安全. 举个例子, ASCII 编码中 `0x20` 代表空格, `0x41~0x5a` 是大写字母, `0x61~0x7a` 是小写字母, 会发现**小写字母异或空格就是对应大写字母, 大写字母异或空格就是对应的小写字母.** 因此 $P_{1}\oplus P_{2}$ 如果在 ASCII 解码下是英文字母, 那么大概率就是对应字母.

#### 1.8.2.2 比特翻转攻击

攻击者篡改密文某一位 $C[i]$, 由于没有明密文扩散, 攻击者可以明确知道明文比特也被翻转. 解决办法是添加完整性验证.

### 1.8.3 公钥密码和数字签名

#### 1.8.3.1 中间人攻击

MitM, Man in the Middle. 

- 针对 [Diffie Hellman-密钥交换](cryptography/public-key-crypto/diffie-hellman.md) 的中间人攻击
- 针对 [RSA 签名](cryptography/public-key-crypto/rsa/RSA-sig.md) 的中间人攻击

#### 1.8.3.2 随机数重用漏洞

[针对 DSA 数字签名的随机数重用漏洞](cryptography/public-key-crypto/digital-signature/digital-signature.md)

#### 1.8.3.3 弱参数和低熵漏洞

弱参数导致公钥密码基于的困难问题被削弱, 参考 [RSA 密钥生成](cryptography/public-key-crypto/rsa/RSA-key-gen.md).

#### 1.8.3.4 密码协议平行会话攻击

[NSPK平行会话攻击](cryptography/security-protocols/认证的密钥协商协议/基于单钥的认证密钥协商.md#平行会话攻击)

### 1.8.4 哈希算法

#### 1.8.4.1 碰撞攻击

Collision Attack. 参考 [哈希算法-生日攻击](cryptography/msg-digests/birthday-attack.md).

包括:
- 预映像攻击 (Preimage): 给定目标哈希值, 找到原始消息与之匹配
- 第二预映像攻击 (Second Preimage): 给定消息, 找到另一个消息有相同哈希值.

#### 1.8.4.2 长度扩展攻击

[length-extension-attack](cryptography/msg-digests/merkel-damgard/length-extension-attack.md)



# 2. 软件和系统安全

## 2.1 信息流安全

- 信息流机密性
- 信息流完整性

*DEP (Data Execution Prevention, 数据流执行保护)*: 将内存页标记属性: RWX. 比如 MMU 中页表的 NX/XD 位. DEP 能防御最简单的堆栈 shellcode 攻击, 但是没办法防御 ROP/JOP 等对已有可执行代码的控制流劫持. 

DEP 的实现方式有几种:
- 直接在 MMU 的页表中标记 NX/XD 位, 这需要硬件支持.
- 可信计算. 也需要硬件支持. 
- 代码段签名或哈希. 

## 2.2 控制流安全

控制流完整性

*CFI (Control-Flow Integrity, 控制流完整性)*: 使控制流只在设计允许的边上跳转, 防止跳到未授权路径. 用来防御 Gadget 链.

*PAC (Pointer Authentication Codes, 指针认证码)*. 在地址上附加短 [MAC](cryptography/msg-digests/MAC/MAC.md), 在地址进行 加载/分支 操作前, 检查认证码. 需要硬件支持, 并且认证码密钥直接由硬件持有. 

业界控制流防御机制: PAC --> MTE (Arm) --> [MIE (Apple, 2025)](https://security.apple.com/blog/memory-integrity-enforcement/).

### Return-Oriented Programming 

[Jump-oriented Programming](../paper/Jump-Oriented%20Programming,%20a%20new%20class%20of%20code-reuse%20attack.pdf)

[Return-Oriented Programming](../paper/Return-oriented%20Programming,%20Exploitation%20without%20Code%20Injection.pdf)

*ASLR (Address Space Layout Randomization, 地址随机化布局)*, 将程序关键部分的加载地址随机化. 比如随机化 可执行区域, 堆栈, 函数地址等. 

但是, 数据区需要保证不可执行 (NX), 否则攻击者无需 ROP 就可以注入并执行 shellcode.

## 2.3 内存安全

- 内存泄露
- 堆栈保护
- 释放后使用

### 2.3.1 栈溢出

栈溢出可能导致数据污染, 或返回地址 (RA) 被恶意修改. 

防范栈溢出攻击的手段是 *Stack Canary*. 在栈帧中插入哨兵值, 或者维护一个影子栈. 


## 2.4 数据类型安全

- 类型检查
- 类型转换, 如实践格式

## 2.5 资源安全

- Profiling
- 沙盒 (Sandbox)
- 资源控制, 权限隔离

## 2.6 恶意软件攻击

### 2.6.1 木马

Trojan Horse, 伪装成合法软件欺骗用户执行.

### 2.6.2 病毒

Virus, 恶意软件, 嵌入在各类文件中传播, 从而感染系统.

### 2.6.3 缺陷和后门

flaws, trap door.

#### 2.6.3.1 供应链攻击

以在编译器中埋恶意代码为例[^1]:
1. 修改编译器源码, 使新编译器能在某些情境下插入恶意代码.
2. 生成新的编译器二进制程序, 并作为正式编译器分发和安装.
3. 删除原编译器源码中的恶意代码.

[^1]: Reflections on Trusting Trust. Ken Thompson. Communications of the ACM. 1984. Vlume 27, NUmebr 8.