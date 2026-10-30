上世纪 90 年代兴起的网络安全模型, 围绕分层结构和分区隔离来满足基本安全需求. 其中关键的概念有:
- [Bell-Lapadula 机密性模型, Biba 完整性模型.](security-models.md) 基于强制访问控制 (MAC)
- [OSI 模型和 TCP/IP 协议栈安全模型](../net/internet.md), 主要关注网络层, 传输层和应用层安全技术.
- 各类[防火墙](../net/firewalls&vpn/firewall.md)
- [非军事区模型](../net/net-topology.md) (DMZ, Demilitarized Zone), 用于隔离企业网络中的互联网和内部网络之间的访问.


## 网络通信安全模型

<img src="../attach/img/sec/sec-security-communication-model.avif" alt="" width="500">

四个要素:
- 加密和认证算法
- 秘密信息: 密钥, 秘密参数等
- 秘密信息的分发, 比如密钥管理分发
- 使用 *加密和认证算法* 与 *秘密信息* 以获得安全服务所需的协议 (安全协议)

### 网络信道分类

- 安全信道 (secure channel)
- 认证信道 (authenticated channel): 监听, 但不能篡改.
- 未认证信道 (unauthenticated channel): 监听, 并且可以篡改.

### 网络信道中攻击方式

网络信道中的常见攻击形式:
- 主动攻击
	- 拒绝服务, Denial of Service: 攻击**可用性**
	- 消息篡改, Modification: 攻击**完整性**
	- 伪装, Masquerade: 攻击**真实性**.
	- 重放, Replay. 防御手段有序列号机制, 挑战应答机制, 时间戳(全局时钟)机制.
- 被动攻击
	- 信息内容泄露 (Information Leakage): 窃听, 内部人员操作不慎导致的泄露, 媒体废弃物导致的泄露.
	- 流量分析 (Traffic Analysis)

广义上, "伪装, 重放, 篡改" 都是 "欺骗, Spoofing".

## OSIRM

见 [OSI Reference Model 安全模型](../README.md)

## TCSEC

可信计算机系统评估标准 (TCSEC, Trusted Computer System Evaluation Creteria)[^1]. 因其封面颜色, 也被称为橘皮书 (Orange Book)

TCSEC/TDI 安全级别划分:
- D: Minimal Protection
- C: Discretionary Protection (C2 是安全产品的最低等级)
- B: Mandatory Protection (B2 及以上的产品非常少)
- A: Verified Protection

| 安全级别 | 定义                                             | 对应中国安全保护等级      | 要求功能 |
| -------- | ------------------------------------------------ | ------------------------- | -------- |
| A1       | 验证设计 (Verified Design)                       |                           | DAC+MAC, I&A, 审计, 资源隔离, 形式化         |
| B3       | 安全域 (Security Domains)                        | 第五级 (特级保护), <br> **绝**密级(涉密) | DAC+MAC, I&A, 审计, 资源隔离, 安全域          |
| B2       | 结构化保护 (Structural Protection)               | 第四级 (强制保护), <br> **机**密级(涉密) | DAC+MAC, I&A, 审计, 资源隔离, 架构化         |
| B1       | 标记安全保护 (Labeled Security Protection)       | 第三级 (监控保护), <br> **秘**密级(涉密) | DAC+MAC, I&A, 审计, 资源隔离         |
| C2       | 受控的存取保护 (Controlled Access Protection)    | 第二级 (系统指导保护)                   | DAC, I&A, 审计, 资源隔离         |
| C1       | 自动安全保护 (Discretionary Security Protection) | 第一级 (用户自主保护)                    | DAC, I&A         |
| D        | 最小保护 (Minimal Protection)                    |                           |          |

中国 <信息安全等级保护管理办法> 规定, 涉及重要社会职能的*关键性信息基础设施 (Critical Information Infrastructure, CII)*, 如 银行 交通 能源 医疗 电信等行业, 要求三级及以上保护要求. 关基定义为: 一旦遭受破坏 丢失或泄漏, 可能严重危机国家安全 国计民生和公共利益的网络设施或信息系统. 中国信息安全合规, 还需要考虑 <个人信息保护法> (Personal Information Protction Law, PIPL, 2021) 和 <数据安全法> (2021).

### 审计

将用户对系统的操作记录在 **审计日志 (Audit Log)**. TCSEC-C2 以上级别必须具有审计功能.

管理员三权分立
- 系统管理员: 运行维护.
- 安全管理员: 安全保密管理.
- 安全审计管理员: 对前两者审计跟踪, 检查违规行为.

## 访问控制模型

访问控制分类:
- 基于角色访问控制 (Role-Based Access Control, RAC): 不同角色有不同权限.
- 强制访问控制 (Mandatory Access Control, MAC): 用户和资源都有密级, 通过安全级别的匹配来控制访问.
- 自主访问控制 (Discretionary Access Control, DAC): 资源所有者自行决定谁可以访问资源, 以及访问权限 (读, 写, 执行). 文件系统一般使用该方式, 通过**访问控制列表 (ACL)** 实现.
- 基线访问控制 (Baseline Access Control): 预定义系统最小安全权限基线, 防止系统中出现高风险操作. (安全基线如 最小密码复杂度, 最小角色权限配置, 网络设备配置要求, 强制使用多因素身份认证)
- 基于任务 (Task-Based Access Control, TBAC): 用户执行特定任务时, 才获得所需权限, 完成后被收回.
- 时间限制访问控制 (Time-Based Access Control): 允许在特定时间段和时间限制内访问资源.
- 基于属性访问控制 (Attribute-Based, ABAC), 允许细粒度控制多种属性, **是实际系统中上述策略的混用.**

### MAC

强制存取控制, Mandatory Access Control, MAC. TCSEC/TDI B1+. 访问控制策略由中央权威机构设置, 而不是资源的所有者.

数据对象 (客体) 有敏感度标记称为密级 (Classification Level), 用户有相应敏感度标记的许可证级别 (Clearance Level), 有相应许可证用户才能访问对象.

敏感度标记 (Label, 密级): $TS\geq S\geq C\geq P$
- 绝密, Top Secret, TS
- 机密, Secret, S
- 秘密, Confidential, C
- 公开, Public, P

保密性规则 (MAC-BLP):
- 下读 (read down): 用户级别高于或等于文件级别的读操作.
- 上写 (write up): 用户级别低于或等于文件级别的写操作.

数据完整性规则 (MAC-Biba):
- 下写 (write down): 用户级别高于或等于文件级别的写操作.
- 上读 (read up): 用户级别低于或等于文件级别的读操作.

#### Bell-LaPadula 模型

Bell-Lapadula 模型 (BLP 模型, David Bell & Leonard Lapadula, 1973) 是基于**强制访问控制**的安全模型, 用于保护 **[机密性](../README.md#安全服务及安全机制)**. 广泛用于军事和政府的安全系统.

有两个核心规则:
- 简单安全原则 (Simple Security Property), 也叫**不上读原则**. 用户不能读取比自己权限更高的信息.
- 属性 (Star Property), 也叫**不下写原则**. 用户不能向比自己权限更低的级别写数据.

Bell-LaPadula model
      (N) A formal, mathematical, state-transition model of
      confidentiality policy for multilevel-secure computer systems
      [[Bell](https://datatracker.ietf.org/doc/html/rfc4949#ref-Bell)]. (Compare: Biba model, Brewer-Nash model.)

      Tutorial: The model, devised by David Bell and Leonard LaPadula at
      The MITRE Corporation in 1973, characterizes computer system
      elements as subjects and objects. To determine whether or not a
      subject is authorized for a particular access mode on an object,
      the clearance of the subject is compared to the classification of
      the object. The model defines the notion of a "secure state", in
      which the only permitted access modes of subjects to objects are
      in accordance with a specified security policy. It is proven that
      each state transition preserves security by moving from secure
      state to secure state, thereby proving that the system is secure.
      In this model, a multilevel-secure system satisfies several rules,
      including the "confinement property" (a.k.a. the "*-property"),
      the "simple security property", and the "tranquility property".

#### Biba 模型

Biba 模型 (1977) 是和 BLP 模型对立的概念, 保护 **[完整性](../README.md)** 而不是机密性, 旨在确保数据在修改时不受低完整性主体的污染, 防止系统引入不可靠的数据.

有两个核心规则:
- 简单安全规则 (Simple Integrity Property), 也叫**不下读原则**. 用户不能读取比自己完整性等级更低的数据.
- 完整性规则 (Star Integrity Property), 也叫**不上写原则**. 用户不能向比自己完整性级别更高的数据写入信息.

### DAC

自主存取控制, Discretionary Access Control, DAC. TCSEC/TDI C1+. 允许用户控制自己拥有的资源, 并自行决定文件权限. 不同用户对不同对象分别有不同的存取权限, 并支持权限转授.

浏览器使用访问控制列表来管理文件权限, 数据库使用 `GRANT, REVOKE` 等 [SQL](../db/sql/sql.md) 语句来定义权限. 该过程也被称为 "授权".

### RBAC

基于角色的访问控制, Role-Based Access Control, RBAC. 将权限附于角色中, 再将用户与特定角色绑定.

![](../attach/img/sec/RBAC.avif)

- 最小权限原则: 为用户角色配置其所需最小权限集
- 责任分离原则: 调用相互独立互斥的角色共同完成敏感任务
- 数据抽象原则

TE (Type Enforcement?)

...

RFC4949 P254....

role-based access control
      (I) A form of identity-based access control wherein the system
      entities that are identified and controlled are functional
      positions in an organization or process. [[Sand](https://datatracker.ietf.org/doc/html/rfc4949#ref-Sand)] (See:
      authorization, constraint, identity, principal, role.)

      Tutorial: Administrators assign permissions to roles as needed to
      perform functions in the system. Administrators separately assign
      user identities to roles. When a user accesses the system in an
      identity (for which the user has been registered) and initiates a
      session using a role (to which the user has been assigned), then
      the permissions that have been assigned to the role are available
      to be exercised by the user.

      The following diagram shows that role-based access control
      involves five different relationships: (a) administrators assign
      identities to roles, (b) administrators assign permissions to
      roles, (c) administrators assign roles to roles, (d) users select
      identities in sessions, and (e) users select roles in sessions.
      Security policies may define constraints on these assignments and
      selections.

Shirey                       Informational                    [Page 254]

---

[RFC 4949](https://datatracker.ietf.org/doc/html/rfc4949)         Internet Security Glossary, Version 2       August 2007

         (c) Permission Inheritance Assignments (i.e., Role Hierarchy)
                               [Constraints]
                                  +=====+
                                  |     |
                   (a) Identity   v     v  (b) Permission
      +----------+  Assignments  +-------+  Assignments  +----------+
      |Identities|<=============>| Roles |<=============>|Permissions|
      +----------+ [Constraints] +-------+ [Constraints] +----------+
           |   |                   ^   ^
           |   |   +-----------+   |   |       +---------------------+
           |   |   | +-------+ |   |   |       |       Legend        |
           |   +====>|Session|=====+   |       |                     |
           |       | +-------+ |       |       |     One-to-One      |
           |       |    ...   |       |       | =================== |
           |       | +-------+ |       |       |                     |
           +========>|Session|=========+       |     One-to-Many     |
      (d) Identity | +-------+ |  (e) Role     | ==================> |
       Selections  |           | Selections    |                     |
      [Constraints]|  Access   |[Constraints]  |    Many-to-Many     |
                   | Sessions  |               | <=================> |
                   +-----------+               +---------------------+

   $ role certificate
      (I) An organizational certificate that is issued to a system
      entity that is a member of the set of users that have identities
      that are assigned to the same role. (See: role-based access
      control.)


[^1]: U.S. DoD Computer Security Center, "Department of Defense Trusted Computer System Evaluation Criteria", CSC-STD-001-83, 15 August 1983. (Superseded by DoD1)
