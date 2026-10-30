
## 安全目标

基础安全目标 (CIA 不可能三角, 信息安全三要素):
- 保密性 (Confidentiality):  信息只对授权的实体可见, 包含数据保密性与隐私保密性
- 完整性 (Integrity): 信息未被未经授权地修改或破坏, 包含信息完整性与系统完整性
- 可用性 (Availability): 对授权用户不能拒绝服务或服务中断

其他重要安全目标如下.
- 不可否认性 (也叫不可抵赖性, Non-Repudiation): 发送者或接收者不能否认曾经的收发信息行为.
- 可控性 (也叫可追溯性, Accountability): 确保对系统或信息的访问和修改行为可以被审计和追踪.
- 真实性 (Authenticity): 确保信息的来源是可信的, 并且传输过程未被篡改. 
- 新鲜性 (Freshness): 保证数据是新的, 而不是重放的历史消息.
- 隐私 (Privacy): 关注个人信息的合法地, 受控地和透明地使用.
- 透明性 (Transparency)
- 可靠性 (Reliability)
- 合规性 (Compliance)

其他安全属性:
- 身份认证 (Authentication): 验证主体是其声称的身份. 更关注*真实性*中的信息来源真实性部分.
- 授权 (Authorization): 身份认证后, 赋予请求者适当权限, 使其访问对应权限的服务.
- 审计性 (Accountablility)
- 可追溯性 (Traceability)
- 最小化特权 (Least Privilege)
- 权责分离 (Separation of Duties)
- 数据最小化 (Data Minimization)
- 抗篡改 (Tamper Resistance)
- 抗碰撞 (Collision Resistance)

> 安全目标是系统希望实现的最终状态或保护需求, 是一种外部需求.  
> 安全属性是系统设计和实现中所具备的特征, 是一种内部特性.
???

## OSI 安全框架

[X.800, 1991] 对 OSI (Open Systems Interconnection Refernce Model) 安全框架进行了系统定义, 包括:

- [security-attack](security-attack.md): 任何危及信息系统安全的行为
- 安全机制: 用来检测攻击, 阻止攻击或从攻击状态恢复到正常状态的过程.
- 安全服务: 加强数据处理系统和信息传输的安全性的一种处理过程或通信的服务, 目的在于利用一种或多种**安全机制**进行反攻击.

### 安全攻击

[RFC 4949, 2007, P22] 对 **Attack** 的定义为:

> An intentional act by which an entity attempts to evade 
> security services and violate the security policy of a system.
> That is, an actual assault on system security that derives from an
> intelligent threat.

[RFC 4949, 2007, P23] 对 **Attack** 进行了分类:
- 按意图分类:
	- 主动攻击 (Active Attack). 尝试直接修改和影响系统的资源和操作.
	- 被动攻击 (Passive Attack). 利用系统的信息, 但是并不直接影响系统资源, 即不影响正常通信也不篡改消息. 被动攻击的目的是获取实施离线攻击 (Off-line Attack) 所需的信息, 离线攻击从目标系统获取信息, 然后在另一个攻击者选择的系统中去分析. **被动攻击难以检测, 易于预防**, 也称为*窃听 (Eavesdropping)*.
- 按攻击的发起地点分类:
	- 内部攻击 (Inside Attack), 被授权的内部人员, 将其权限用于其他非授权目的. 
	- 外部攻击 (Outside Attack), 未授权或不合法的用户, 从互联网攻击系统内部.
- 按攻击的传送方式分类:
	- 直接攻击 (Direct Attack)
	- 间接攻击 (Indirect Attack), 攻击者将数据包发送给第三方, 委托第三方通过某种方式攻击.

```
      + - - - - - - - - - - - - +  + - - - - +  + - - - - - - - - - - -+
      | An Attack:              |  |Counter- |  | A System Resource:   |
      | i.e., A Threat Action   |  | measure |  | Target of the Attack |
      | +----------+            |  |         |  | +-----------------+  |
      | | Attacker |<==================||<=========                 |  |
      | |   i.e.,  |   Passive  |  |         |  | |  Vulnerability  |  |
      | | A Threat |<=================>||<========>                 |  |
      | |  Agent   |  or Active |  |         |  | +-------|||-------+  |
      | +----------+   Attack   |  |         |  |         VVV          |
      |                         |  |         |  | Threat Consequences  |
      + - - - - - - - - - - - - +  + - - - - +  + - - - - - - - - - - -+
```

具体的攻击手段可以参考笔记[security-attack](security-attack.md).

### 安全威胁

安全威胁是从防守方角度考虑安全漏洞; 安全攻击是从攻击者角度考虑安全漏洞.

[RFC 4949, 2007, P251] 对 **Risk** 的定义为:

> An expectation of loss expressed as the probability that a
> particular threat will exploit a particular vulnerability with a
> particular harmful result.

根据 [NIST SP 800-30 Rev.1, 2012], 处理 **Risk** 有四种方式:
1. Risk Avoidance, 通过填补漏洞来消除风险.
2. Risk Transference, 将风险转移到其他系统或实体. 如商业保险和外包服务.
3. Risk Limitations, 实施控制来最小化风险和损失.
4. Risk Assumption, 评估并接受可能的风险.

从经济和技术的角度看, 完全避免和转移风险都是不可行的. 即使部署了所有可用对策, 仍会有参与风险, 因此, 分析风险时会将风险按成本和关键性顺序列出, 针对性应用对策. 完整和定量的风险分析很难, 机构会避免列出可能的安全威胁, 而只制定具体的安全手段.

基本安全威胁: (和基本安全目标相对应)
1. 信息泄露 (Disclosure): 窃听, 内部人员操作不慎导致的泄露, 媒体废弃物导致的泄露.
2. 完整性破坏 
3. 拒绝服务   
4. 非法使用 

从形式上看, 有渗入类威胁, 如假冒, 旁路控制和授权侵犯; 植入类威胁, 如木马和后门; 潜在威胁, 对应被动攻击. 

### 安全服务及安全机制


[X.800, 1991] 定义了五类安全服务 (security services) 安全服务:
1. *数据保密性, Data Confidentiality.*
	- Data confidentiality, 数据内容保密性.
		- Connection confidentiality. 有连接通信 ([TCP](../net/transport-l4/TCP.md)), 对整个会话状态和数据分组进行加密. 如 [SSL/TLS](../net/firewalls&vpn/ssl&tls.md) 技术.
		- Connectionless confidentiality. 无连接通信 ([UDP](../net/transport-l4/UDP.md)), 对单个数据包独立加密. 如 [IPSec ESP](../net/firewalls&vpn/ipsec.md) 技术.
		- Selective field confidentiality. 只在必要字段
	- Traffic flow confidentiality, TFC, 流量保密性.
2. *数据完整性, Data Integrity.*
	- Connection integrity, 整个连接通信中, 数据单元按顺序传输, 并且不被篡改.
		- with recovery, 通过握手和数据确认机制, 遇到完整性错误时, 请求重传来恢复完整性.
		- without recovery, 遇到完整性错误时, 直接丢弃. 无连接通信默认该方式.
	- Connectionless integrity, 独立数据包的完整性. 如 [IPSec AH](../net/firewalls&vpn/ipsec.md) 技术. 
	- Selective field integrity
3. *认证, Authentication, 身份验证*. 注意身份认证, 不能保证不可否认, 也不能保证数据完整性.
	- Peer entity authentication. 对等实体身份验证.
	- Data origin authentication. 信息源身份验证.
4. *不可否认性, Nonrepudiation.*
	- Non-repudiation with proof of origin. 消息发送者否认发送行为.
	- Non-repudiation with proof of delivery (receipt). 消息接收者否认收到拥有数据.
5. *访问控制, Access Control*, 类似 *授权*.

[RFC 4949, 2007] 描述道: 

> Security services implement security policies, and are implemented by security mechanisms.

安全策略规定了"该做什么"和"不该做什么", 安全服务则是"如何做". 

```
		 What Security Services
         Should Be Provided?        +- - - - - - - - - - - - -+
         ^  +- - - - - - - - - - - -| Mission Functions View  |
         |  | Security Policy       |- - - - - - - - - - - - -+
         |  +- - - - - - - - - - - -| Domain Practices View   |
         |  | Security Model        |- - - - - - - - - - - - -+
         |  +- - - - - - - - - - - -| Enclave Services View   |
         |  | Security Architecture |- - - - - - - - - - - - -+
         |  +- - - - - - - - - - - -| Agent Mechanisms View   |
         |  | Security Mechanism    |- - - - - - - - - - - - -+
         v  +- - - - - - - - - - - -| Platform Devices View   |
         How Are Security           +- - - - - - - - - - - - -+
         Services Implemented?
```

在具体技术上, 安全服务通过安全机制来实现:

| <table><tr><th></th><th>安全机制</th></tr><tr><td>安全服务</td><td></td></tr></table> | 加密 | 数字签名 | 访问控制 | 数据完整性 | 认证交换 | 流量填充 | 路由控制 | 公证 (Notarization) |
| ----------------------------------------- | ---- | -------- | -------- | ---------- | -------- | -------- | -------- | ---- |
| 同等实体认证                              | Y    | Y        |          |            | Y        |          |          |      |
| 数据源认证                                | Y    | Y        |          |            |          |          |          |      |
| 访问控制                                  |      |          | Y        |            |          |          |          |      |
| 保密性                                    | Y    |          |          |            |          |          | Y        |      |
| 流量保密性                                | Y    |          |          |            |          | Y        | Y        |      |
| 数据完整性                                | Y    | Y        |          | Y          |          |          |          |      |
| 不可否认性                                |      | Y        |          | Y          |          |          |          | Y    |
| 可用性                                    |      |          |          | Y          | Y         |          |          |      |

[X.800, 1991] 还列有一些不属于特定安全服务的安全机制, 如*事件检测*, *安全审计 (Security Audit Trail)*, *灾难恢复 (Security Recovery)*. 这些安全机制的重要性和所需的安全等级相关, 有的则普遍存在.

[X.800, 1991] 和 [RFC 4949, 2007] 都定义了安全服务所处的[网络层次](../net/internet.md), 不过随着技术进步和定义变化, 下表在不同标准间区别较大, 仅作参考.

<table border="1" cellspacing="0" cellpadding="5">
    <caption><strong>the relationship of security services and layers</strong></caption>
    <thead>
        <tr>
	        <th rowspan="2" colspan="2">Service</th>
            <th colspan="7">Network Layer</th>
        </tr>
        <tr>
            <th>Physical</th>
            <th>Data Link </th>
            <th>Network</th>
            <th>Transport</th>
            <th>Session</th>
            <th>Presentation</th>
            <th>Application</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td rowspan="2">Authentication</td><td>Peer Entity</td>
            <td></td><td></td><td>Y</td><td>Y</td><td></td><td></td><td>Y</td>
        </tr>
        <tr>
            <td>Data Origin</td>
            <td></td><td></td><td>Y</td><td>Y</td><td></td><td></td><td>Y</td>
        </tr>
        <tr>
            <td>Access Control</td><td></td>
            <td></td><td></td><td>Y</td><td>Y</td><td></td><td></td><td>Y</td>
        </tr>
        <tr>
            <td rowspan="4">Confidentiality</td><td>Stream</td>
            <td>Y</td><td>Y</td><td>Y</td><td>Y</td><td></td><td>Y</td><td>Y</td>
        </tr>
        <tr>
            <td>Datagram</td>
            <td>Y</td><td>Y</td><td>Y</td><td>Y</td><td></td><td>Y</td><td>Y</td>
        </tr>
        <tr>
            <td>Selective Field</td>
            <td></td><td></td><td>Y</td><td></td><td></td><td>Y</td><td>Y</td>
        </tr>
        <tr>
            <td>Traffic Flow</td>
            <td>Y</td><td></td><td>Y</td><td></td><td></td><td></td><td>Y</td>
        </tr>
        <tr>
            <td rowspan="5">Integrity</td><td>Stream with Recovery</td>
            <td></td><td></td><td></td><td>Y</td><td></td><td></td><td>Y</td>
        </tr>
        <tr>
            <td>Stream without Recovery</td>
            <td></td><td></td><td>Y</td><td>Y</td><td></td><td></td><td>Y</td>
        </tr>
        <tr>
            <td>Stream Selective Field</td>
            <td></td><td></td><td></td><td></td><td></td><td></td><td>Y</td>
        </tr>
        <tr>
            <td>Datagram</td>
            <td>Y</td><td>Y</td><td>Y</td><td>Y</td><td></td><td></td><td>Y</td>
        </tr>
        <tr>
            <td>Datagram Selective Field</td>
            <td></td><td></td><td></td><td></td><td></td><td></td><td>Y</td>
        </tr>
        <tr>
            <td rowspan="2">Non-repudiation</td><td>of Origin</td>
            <td></td><td></td><td></td><td></td><td></td><td></td><td>Y</td>
        </tr>
        <tr>
            <td>of Delivery (Receipt)</td>
            <td></td><td></td><td></td><td></td><td></td><td></td><td>Y</td>
        </tr>
    </tbody>
</table>

## 安全, 可靠, 可信

- 可信 (Trustworthy) 系统: 行为是正确且可预期的, 即按照设计意图和预期功能工作. (可能是某种特定功能, 而非普遍安全需求)
- 安全 (Secure Systems) 系统: 能够防止未授权的访问和修改, 确保数据的机密性, 完整性和可用性.
- 可靠 (Reliable Systems) 系统: 能够持续执行预期功能, 故障率较低, 恢复能力强.

> [RFC 4949, 2007] 对安全的定义为:
> 
> **reliability**
> 
>   (I) The ability of a system to perform a required function under
>   stated conditions for a specified period of time. (Compare:
>   availability, survivability.)
> 
> **trust**
> 
>   1. (I) /information system/ A feeling of certainty (sometimes
>   based on inconclusive evidence) either (a) that the system will
>   not fail or (b) that the system meets its specifications (i.e.,
>   the system does what it claims to do and does not perform unwanted
>   functions). 
> 
>   Tutorial: "Generally, an entity is said to 'trust' a second entity
>   when the first entity makes the assumption that the second entity
>   will behave exactly as the first entity expects. This trust may
>   apply only for some specific function. The key role of trust in
>   [X.509] is to describe the relationship between an entity [i.e., a
>   certificate user] and a [CA]; an entity shall be certain that it
>   can trust the CA to create only valid and reliable certificates."
> 
> **trustworthy system**
> 
>   1. (I) /information system/ A system that operates as expected,
>   according to design and policy, doing what is required -- despite
>   environmental disruption, human user and operator errors, and
>   attacks by hostile parties -- and not doing other things.
> 
> **security** 
> 
>   a. (I) A system condition that results from the establishment and
>   maintenance of measures to protect the system.
> 
>   b. (I) A system condition in which system resources are free from
>   unauthorized access and from unauthorized or accidental change,
>   destruction, or loss. (Compare: safety.)
 

## 参考

| TITLE                                                                         | AUTHORS | PUBL / CONF / JOUR | YEAR | VOLUME       | LICENSE  | URL / DOI / ISBN                                                      |
| ----------------------------------------------------------------------------- | ------- | ------------------ | ---- | ------------ | -------- | --------------------------------------------------------------------- |
| <nobr>Internet Security Glossary, RFC 2828 (v1)</nobr>                              | IETF    | RFC 2828               | 2000 |              |          | <https://www.ietf.org/rfc/rfc2828.txt>                                |
| <nobr>Internet Security Glossary, RFC 4949 (v2)</nobr>                              | IETF    | RFC 4949               | 2007 |              |          | <https://datatracker.ietf.org/doc/html/rfc4949>                       |
| <nobr>Glossary of Key Information Security Terms</nobr>                              | NIST    | NIST IR            | 2019 | 7298 Rev.3   |          | <https://csrc.nist.gov/glossary>                                      |
| <nobr>Security and Privacy Controls for Information Systems and Organizations</nobr> | NIST    | NIST SP 800            | 2020 | 800-53 Rev.5 |          | <https://csrc.nist.gov/pubs/sp/800/53/r5/upd1/final>                  |
| <nobr>Guide to Computer Security Log Management</nobr>                                     | NIST    | NIST SP 800            | 2006 | 800-92       |          | <https://csrc.nist.gov/pubs/sp/800/92/final>                          |
|<nobr>NIST Cybersecurity Framework (NIST CSF)</nobr>                                       | NIST    | NIST               | 2014 |              |          |  <https://www.nist.gov/cyberframework>                                                                     |
|<nobr>Evaluation criteria for IT security</nobr>                                           | ISO/IEC | ISO/IEC 15408      | 2022 | Ed.4        |          | <https://www.iso.org/standard/72891.html>                             |
|  <nobr>Information Security management systems</nobr>                                       | ISO/IEC | ISO/IEC 27001      | 2022 | Ed.3        |          | <https://www.iso.org/standard/27001>                                  |
| <nobr>Information Security controls</nobr>                                                 | ISO/IEC | ISO/IEC 27002      | 2022 | Ed.3        |          | <https://www.iso.org/standard/75652.html>                             |
| <nobr>Security architecture for Open Systems Interconnection for CCITT applications</nobr>                    | ITU-T   | ITU-T X.800        | 1991 |              |          | <https://www.itu.int/ITU-T/recommendations/rec.aspx?rec=3102&lang=en> |
| <nobr>Open Systems Interconnection — Basic Reference Model</nobr>                          | ISO     | ISO 7498-2         | 1988 |              |          | <https://www.iso.org/standard/14256.html>                             |
| <nobr>Open Systems Interconnection — Security frameworks for open systems: Overview</nobr> | ISO/IEC | ISO/IEC 10181-1    | 1996 |              |          | <https://www.iso.org/standard/24404.html>                             |
| <nobr>OWASP Cheat Sheet Series</nobr>                                                      | <nobr>Jim Manico, Jakub Mackowski</nobr>   | OWASP              | 2019      | Ed.2              | CC BY-SA | <https://cheatsheetseries.owasp.org/index.html>                       |
