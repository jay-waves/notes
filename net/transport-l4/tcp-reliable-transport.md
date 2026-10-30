
## 可靠传输原理

可靠信道的假设:
- 信道不产生差错, 丢包或延迟.
- 不管发送速度多快, 接收方总来得及处理收到的数据.

### 停止等待协议

首先, 去掉假设条件 (2): 接收方总有足够的接受能力. 此时需要我们增加*流量控制机制*, 抑制发送端速度, 使接收端来得及处理. 

#### PDU 出错或丢失

#### ACK 出错或丢失

#### Nagle 算法

限制卡车装图钉. Nagle (RFC 896) 认为: 在任何时刻, 未被确认的小数据包 (长度小于最大报文段长度 MSS 的 TCP 分组) 不能超过一个. 新的小数据放到缓冲区, 直到以下任一条件满足:
1. 所有已发数据都被确认 (收到 ACK)
2. 缓冲区中的数据足够填满一个 MSS (最大分段大小)

这样, 小数据被合并为大数据段 (segment), 递交给下层 IP. 这样节省了 TCP 头部的空间. 

#### 延迟 ACK 算法

收到数据后, 并不马上回复, 而是等待一段时间. 在下次有数据需要发送给对端时, 再将累计的 ACK 捎带一并发送. 

但是, ACK 延迟算法, 一般不推荐和 Nagle 算法一起使用: 发送端发出小数据包后, 根据 Nagle 算法持续等待 ACK; 但是对端启用了延迟 ACK, 不会马上发送 ACK, 导致双方总延迟增加. POSIX Socket 支持关闭 Nagle 算法, 但是并不推荐, 协议栈通常已经优化了该问题:

```c
int on = 1;
setsockopt(sock, IPPROTO_TCP, TCP_NODELAY, (void *)&on, sizeof(on));
```

#### 停等协议的新年到利用率

### 滑动窗口协议

拥塞控制: 控制网络输入不超过网络负载

#### 回退 N 步的滑动窗口协议

### 选择重传协议

## TCP 可靠传输

TCP 发送窗口可以划分成四个部分：
* 已经发送并且确认的 TCP 段（已经发送并确认）
* 已经发送但是没有确认的 TCP 段（已经发送未确认）
* 未发送但是接收方准备接收的 TCP 段（可以发送）
* 未发送并且接收方也并未准备接受的 TCP 段（不可发送）

对于流量控制，TCP 接收端只允许发送端发送缓冲区大小能容纳的数据，当缓冲区不够时，主动提示发送方降低发包速率，防止丢包。TCP 使用的流量控制协议是可变大小的滑动窗口协议。

对于拥塞控制，TCP 考虑网络的拥塞程度，视自身的网络情况，维护拥塞窗口，表示其认可的网络中合理的传输数据量。**最终发送数据大小，由滑动窗口和拥塞窗口的最小值决定**。

### 流量控制



### 拥塞控制

TCP 协议中, 拥塞控制通过拥塞窗口来完成.  在启动时, TCP 通过"慢启动"来逐步增加发送速度, 直到某个阈值. "慢启动"后, 通过"拥塞避免", 动态地调整拥塞窗口的大小. 在任意时刻, TCP 发送速度, 取决于拥塞窗口和发送窗口的最小值: 当发送的字节数显然大于拥塞窗口, 数据包就不会被发送. 

<img src="../../attach/img/net/net-transport-congestion-control.avif" alt="" width="350">

<img src="../../attach/img/net/congestion-control-slow-start.avif" alt="" width="500">

**慢启动算法**: TCP 会慢慢地提高网络发送速度, 直到某个阈值. 

```
Initialize ssthesh = ?
Initialize cwnd <- 1 // 1 MSS
For (each segment ACKed):
	cwnd <- cwnd + 1
Until (loss event OR cwnd > ssthresh):
```

<img src="../../attach/img/net/congestion-control-automaton.avif" alt="" width="500">

算法流程:

```
cwnd = 1
loss_event = { 3ACK, TimeOut, None }
state = { SlowStart, CongestionAvoid }

Loop:
	send cwnd * TCP segments;
	If (state == SlowStart):
		For (each segmaent ACKed):
			cwnd <- cwnd + 1;
	Else If (state == CongestionAvoid):
		cwnd <- cwnd + 1;

	# state convert
	If (loss_event == 3ACK):
		ssthresh <- cwnd/2;
		cwnd <- ssthresh;
	Else If (loss_event == TimeOut):
		ssthresh <- cwnd/2;
		cwnd <- 1;
	Else If (cwnd > ssthresh):
		state <- CongestionAvoid
	Else:
		state <- state;
```

`MaxWnd = Min[rwnd, cwnd]`


[^1]: 谢希仁, *计算机网络*, 经典讲解方式, 这里不做修改.
