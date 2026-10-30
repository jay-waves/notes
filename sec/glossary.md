# A

### Address Sanitizer

Google 的 C/C++ 运行时内存错误检测工具, 基于 LLVM IR 实现.

### AES

目前广泛使用的对称加密标准, 见 [AES](cryptography/block-ciphers/sp/AES.md)

### Avalanche Effect

雪崩效应 (avalanche effect) 指现代加密算法的一种理想属性. 当明文输入产生微小变化 (如一比特翻转) 时, 会引起算法输出的大面积无规律改变.

### ACL 

[Access Control List, 访问控制列表](../net/firewalls&vpn/firewall.md), 用于定义哪些用户或系统进程可以访问系统资源以及权限级别.  

### AES-GCM 

AES-[Galois Counter Mode](cryptography/block-ciphers/modes-of-operation.md), 一种结合分组加密和认证的模式, 广泛应用于现代加密协议如 TLS.  

### ASLR

Address Space Layout Randomization, 地址空间布局随机化, 用于防止缓冲区溢出攻击. 

---

# B

---

# C


### Completeness

完备性. 逻辑系统是完备的, 如果它能证明该逻辑下的**所有**真命题. 见 [可靠性与完备性](../math/toc/可靠性与完备性.md)

### CVE

Common Vulnerabilities and Exposures. 用于标识和追踪已知的网络安全漏洞与安全问题, 每个 CVE-ID 对应一个漏洞及其描述/影响范围/补丁信息.

### CWE

Common Weakness Enumeration, 常见弱点枚举. 用于分类和描述各种软件安全中的弱点, 比如 CWE-89 指的是 SQL 注入弱点.

### CVSS

Common Vulnerabilities Scoring System, 用于评估漏洞严重性. CVSS v3.1 标准规定, 0.1-3.9 为低危漏洞, 4.0-6.9 为中危漏洞, 7.0-8.9 为高危漏洞, 9.0-10.0 为严重漏洞.

### CNVD/CNNVD

类似于美国的 CVE/NVD, CNVD (中国国家信息安全漏洞共享平台) 用于发布漏洞编号, CNNVD (中国国家信息安全漏洞库) 用于提供漏洞的详细分析信息.

### CBC

一种对称密码的链接工作模式, 用于加密长明文, 有迭代反馈机制, 见 [链接模式](cryptography/block-ciphers/modes-of-operation.md)

### CTR

[CTR](cryptography/block-ciphers/modes-of-operation.md), Counter Mode, 对称加密的一种链接模式, 支持随机访问. 

### CPA

Chosen Plaintext Attack, 选择明文攻击.

### CCA

Chosen Ciphertext Attack, 选择密文攻击. 分为 CCA1 和 CCA2 两种.

### CCA1

Lunchtime Attack, 在解密查询开始前, 就要选择所有要测试的密文, 之后不能再根据反馈重新选择.

### CCA2

Adaptive Chosen Ciphertext Attack, 攻击者基于先前解密查询的结果来选择后续的密文, 也就是根据已知信息调整策略. 比 CCA1 更强.

### CA

Certificate Authority, 用于颁发和管理密钥/数字证书的第三方机构.

### CSP

Content Security Policy, 内容安全策略, 用于防止跨站脚本 (XSS) 攻击.  

### CSRF

[Cross-Site Request Forgery, 跨站请求伪造攻击](security-attack.md), 利用用户的身份对受信网站发送恶意请求. 

---

# D

### DES

早期对称加密标准, 现由于安全性已被 AES 取代. 见 [DES](cryptography/block-ciphers/feistel/DES.md)

### Digital Certificate

数字证书, 用于验证公钥拥有者身份, 见 [密钥分发与管理](cryptography/security-protocols/密钥分发与管理.md)

### DLP

Discrete Logarithm Problem, 离散对数问题, 见 [欧拉定理](../math/numth/欧拉定理.md)

### DH

Diffie-Hellman 密钥交换, 两实体在非安全信道交换秘密的算法, 见 [DiffieHellman](cryptography/public-key-crypto/diffie-hellman.md)

---

# E

### EDB

Exploit Database. 公开发布一些漏洞的详细信息和利用代码, 每个漏洞利用代码以 EDB-ID 标识. CVE 相比之下, 默认隐藏了漏洞细节, 最多能提供一些链接.

### ElGamal

一种基于 DLP 困难性的公钥密码算法, 包括加密和签名. 见 [ElGamal](cryptography/public-key-crypto/el-gamal.md)

---

# F

### Fuzzing

高效软件模糊测试框架, 见 [模糊测试技术](software-analysis/fuzzing.md)

### Finite State Machine

有限状态自动机. 见计算理论.

### Frame Pointer

帧指针.

### FAC

Factorization, 因数分解. 通常指 RSA 基于的大整数分解困难问题.

---

# G

---

# H

### HMAC

基于密码学杂凑函数的消息认证码 (MAC), 是消息认证码最常见形式, 见 [HMAC](cryptography/msg-digests/MAC/HMAC.md)

---

# I

### Internet Standards

互联网标准, 为全球互联网互操作性和统一性提供规范和指南. 内容包括各层网络协议, 密码学和安全, 数据交换格式 (JSON) 及标记语言 (HTML).

### IV

Initialization value. 设置加密算法或加密模式的初始状态的输入参数. IV 也有引入同步和方差 (cryptographic variance). *注意, 全称 Initialization Vector 在 RFC 4949 中被标记为废弃.*

### IaaS

Infrastructure as a Service, 一种云服务交付模型.

### IDS 

Intrusion Detection System, [入侵检测系统](../net/firewalls&vpn/IDPS.md), 用于检测网络或系统中的恶意活动.  

### IPS

Intrusion Prevention System, [入侵防御系统](../net/firewalls&vpn/IDPS.md), 与 IDS 类似, 但同时具有阻止威胁的能力. 

### IoT

Internet of Things, 物联网, 通过互联网将设备连接起来实现智能化控制. 

---

# J

---

# K

### KMS 

Key Management Service, 密钥管理服务, 用于管理加密密钥的创建和存储. 

### KDF

密钥派生函数

---

# L

---

# M

### MAC

Message Authentication Code, 消息认证码, 用于验证消息的完整性和来源真实性, 见 [MAC](cryptography/msg-digests/MAC/MAC.md)

### MD5

Message Digest Algorithm 5, 广泛使用的散列函数, 由于安全问题已被淘汰, 见 [MD5](cryptography/msg-digests/merkel-damgard/MD5.md)

### MITM

Man-in-the-Middle Attack, 中间人攻击, 攻击者在通信双方之间进行拦截和篡改. 

### MFA

Multi-Factor Authentication, 多因素认证, 结合多个身份验证方法以提高安全性. 

---

# N

### NVD

National Vulnerability Database, 由 NIST 维护的国家漏洞数据库. 为每个 CVE 漏洞提供详细评分, 影响和补丁信息. 用于对 CVE 中漏洞的补充和扩展.

### Nonce

Number Once, 用于密码算法和安全协议的一次性数字, 用于防范重放攻击.

### NAT 

[Network Address Translation, 网络地址转换](../net/firewalls&vpn/nat.md), 用于在局域网和公网之间转换 IP 地址. 

### NIC

Network Interface Card, 网络接口卡, 用于设备与网络的连接.  

### NTP

Network Time Protocol, 网络时间协议, 用于同步计算机系统的时钟. 


---

# O

### OTP

One-Time Password, 用于单次登录的临时密码. TOTP (Time-based OTP) 基于当前时间戳生成密码, 常用于服务器的双因素认证 (2FA) 中, 使服务器和客户端共享可不断更新的密码. HOTP (HMAC-based OTP) 指基于加密的哈希认证码的单次密钥.

### OAuth

[oauth](../net/web/auth/oauth.md), 一种开放标准授权协议, 允许用户授权第三方访问其资源而无需暴露凭据. 

---

# P

### PC

Program Counter. 存储处理器当前正在执行的指令的内存地址.

### PE

portable executable, Windows 可执行文件格式. 源于 COFF.

### PEM

Privacy-Enhanced Mail, 一种文件格式, 通常用于存储加密密钥和证书. 

### PGP

[PGP](../net/app-l5/PGP.md), Pretty Good Privacy, 用于加密和签名的公钥加密程序. 

---

# Q

### OSI

一种安全框架, 定义了安全攻击/安全机制/安全服务, 见 [安全模型/OSI](../README.md)

---

# R

### PaaS

Platform as a Service. 同见 IaaS, SaaS.

### PRNG

Pseudo-Random Number Generator, 伪随机数生成器, 见 [流密码](cryptography/stream-ciphers&prng/stream-ciphers&prng.md)

### PKI

Public Key Infrastructure, 公钥基础设置, 见 [密钥分发与管理](cryptography/security-protocols/密钥分发与管理.md)

### PKCS

Public-Key Cryptography Standards, 公钥密码学标准. 由原 RSA Data Security Inc. 发布的一系列**可不断修改和更新的**标准:

- [PKCS #1](cryptography/public-key-crypto/RSA/PKCS1.md): RSA 加密和签名, 包括 RSA OAEP 和 PSS 填充方案.
  - v1.5 (1993): v1.5 填充算法, 不安全.
  - v2.0 (1998): [OAEP (Optimal Asymmetric Encryption Padding)](cryptography/public-key-crypto/RSA/PKCS1.md) 加密填充算法, 推荐.
  - v2.1 (2002): PSS (Probabilistic Signature Scheme) 签名填充算法, 推荐.
- PKCS #7: 定义加密和签名消息的语法 (Syntax).

### RTT

网络报文往返时间.

### RSA

目前广泛使用的公钥加密算法, 见 [RSA](cryptography/public-key-crypto/RSA/RSA.md).

### RCE

Remote Code Execution, 远程代码执行漏洞, 允许攻击者在目标系统上运行任意代码. 

---

# S

### SAML

[saml](../net/web/auth/saml.md), Security Assertion Markup Language, 用于单点登录 (SSO) 和身份联合的标准. 

### SQL

数据库结构化查询语言, 见 [Data Storage/SQL](../db/sql/sql.md).

### SQL Injection 

[SQL 注入攻击](security-attack.md), 利用 SQL 查询中的输入漏洞执行恶意代码. 

### Soundness

健全性, 一个逻辑系统是健全的, 当它所有推导都仅产生真实结论; 即不会错误地证明假命题为真. 见 [可靠性与完备性](../math/toc/可靠性与完备性.md).

### Stack

先入后出的栈数据结构, 见 [binary heap](Algorithm/内核/list.md). 也指进程内存空间的一种结构, 见 [linux-mem-layout](../os/mem/linux-mem-layout.md).

### SaaS

Software as a Service, 一种云服务交付模型.

### SHA

Secure Hash Algorithm, 密码学哈希函数 (消息摘要函数, 杂凑函数, 散列函数).

### SM4

中国标准对称密码算法, 见 [SM4](cryptography/block-ciphers/feistel/SM4.md).

### SM2

中国标准公钥密码算法, 基于 ECC, 包括: 加密算法, 数字签名, 密钥协商算法. 见 [SM2](cryptography/public-key-crypto/ECC/SM2.md).

---

# T

### TOTP

Time-based One-Time Password, 基于时间的动态密码, 通常用于双因素认证. 

见 [O-OTP](#OTP).

### TCP

计算机网络传输层的[传输控制协议 (TCP)](../net/transport-l4/TCP.md), 提供可靠点对点连接.

## TPM

国际可信计算组织 (TCG, Trusted Computing Group) 通过在硬件平台中引入可信平台模块 (Trusted Platform Module, TPM) 来提高计算机系统的可信性.

## TCM

可信密码模块 (trusted Cryptographic Modeul, TCM). 见 TPM.

## TCB 

可信计算基 (Trusted Computing Base, TCB). 见 TPM.

---

# U

### URL

互联网统一资源定位符.

### Ubuntu

基于 Debian 的开源 Linux 流行发行版.

### User Mode

操作系统用户空间.


---

# V

### Virtual Address Space

虚拟地址空间. 一种管理内存的方式.

### VLAN 

Virtual LAN, 虚拟局域网, 通过逻辑隔离实现不同网络设备间的隔离. 

---

# W

### Whitening

白化, 在第一轮和最后一轮加密中对密钥和明文进行**异或**操作, 旨在加强分组加密安全性. 最早用于 DES-X 加密算法.

### WAF

Web Application Firewall, Web 应用防火墙, 用于保护 Web 应用免受攻击. 

---

# X

### XSS 

Cross-Site Scripting, [跨站脚本攻击](security-attack.md), 通过在网页中插入恶意代码进行攻击. 

---

# Y

---

# Z

### Zero-Day 

0Day, 零日漏洞, 指在被发现后立即被利用且未有修复措施的漏洞. 
