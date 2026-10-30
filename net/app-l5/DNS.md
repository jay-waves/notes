### 配置本地 Hosts

windows 上 hosts 文件: `C:\Windows\System32\drivers\etc\hosts`

linux: `/etc/hosts`

### 使用企业 DNS 服务

默认使用 ISP (网络服务提供商, 如电信或移动) 的 DNS 服务器. 可能有安全或速度问题, 比如政府蓄意对 DNS 解析进行污染投毒. 企业和云服务商也提供公共 DNS 服务, 如谷歌和阿里云.

```sh
# 使用 Goolgle DNS 查询域名
nslookup example.com 8.8.8.8

# 查询默认 DNS 服务商, Linux 上还可以查询 /etc/resolv.conf
nslookup
```

### 反向 DNS 查询

从 IP 地址反向查询对应域名.

```sh
# windows
nslookup 8.8.8.8

# linux (apt install dnsutils)
dig -x 8.8.8.8

# linux 
host 8.8.8.8
```

一些网页服务, 如 ipinfo.net, 查询结果更精准.

***

## DNS

The Domain Name System (DNS) translates human-readable domain names, like `www.example.com`, into machine-readable [IPv4](../network-l3/IPv4.md) address, such as `192.0.2.1`. 

DNS 使用 [UDP](../transport-l4/UDP.md) 协议 53 端口.

### Key Components

Domain Names: In `blog.csdn.cn`, `.cn` is the top-level domain (TLD), `csdn` is the second level domain, `blog` is a subdomain.

**DNS Records**: 指存储在 DNS 服务器中的记录信息, 有很多种类: 
- **A**: 将一个域名映射为 IPv4 地址
- **AAAA**: 将一个域名映射为 IPv6 地址
- **CNAME**: 将一个域名映射到另一个域名, 类似域名的别名. 比如 `www` 映射到根域名.
- MX: 指定某个权限域名服务器下的邮件服务器的地址.
- TXT: 存储文本信息, 一般用于安全性配置. 
- NS: 指定负责解析的 DNS 服务器 (DNS 委派).
- **PTR** (Pointer Record): 反向 DNS 解析. 当来源 IP 的 PTR 和对应的 A 记录不一致时, 可能被归类为恶意活动 (如垃圾邮件).

```dns
example.com.    3600    IN    A    93.184.216.34
example.com.    3600    IN    AAAA    2606:2800:220:1:248:1893:25c8:1946
www.example.com.    3600    IN    CNAME    example.com.
example.com.    3600    IN    MX    10 mail.example.com.
example.com.    3600    IN    MX    20 backup.example.com.
example.com.    3600    IN    TXT    "v=spf1 include:_spf.google.com ~all"
example.com.    3600    IN    NS    ns1.example.com.
example.com.    3600    IN    NS    ns2.example.com.
example.com.    3600    IN    SOA    ns1.example.com. admin.example.com. 2023101501 7200 3600 1209600 3600
34.216.184.93.in-addr.arpa.    3600    IN    PTR    example.com.
```

![](../../attach/img/net/net-dns.avif)

| 根域名服务器   | Root DNS Server          |
| -------------- | ------------------------ |
| 权威域名服务器 | Authoritative DNS Server |
| 本地域名服务器 | Recursive DNS Resolvers                         |

### DNS Resolution

递归查询指请求方将整段域名 `gist.github.com` 的解析交付给另一个域名服务器完成, 自身仅等待结果, 不再负责后续转发; 迭代查询指请求方自己完成查询消息的转发, 先请求根域名服务器, 根域名服务器返回 `.com` 服务器的地址, 请求方再向 `.com` 域名服务器查询 `github.com` 的地址, 以此类推. 迭代查询的优点是便于本地服务器缓存信息. 实践中, 客户端向本地服务器请求使用的是递归查询 (使用 UDP 协议), 而本地服务器则使用迭代查询 (使用 TCP 协议).

```mermaid
sequenceDiagram
    participant H as Local Host
    participant L as Local DNS Server
    participant Root as Root DNS Server
    participant Com as .com Auth<br/>DNS Server
    participant GitHub as Github Public<br/>Auth DNS Server

    H->>H: 浏览器访问 gist.github.com
    H->>H: 查询浏览器缓存
    H->>H: 查询系统缓存（Hosts）

    H->>L: 递归查询本地域名服务器
    activate L
    L->>L: 查询本地缓存

    L->>Root: 【缓存未命中】<br/>迭代查询根域名服务器
    activate Root
    Root->>Root: 查询
    Root-->>L: .com's IP
    deactivate Root

    L->>Com: 迭代查询 .com 权威域名服务器
    activate Com
    Com->>Com: 查询
    Com-->>L: .github.com's IP
    deactivate Com

    L->>GitHub: 迭代查询 .github.com 权威域名服务器
    activate GitHub
    GitHub->>GitHub: 查询
    GitHub-->>L: gist.github.com's IP
    deactivate GitHub

    L->>L: 更新本地缓存
    L-->>H: gist.github.com's IP
    deactivate L

    H->>H: 访问 gist.github.com
```

在企业内网中, 会有独立的 DNS 服务器充当本地域名服务器. 如果企业有对外服务, 就会有对外的权威域名服务器, 用于提供自身域名下的子域名解析. 如 Github 等公司, 会使用 Cloudflare 这类第三方服务, 提供 DNS, CDN, 负载均衡和安全防护.

在家庭网络中, 路由器充当网关组成小型的 LAN, 所以 DNS 会先转发给路由器, 路由器再转发给网络供应商 (如电信, 移动) 的域名服务器, 由其充当本地域名服务器.

```mermaid
sequenceDiagram
    participant H as Local Host
    participant R as Router
    participant D as Local DNS Server

    H->>H: 查询浏览器缓存
    H->>H: 查询系统缓存（Hosts）

    H->>R: 【缓存未命中】<br/>递归查询路由器
    activate R
    R->>R: 查询本地缓存

    R->>D: 【缓存未命中】<br/>递归查询本地域名服务器
    activate D
    D->>D: 查询本地缓存
    D->>D: 【缓存未命中】<br/>开始迭代查询
    deactivate D
    deactivate R

    Note right of D: ISP DNS Server<br/>Public DNS Server:<br/>- Ali: 223.5.5.5<br/>- Google: 8.8.8.8<br/>- Baidu: 180.76.76.76<br/>- 114DNS: 114.114.114.114<br/>- Cloudflare: 1.1.1.1<br/>- Microsoft DNS: 4.2.2.1
```

***

- 阿里云 DNS: `223.5.5.5` (CH)
- 百度 DNS: `180.76.76.76` (CH)
- 114 DNS: `114.114.114.114` (CH)
- 联通 DNS: `202.96.134.33` (CH)
- 台湾中华电信 DNS: `209.244.0.3` (TW)
- Yandex DNS: `77.88.8.8` (RU)
- Quad9 DNS: `9.9.9.9` (GL)
- Google DNS: `8.8.8.8`  `8.8.4.4` (US)
- Cloudflare DNS: `1.1.1.1` (US)
- OpenDNS: `208.67.222.222` (GL)
- DNS.SB: `45.11.45.11` (GE)

参考: https://adguard-dns.io/kb/general/dns-providers/