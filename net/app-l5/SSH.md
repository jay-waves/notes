## Telnet

远程的登录协议 (Teletype Network, TELNET) 是早期远程登陆服务的标准协议. Telnet 并不对会话报文进行保密, 所以安全性很差, 目前带会话加密的 SSH 协议已经成为远程登录的标准协议. Telnet 使用 TCP 链接, 端口为 23 

## SSH

SSH, Secure Shell, 是一种远程登录会话安全协议, 支持身份认证和数据加密. 使用 TCP 22 端口.

## 原理

ssh 协议建立远程连接的步骤:
1. **建立 TCP 连接**
2. **协商协议版本号, 协商密码算法**
3. **密钥建立**: 用 [DH](../../sec/cryptography/public-key-crypto/diffie-hellman.md) 或 [ECDH](../../sec/cryptography/public-key-crypto/ECC/ECC.md) 密钥交换算法生成会话密钥 $K$, 会话 ID. $K$ 用于保密后续的认证和数据传输.
4. **服务器认证用户**: 口令 (Password) 认证或公钥认证, 若成功则继续
5. **加密通信**: 使用 $K$ 进行加密通信, 对称加密 TCP 的载荷部分.

公钥认证 (免密登录):
1. 客户端提前将公钥 $K_P$ 发送给服务器存储
2. 客户端发送 $\{User,\ K_P\}_K$, 服务器检查 $K_P$, 若存在继续
3. 服务器发送 $\{Challenge\}_{K_P}$, 客户端得到 $Challenge$
4. 客户端发送 $digest\{Challenge,\ K\}$, 服务器比对.

用户认证服务器: 每个 SSH 服务器会有主机密钥对 (公钥和私钥) 用于表示服务器身份.
1. 服务器初次连接时, 会向客户端发送它的 *主机公钥*. 同时提醒用户是否信任服务器的主机公钥. (输入 `yes`)
2. 在后续连接中, 客户端通过主机 `IP` 在缓存 `~/.ssh/known_hosts` 中寻找对应 *主机公钥*.
4. 在连接的**密钥建立**步骤, 服务器会用 *主机私钥* 对协商结果进行签名, 客户端用 *主机公钥* 对服务器进行认证.

> 由于 SSH 的灵活性和广泛性, SSH 没有引入证书机制, 首次连接时确实存在被冒充安全风险. 在使用场景中, 如用户远程登录公司服务器, 可以通过其他方式检查服务器的公钥是否被冒充, 如直接给公司致电.

***

## SSH 使用

开源软件 OpenSSH 是 SSH 协议的一种实现, 服务端称为 sshd, 客户端称为 ssh.

### 初始化

`ssh-keygen -t rsa -C "email@xxx.com"`, `-t`代表类型, 有RSA和DSA两种. 

生成公钥, 默认存放于 `~/.ssh`, 有私钥 `~/.ssh/id_rsa`, 和公钥 `~/.ssh/id_rsa.pub`.  其中 `id_rsa` 权限是 600.

### 配置与登录

自定义配置, 在 `~/.ssh/config`, 文件结构如下:

```ssh
Host yjw_num1 # 定义主机别名
ServerAliveInterval 30
HostName 122.22.222.102 # 主机IP
Port 33033 # ssh 端口
User yjw
IdentityFile /home/yjw/.ssh/id_rsa # 私钥
ProxyCommand ssh ...
```

指定用户登录: `ssh yjw@192.168.0.103`

指定端口号登录: `ssh ssh 192.168.0.103 -p 2022`, 默认端口号是 22

### 配置多个SSH密钥

可能对多个网站, 需要不同ssh公钥. 比如github和gitlab使用不同的ssh. 默认只读取 `~/.ssh/id_rsa`, 

首先 `~/.ssh/id_rsa` 命名需要不同. 这个ssh publickey在gitlab等服务器网站设置中输入.

其次, 配置 `~/.ssh/config`:

```
# Host1
Host github.com
	HostName github.com
	User git
	PreferredAuthentications publickey
	IdentityFile ~/.ssh/id_rsa
Host gitlab.com
	HostName gitlab.com
	User git
	PreferredAuthentications publickey
	IdentityFile ~/.ssh/id_rsa2
	Port 5337 # ssh的端口号
```

Host 相当于一个别名, 替代为下面的 HostName. 这里有个坑, *如果路径包含特殊字符, 比如', 需要用双引号括起来.*

验证 `ssh -T git@github.com1`. 

### 配置服务器

启动/关闭服务:
```bash
systemctl start sshd (enable 保持启动)

systemctl stop sshd
```

## 其他配置

`-L`, `-D`

配置 `~/.ssh/config`: 防止特定网络环境下连接断开, 压缩数据, 多通道等
```
      TCPKeepAlive=yes
      ServerAliveInterval=15
      ServerAliveCountMax=6
      Compression=yes
      ControlMaster auto
      ControlPath /tmp/%r@%h:%p
      ControlPersist yes
```

ssh 有一个替代品 [`mosh`](https://mosh.org), 使用 UDP 协议, 连接更稳定并且带宽需求更少. 但是服务端也需要配置, 因为通常不内置.

