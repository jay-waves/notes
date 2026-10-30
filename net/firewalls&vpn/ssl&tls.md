SSL (Secure Sockets Layer, 安全套接层)[^1], 及其继任者 TLS (Transport Lyayer Security, 传输安全)[^2] 提供了 TCP/IP 协议与应用层协议之间的透明安全协议, 实现服务器和客户端之间的机密通信和对等认证 . 现在 SSL 多代指 TLS. TLS/SSL 被认为是传输层和应用层之间的协议.

[^1]: 最初由 Netscape Communications Inc. 开发, 后发布多个改进版本.

[^2]: . [TLSv1.1, (RFC4346, 2006)](https://datatracker.ietf.org/doc/html/rfc4346). [TLSv1.2, (RFC5246, 2008)](https://datatracker.ietf.org/doc/html/rfc5246). [TLSv1.3 (RFC8446, 2018)](https://datatracker.ietf.org/doc/html/rfc8446)

TLS/SSL协议步骤:
- 认证
- 密钥协商
- 数据加密: 保密性和完整性

TLS/SSL协议分为上下两层:
1. (上层) 握手层协议 (handshake layer protocal, SSL Change Cipher Spec Protocol, SSL Alert Protocol): 建立在记录层协议之上, 在数据传输之前进行身份认证和密钥协商.
2. (下层) 记录层协议 (record layer protocal): 建立在 [TCP](../transport-l4/TCP.md) 之上, 提供数据封装/压缩/加密等功能支持.

### 记录层协议

功能: (按顺序) 
1. 分段
2. 压缩 (存在安全缺陷, TLSv1.3 已不支持)
3. 增加 MAC 
4. 加密 
5. 增加 SSL 记录

### 握手层协议

功能:
- 对等实体验证: 为用户验证服务器身份, (可选) 为服务器验证用户身份.
- 协商 TLS 版本和加密套件
- 使用密钥协商算法生成:
	- 一个共享的会话密钥, 用于数据保密性服务
	- 一个加密哈希, 用于数据完整性服务

密码学套件 (Cipher Suite), 如 `TLS_DHE_RSA_WITH_AES_256_CBC_SHA256`
- DHE: 密钥交换算法
- RSA: 身份认证算法
- AES_256_CBC: 对称加密算法
- SHA256: 消息摘要算法

```
+--------+                                      +--------+
|        o ---- ClientHello ------------------> |        |
|        |                                      |        |
|        |       ServerHello                    |        |
|        |       [Certificate]                  |        |
|        |       [ServerKeyExchange]            |        |
| Client |       [CertificateRequest]           | Server |
|        |       ServerHelloDone                |        |
|        | <----------------------------------- o        |
|        |                                      |        |
|        |       [Certificate]                  |        |
|        |       ClientKeyExchange              |        |
|        |       [CertificateVerify]            |        |
|        |       ** ChangeCipherSpec **         |        |
|        |       Finished                       |        |
|        o -----------------------------------> |        |
|        |                                      |        |
|        |       ** ChangeCipherSpec **         |        |
|        |       Finished                       |        |
|        < ------------------------------------ o        |
|        |                                      |        |
+--------+                                      +--------+
```

```
     Client                               Server
     ^ ClientHello
     | + key_share*
Key  | + signature_algorithms*
Exch | + psk_key_exchange_modes*
     v + pre_shared_key*   ----->
                                     ServerHello           ^ Key Exch
                                     + key_share*          |
                                     + pre_shared_key*     v
                                     {Ecrypted Extensions} ^  Server
                                     {CertificateRequest*} V  Params
                                     {Certifacte*}         ^
                                     {CertifacateVerify*}  | Auth 
                                     {Finished}            v
                          <------    {App Data*}
     ^ {Certifacate*}
Auth | {CertificateVerify*}
     v {Finished}
       {App Data}         <----->  {App Data}
```

### TLS v1.3

#### 安全性改进

TLS 1.3 移除了一些不安全的加密算法:
- [RC4](../../sec/cryptography/stream-ciphers&prng/stream-ciphers/RC4.md)
- [DES](../../sec/cryptography/block-ciphers/feistel/DES.md), [3DES](../../sec/cryptography/block-ciphers/feistel/EDE.md) 
- [MD5](../../sec/cryptography/msg-digests/merkel-damgard/MD5.md)
- [RSA](../../sec/cryptography/public-key-crypto/RSA/RSA.md)

TLS1.3 使用了更强的密码套件: AEAD (Authenticated Encryption with Associated Data) 算法, 包括 AES-GCM, ChaCha20-Poly1305, 来同时实现加密和认证.

强制前向安全性. 不支持基于 RSA 的密钥交换, 而仅支持 DH 和 ECDH 密钥交换. RSA 需要用服务器长期持有的密钥对 $PK,SK$ 来加密会话密钥, 一旦服务器的私钥泄露将导致之前的加密的所有会话密钥皆不安全. 而 DH 协议中参数都是临时生成的.

使用 HKDF (HMAC-based Extract-and-Expand Key Derivation Function) 作为密钥派生函数.

#### 协议改进

简化握手流程, 从往返延迟 2RRT 降为 1RTT, 还允许一定条件下重用会话密钥, 称为 *0RTT* 握手.

完全移除压缩功能, 防止压缩攻击 (如 CRIME)