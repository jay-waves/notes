
## 网络应用的性能

Network Performance:
- throughput. measured by the ability of a **single endpoint** to process a large volume of messages
- response time. 
	- latency. measured by the time for messages to travel between **two endpoitns**.
	- queueing delays. 
	- jitter (抖动) variation or occasional outliers in network delay 


Metrics: 
* QPS (Query per Second) 
* Latency 
* **Mean Response Time**: useful to estimating throughput limits 
* **p50, p95, p99 (percentiles)**: useful to measure how bad the outliers (*tail latencies*) are. Even if only one backend call is slow, the chance of getting a slow result increases if an end-user request requires multiple backend calls (木桶效应)


*HOL, Head-of-Line* (护航效应). small number of slow requests to hold up the processing of subsequent requets. 

<img src="../../attach/img/db/p99.avif" alt="ddis-f2-1" width="600">

### Batching 

ZeroMQ 将多个消息合并为一次请求处理, 避免频繁地系统调用, 从而增加系统的吞吐量. 但*批处理 (batching)* 会增加延迟, 同一批次的最先抵达的网络包, 其延迟也最大. 最佳实践是, 当消息速率超过网络带宽 (bps, msg/s...) 时, 打开网络批处理, 避免消息排队; 批处理应在整个网络栈的尽可能上层开启, 减少整体资源开销.

TCP 中的批处理算法被称为 *Nagle's Algorithm*, 通常网络场景总有消息排队 (queueing effect), 推荐开启.

![](../../attach/img/db/net-0mq-batch-processing.avif)

![](../../attach/img/db/net-zmq-batch-processing.avif)
