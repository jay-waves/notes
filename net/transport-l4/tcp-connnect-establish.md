
## 连接

TCP 三次握手建立连接, 四次挥手释放连接

==(换成时序图)==

<img src="../../attach/img/net/net-transport-tcp-three-way-handshake.avif" alt="" width="400">


<img src="../../attach/img/net/net-transport-tcp-four-way-teardown.avif" alt="" width="400">

启用延迟确认后, 挥手的第二三个可能合并为一个.

TCP 状态机:

### TIME_WAIT 

**主动断开链接的一方**, 在四次挥手结束后, 进入 `TIME_WAIT` 状态, 持续等待 2MSL (Maximum Segment Lifetime). 在 Linux 下一般为 60s.

`TIME_WAIT` 状态, 是为了确保最后的 `ACK` 报文被被动关闭方成功接受. 如果对方没有接受到 `ACK`, 就会重新发送一个 `FIN`, 此时处于 `TIME_WATI` 状态的主动方就会重新发送 `ACK`. 

另一个问题是, 上一 TCP 链接的报文可能在网络中滞留, 在关闭链接后才抵达对端. 此时如果双方在同样的 (收发IP, 收发端口) 建立了新链接, 就可能将迷走报文视为新链接的报文, 扰乱数据完整性. `TIME_WAIT` 状态等待 2MSL, 是为了让旧链接的所有报文都自然消亡.

**但是, 在高并发主机上, TIME_WAIT 会导致端口资源迅速耗尽**. 解决方式: MSL 是硬编码的值, 直接修改然后重编译内核即可; 或者, 配置 `socket_linger.l_linger=0`, 使用 `RST` 替代四次挥手, 强行关闭 (这要求被动关闭方能意识到 `recv()` 返回 RST 异常); 或者, 引入 TCP 的时间戳机制, 主动丢弃过期的报文.

### TCP Keep-Alive 

TCP 的保活机制. 一段时间静默期后, TCP 进入保活状态, 每隔一段时间, 发送一个探测报文. 如果连续几个探测报文未得到响应, 系统会认为 TCP 链接失效.

在 Linux 中, 变量定义为:
- `net.ipv4.tcp_keepalive_time`: 经过该时间后, 进入保活状态. 默认为 2H.
- `net.ipv4.tcp_keepalive_intvl`: 在保活状态中, 发送探测报文的时间间隔. 
- `net.ipv4.tcp_keepalive_probes`: 重复探测次数

由于默认的 Keep-Alive 时间很长, 更推荐在应用层实施保活机制. 比如 PING-PONG 机制. 
