
**缓冲 I/O**, 指是否利用标准库缓冲. 利用标准库缓冲时, 程序遇到换行时才输出, 避免频繁系统调用.

I/O 分为两个过程:
1. 数据准备, 此时内核中数据尚未准备好.
2. 数据从内核空间拷贝到用户进程缓冲区.

|              | 数据准备                                    | 数据拷贝          | 系统调用              |
| ------------ | ------------------------------------------- | ----------------- | --------------------- |
| 阻塞 I/O     | `read()` 阻塞等待, 直到数据拷贝结束才返回   | `read()` 阻塞等待 | `read`                |
| 非阻塞 I/O   | `read()` 阻塞轮询, 立即返回, 但持续轮询     | `read()` 阻塞等待 | `read, poll`          |
| I/O 多路复用 | `select()` 阻塞等待, 释放 CPU, 直到事件通知 | `read()` 阻塞等待 | `select, epoll, read` |
| 异步 I/O   | `aio_read()` 立即返回                       | 内核自动完成数据拷贝, 事件通知                  | `aio_read`            |

统称阻塞 I/O, 非阻塞 I/O, 基于非阻塞 I/O 的多路复用为**同步 I/O**. 它们在数据拷贝阶段都是要等待的, 也就是同步的.

## select 

`select()` 是多路 I/O 复用的接口. 允许进程被内核挂起, 当 I/O 事件发生时, 再将控制权返回给用户.  

文件描述符 `fd` 被映射到 `fd_set` 位图, `1` (set) 代表在下次 `select()` 时检测该描述符是否有事件 (R, W, ERR). 如果有事件未发生, 对应的位会被设置为 `0` (unset). 

```c
struct timeval {
	long tv_sec; 
	long tv_usec; // microseconds
};

/*
	返回 n, 如果有就绪描述符.
	返回 0, 代表超时
	返回 -, 代表出错
	
	描述字集合表示为: {readset, writeset, exceptset}
	
	select 是阻塞调用. 配置超时:
	- timeout = null, 表示持续阻塞
	- timeout.sec = 0, 表示不等待, 检测完立即返回
	- timeout.sec = n, 配置超时时间
	  
	nfds = maxfd + 1. 用于 fd_set 位图掩码操作.
*/
int select(int nfds, 
		fd_set *readset, 
		fd_set *writeset, 
		fd_set* exceptset, 
		const struct timeval *timeout
);

// 配置宏. fd
void FD_ZERO(fd_set *fdset);
void FD_SET(int fd, fd_set *fdset);
void FD_CLR(int fd, fd_set *fdset);
int FD_ISSET(int fd, fd_set *fdset);
```

### 例子

使用实例: 使用 `select()` 同时监控 标准输入 StdIn 和某个网络 Socket.

```c

fd_set readmask;
fd_set allreads;
FD_ZERO(&allreads);
FD_SET(0, &allreads);
FD_SET(socket_fd, &allreads); // user defined socket_fd 

for (;;) {
	/*
		注意这里, 将干净副本 allreads 复制给 readmask. 
		因为每次调用 select, readmask 都可能被修改.
	*/
	readmask = allreads; 
	int rc = select(socket_fd + 1, &readmask, NULL, NULL, NULL);
	
	if (rc <= 0) {
		error(...)
	}
	
	if (FD_ISSET(socket_fd, &readmask)) {
		...
	}
	
	if (FD_ISSET(STDIN_FILENO, &readmask)) {
		...
	}
}
```

<mermaid src="charts/select-1.mmd"></mermaid>

### fd 数量限制

每个进程的最大 `fd` 数量有限制, 可以用 `ulimit -n` 查看, 或者查看 `FD_SETSIZE`. 当 `fd` 耗尽时, 相关系统调用会返回错误码 `errno = EMFILE` 或 `errno = ENFILE`. 

详见 [linux-vfs](../fs/linux-vfs.md). `fd` 数目确实不够时, 推荐用 [poll/epoll](poll.md) 替代 select.