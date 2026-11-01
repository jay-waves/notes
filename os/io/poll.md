## poll

`poll()` 是另一种 [I/O 复用方式](select.md). `poll()` 解决了 `select()` 的文件描述符有限的缺点. 但是 `poll()` 和 `select` 性能几乎一致, 注意到每次返回后必须要线性扫描 `pollfd[]` 来检查 `revents`, 性能随监听数线性下降.

```c
struct pollfd {
	int fd;        // file descriptor
	short events;  // events to look for
	short revents; // events returned
};

/*
	timeout:
	- timeout < 0, 阻塞
	- timeout = 0, 不阻塞, 立即返回
	- timeout > 0, 等待指定毫秒数后返回
*/
int poll(struct pollfd *fds, unsigned long nfds, int timeout);

// 定义一些请求事件掩码:
#define POLLIN 0x0001 // any readable data available
#define POLLRI 0x0002 // OOB/URG readable data
#define POLLOUT 0x0004 // fd is writeable
#define POLLRDNORM 0x0040 // non-OOB/URG data available 
#define POLLRDBAND 0x0080 // OOB/URG readable data
#define POLLWRNORM POLLOUT 
#define POLLWRBANED 0x0111 // OOB/URG data can be written

// 只在 revents 中存在的事件
#define POLLERR 0x0008
#define POLLHUP 0x0010
#define POLLNVAL 0x0020
```

`poll` 每次检测事件之后, 不会修改 `events` 掩码, 而是将结果写到 `revents` 字段. 

### 实例

```c
struct pollfd event_set[INIT_SIZE];
event_set[0].fd = listen_fd;
event_set[0].events = POLLRDNORM;

int i; 
for (i = 1; i < INIT_SIZE; i++) {
	event_set[i].fd = -1; // 表示未占用
}

for(;;) {
	if ((ready_num = poll(event_set, INIT_SIZE, -1)) < 0 ) {
		error (...)
	}
	
	if (event_set[0].revents & POLLRDNORM) {
		socklen_t client_len = sizeof(client_addr);
		conn_fd = accept(listen_fd, (struct sockaddr*)&client_addr, &client_len);
		// 将该套接字记录在 events 监听
		for (i = 1; i < INT_SIZE; i++) {
			if (event_set[i].fd < 0) {
				event_set[i].fd = conn_fd;
				event_set[i].events = POLLRDNORM;
				break;
			}
		}
	}
			
	if (i == INIT_SIZE) {
		error(...)
	}
	
	if (--ready_num <= 0)
		continue;
		
	for (i = 1; i < INIT_SIZE; i++) {
		int socket_fd; 
		if ((socket_fd = event_set[i].fd) < 0) 
			continue;
			
		if (event_set[i].revents & (POLLRDNORM | POLLERR)) {
			if ((n = read(socket_fd, buf, MAXLINE)) > 0) {
				...
			} else if (n = 0 || errno == ECONNRESET) {
				close(socket_fd);
				event_set[i].fd = -1;
			} else {
				error(...);
			}
			
			if (--ready_num <= 0)
				break;
		}
	}
}
```

<mermaid src="charts/poll-1.mmd"></mermaid>

## epoll 

epoll 是 Linux 对 POSIX select/poll 调用的改进版. `epoll` 从阻塞返回时, 只返回就绪的文件描述符, 调用者不必线性扫描. 

```c
/*
	返回 -1 表示出错.
	返回 n 表示 epoll 实例: epfd
	
	当前版本, size 参数实际无意义.
*/
int epoll_create(int size);
int epoll_create1(int flags);

/*
	通过 epoll_ctl 配置 epoll 实例. 
	
	op:
	* EPOLL_CTL_ADD 注册 fd 对应的事件
	* EPOLL_CTL_DEL: 删除 fd 对应的事件
	* EPOLL_CTL_MOD: 修改 fd 对应的事件
*/
int epoll_ctl(int epfd, int op, int fd, struct epoll_event *event);
```

常见实践:

```c
typedef union epoll_data {
	void    *ptr;
	int      fd;
	uint32_t u32;
	uint64_t u64;
} epoll_data_t;

struct epoll_event {
	uint32_t events;    /* epoll events */
	epoll_data_t data;  /* user data variable */
};
```

epoll 支持两种触发模式
* 水平触发 (LT), 每次条件满足时, `epoll_wait` 都会返回
* 边缘触发 (ET), 只在状态变化时, 触发一次. 要求一次性将 IO 操作完成. 

<mermaid src="charts/poll-2.mmd"></mermaid>