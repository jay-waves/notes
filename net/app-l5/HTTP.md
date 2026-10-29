万维网 (World Wide Web, WWW) 是最大规模的分布式超媒体系统, 通过*统一资源定位符 (URL)* 定位信息资源, 通过 *超文本标记语言 (HTML)* 描述信息资源, 通过*超文本传输协议 (HTTP)* 传递信息资源. URL, HTML, HTTP 是万维网的核心技术.

- HTTP (hyper text transfer protocol, 超文本传输协议). 端口为 80, 加密端口 (https) 为 443. 是无状态协议.
- URL: `<protocol>://<hostname>:<port>/<path>`
- HTML: 目前主流版本是 HTML5.0. 用各类标签 `<tag>` 来表示页面元素, HTML 规定页面结构, *层叠样式表 (CSS)* 规定文档渲染方式.

浏览器 (Browser) 并不是和自家服务器 (Server) 通信, 而是和各个网络公司网页进行通信, 所以在 1990s 诞生了 HTTP 协议, 用于 B/S 架构下的通信. 软件作为客户端 (Client) 和服务器 (Server) 通信, 则称为 C/S 架构, 可以使用 RPC 协议. 目前多端开发中, B/S 和 C/S 在逐渐融合, 通信使用同一的 HTTP, 避免重复开发.

由于 HTTP 协议没有状态, 每次请求之间是相互独立的. 因此使用 [Cookie](../web/auth/sso.md) 来存储多次请求之间的关联.

## URL

|     | sheme     | domain name       | port  | path                 | query             | anchor        |
| --- | --------- | ----------------- | ----- | -------------------- | ----------------- | ------------- |
| URL | `http://` | `www.xxxsite.com` | `:80` | `/path/to/page.html` | `?product=camera` | `#somewhrere` |

查询参数（query）会被发送给服务器，js 中名称为 `location.search`；
而片段标识符（Fragment）则被浏览器前端处理，自动跳转到页面内元素，js 中名称为 `location.hash`。

## 方法

HTTP 定义了多种请求方法 (http 动词), 表示对服务器资源的不同操作. 常见请求方法是 `GET` 和 `POST`.

- `Get` 最常见, 如打开网页操作.
- `Post` 用于提交表单到服务器, 如登录操作.
- `Put` 发送数据更新
- `Delete`
- `Patch` 更新资源
- `Head` 类似于Get, 但没有响应体

## 常见状态码

| 状态码分类 | 含义       |
| ---------- | ---------- |
| 1xx        | 信息提示   |
| 2xx        | 请求成功   |
| 3xx        | 重定向     |
| 4xx        | 客户端错误 |
| 5xx           | 服务端错误           |

| 状态码 | 名称                       | 描述                                                                 |
| ------ | -------------------------- | -------------------------------------------------------------------- |
| 100    | Continue                   | 继续                                                                 |
| 101    | Switching Protocols        | 协议切换, 如服务器根据客户端请求升级到高级协议                       |
| 1xx    |                            | **信息性状态码**                                                     |
| **200**    | OK                         | 请求成功                                                             |
| 201    | Created                    | 已创建, 成功请求并创建了新资源                                       |
| 202    | Accepted                   | 已接收请求, 可能未处理完成                                           |
| 2xx    |                            | **成功状态码**                                                       |
| 301    | Moved Permanently          | 永久移动, 请求的资源已移动到新URI, 浏览器可能会自动重定向.           |
| 302    | Found                      | 资源被临时移动, 回复中 `Location` 字段可能包括新地址                                                       |
| 305    | Use Proxy                  | 请求的资源必须使用代理访问.                                          |
| 3xx    |                            | **重定向状态码**                                                     |
| 400    | Bad Request                | 客户端请求语法错误, 服务器不识别.                                    |
| **401**    | Unauthorized               | 请求需要用户提供身份认证                                             |
| **403**    | Forbidden                  | 服务器可以理解请求, 但是拒绝执行.                                    |
| **404**    | Not Found                  | 服务器无法根据客户端请求找到资源.                                    |
| 405    | Method Not Allowed         | 客户端请求的方法被禁止                                               |
| **408**    | Request Time-out           | 服务器等待客户端发送的请求时间过长, 超时.                            |
| 4xx    |                            | **客户端错误状态**                                                   |
| **500**    | Internal Server Error      | 服务器内部错误, 无法完成请求                                         |
| 501    | Not Implemented            | 服务器不支持请求的功能, 无法完成请求                                 |
| 502    | Bad Gateway                | 作为网关/代理的服务器尝试执行请求时, 从远程服务器接收到一个无效响应. |
| 505    | HTTP Version Not Supported |                                                                      |
| 5xx    |                            | **服务器错误状态码**                                                                     |


## 请求头

在 HTTP 请求报文中,
- 首行格式为: `<Method>\s<URL>\s<Version>\r\n`
- 首部行格式为: `<Field>:\s<Value>\r\n`

| 字段名           | 说明                       | 常见值                                                  |
| ---------------- | -------------------------- | ------------------------------------------------------- |
| `Host`           | 请求的主机名和端口号       | `Host: www.example.com`                                 |
| `User-Agent`     | 客户端浏览器标识符         | `User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64)` |
| `Accept`         | 客户端可处理的内容类型     | `Accept: text/html,application/xhtml+xml`               |
| `Content-Type`   | 请求内容的类型 (用于 POST) | `Content-Type: applcation/json`                         |
| `Content-Length` | 请求主体的长度 (字节数)    | `Content-Length: 348`                                   |
| `Authorization`  | 身份验证凭证               | `Authorization: Basic YWxhZGRpbjpvcGVuc2VzYW1l`         |
| `XFF`            | X-Forwarded-For, 经过代理或负载均衡时, 用此字段保存客户端的真实源 IP 地址.                           |                                                         |


```http
GET /search?q=openai HTTP/1.1
Host: www.example.com
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64)
Accept: text/html,application/xhtml+xml
```

```http
POST /submit-form HTTP/1.1\r\n
Host: www.example.com\r\n
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64)\r\n
Content-Type: application/x-www-form-urlencoded\r\n
Content-Length: 27\r\n
name=John+Doe&age=30\r\n
```

在 HTTP/1.1 版本中, 报文格式是基于文本的, HTTP/2.0 则采用了二进制格式, 并引入了流的概念, 在同一 TCP 连接上实现流的多路复用; HTTP/3.0 则是基于 UDP, 降低 TCP 握手的时延, 实际是 QUIC 协议的标准化.

## HTTP 版本

1. HTTP 1.0, 1996. 每个请求都需要独立的 TCP 连接.
2. HTTP 1.1, 1997. TCP 连接可以持久建立, 便于复用. 但没解决 HOL 问题.
3. HTTP 2.0, 2015. 通过请求多路复用 (Request Multiplexing) 来解决应用层 HOL 问题, 但没解决传输层 HOL 问题. HTTP 2.0 引入了 *HTTP 流* 的概念, 
	允许多个 HTTP 请求乱序使用同一个 TCP 连接.
4. HTTP 3.0, 2020. 使用 QUIC 而非 TCP 协议, 解决了传输层 HOL 问题. QUIC 基于*流*而非*链接*, 因此是属于 UDP 一类, 允许多个流共享同一个连接.

*HOL, Head-of-Line* 问题. 最大并发数有限, 后续请求需要等待前面的请求完成, 即使前面的请求并不活跃.

## HTTP API

在 HTTP 基础上，存在不同的 API 设计规范：
* RESTful，如： `DELETE /users/123`，以资源（对象）为中心管理，动作则遵循 HTTP 方法。
* RPC (Remote Procedure Call)，如：`POST /deleteUser` ，就像远程调用函数。
* SOAP 

### RESTful

RESTful 强调复用 HTTP 的方法语义：
* `GET` 获取资源，安全只读。
* `PUT` 替换资源，注意有幂等性。
* `DELETE` 删除资源，也有幂等性，重复调用返回 404 
* `POST` 提交、创建资源。POST 不保证幂等性。
....

RESTful 强调**无状态**，不应该依赖某些隐含的对话上下文。比如用户身份的鉴权，需要每个 HTTP 
请求中都携带凭据。

一个典型的 RESTful API： `https://xxxxx.com/v1/users/123`

### RPC 

RPC 是有状态的，通过 Cookie 来携带。RPC 通常基于 HTTP 来做设计，但是不用 JSON 等文本格式，
可能用二进制格式，增加序列化性能。


