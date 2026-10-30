
## Third-Party Library

符号推导不推荐使用 `sympy`, 使用 Wolfram Mathematica 更方便.
- manim
- numpy
- [pyarmor](https://github.com/dashingsoft/pyarmor), Python 源码混淆工具

推荐使用 `uv` 进行包管理，替代 `setuptools` 及传统 Python 工具。

## Standard library

| 类型                 | 库                                                                                           | 描述                           |     |
| -------------------- | -------------------------------------------------------------------------------------------- | ------------------------------ | --- |
| 文本处理服务         | string                                                                                       |                                |     |
|                      | re                                                                                           | 正则表达式                     |     |
|                      | difflib                                                                                      | 计算差异                       |     |
|                      | textwrap                                                                                     | 文本自动换行与填充             |     |
|                      | readline                                                                                     | GNU readline 接口              |     |
|                      | pprint                                                                                       | 数据美化                       |     |
| 二进制数据服务       | struct                                                                                       | 将字节串解读为打包的二进制数据 |     |
| 数据类型             | [datetime](../../os/linux/localization.md)                                               | 基本日期和事件                 |     |
|                      | calendar                                                                                     | 通用日历                       |     |
|                      | [collections](std/collections.md), [collections.abc](std/collections.abc.md) | 容器                           |     |
|                      | [heapq](std/heapq.md)                                                                | 堆队列算法                     |     |
|                      | [bisect](std/bisect.md)                                                              | 数组二分算法                   |     |
|                      | array                                                               | 高效的数字值数组               |     |
|                      | weakref                                                                                      | 弱引用                         |     |
|                      | types                                                                                        |                                |     |
|                      | copy                                                                                         | 浅层及深层拷贝                 |     |
|                      | enum                                                                                         | 枚举类型                       |     |
| 数学                 | numbers                                                                                      | 数字抽象基类                   |     |
|                      | math                                                                                       | 基础数学函数                   |     |
|                      | cmath                                                                                        | 复数的数学函数                 |     |
|                      |  decimal                                                                               | 十进制定点和浮点算术           |     |
|                      | fractions                                                                              | 有理数                         |     |
|                      | random                                                                                       | 伪随机数                       |     |
|                      | statistics                                                                                   | 统计函数                       |     |
| 函数式编程           | itertools                                                    |                                |     |
|                      | reduce                                                         |                                |     |
|                      | functools                                                                                    |                                |     |
|                      | operator                                                                                     |                                |     |
| 文件系统             | pathlib                                                                                      | 面向对象的文件系统路径         |     |
|                      | os.path                                                                                      | 常用的路径操作                 |     |
|                      | fileinput                                                                                    | 迭代来自多个输入流的行         |     |
|                      | filecmp                                                                                      | 文件或目录比较                 |     |
|                      | tempfile                                                                                     | 临时文件                       |     |
|                      | shutil                                                                                       | 高层次文件操作                 |     |
| 数据持久化           | pickle                                                                                       | Python 对象序列化              |     |
|                      | copyreg                                                                                      | 注册 pickle 支持函数           |     |
|                      | shelve                                                                                       | Python 对象持久化              |     |
|                      | marshal                                                                                      | 内部 Python 对象序列化         |     |
| 数据压缩, 加密和归档 | zlibe, gzip, bz2, lzma, zipfile, tarfile                                                     |                                |     |
|                      | hashlib                                                                                      |                                |     |
|                      | hmac                                                                                         |                                |     |
|                      | secrets                                                                                      |                                |     |
| 通用操作系统服务     |  path                                                                                       | 系统调用接口                   |     |
|                      | [io](std/io.md)                                                                                           | 处理流的核心工具               |     |
|                      | time                                                                                         | 时间的访问和转换               |     |
|                      | argparse, getopt                                                                             | 命令行参数解析                 |     |
|                      | getpass                                                                                      | 密码输入                       |     |
|                      | [logging](std/logging.md)                                                                                   | 日志                           |     |
|                      | curses                                                                                       | 字符终端显示                   |     |
|                      | errno                                                                                        |                                |     |
|                      | ctypes                                                                                       | Python 的外部函数库            |     |
| [并发执行](py-concurrency.md)             |  threading                                                                             | 线程并行                       |     |
|                      | multiprocessing                                                                              | 进程并行                       |     |
|                      | concurrent                                                                                   |                                |     |
|                      | subprocess                                                                                | 子进程管理                     |     |
|                      | sched                                                                                        | 事件调度                       |     |
|                      | queue                                                                                 | 同步队列类                     |     |
| 进程间通信           |   asyncio                                                                               | 异步 I/O                       |     |
|                      | socket                                                                                       | 低层次网络接口                 |     |
|                      | ssl                                                                                          | 套接字的 TLS/SSL 包装          |     |
|                      | select, selectors                                                                            | 等待 I/O 完成                  |     |
|                      | signal                                                                                       | 异步事件处理器                 |     |
|                      | mmap                                                                                         | 内存映射文件                   |     |
|                      | multiprocessing.shared_memory                                                                | 共享内存                       |     |
| 互联网数据处理       | email, mailbox, mimetypes                                                                    |                                |     |
|                      | json                                                                                         |                                |     |
|                      | urllib                                                                                       |                                |     |
|                      | base64                                                                                       | base16, base32, base64, base58 |     |
|                      | binascii                                                                                     | 二进制与 ASCII 间转换          |     |
| 结构化标记工具       | html                                                                                         |                                |     |
|                      | xml                                                                                          |                                |     |
| 开发工具             | [typing](std/typing.md)                                                                                      | 类型提示加强                   |     |
|                      | doctest                                                                                      |                                |     |
|                      |  unittest                                                                                | 单元测试                       |     |
|                      | unittest.mock                                                                              |                                |     |
|                      | test                                                                                         | 回归测试                       |     |
| 调试分析             | bdb, pdb                                                                                     | 调试器                         |     |
|                      | profile                                                                | 性能分析器                     |     |
|                      | timeit                                                                                       | 测试小段代码的执行时间         |     |
|                      |  trace                                                                                   | 追踪语句执行                   |     |
|                      | tracemalloc                                                                                  | 追踪内存分配                   |     |


## Zen of Python

```
>>> import this
The Zen of Python, by Tim Peters

Beautiful is better than ugly.
Explicit is better than implicit.
Simple is better than complex.
Complex is better than complicated.
Flat is better than nested.
Sparse is better than dense.
Readability counts.
Special cases aren't special enough to break the rules.
Although practicality beats purity.
Errors should never pass silently.
Unless explicitly silenced.
In the face of ambiguity, refuse the temptation to guess.
There should be one-- and preferably only one --obvious way to do it.
Although that way may not be obvious at first unless you're Dutch.
Now is better than never.
Although never is often better than *right* now.
If the implementation is hard to explain, it's a bad idea.
If the implementation is easy to explain, it may be a good idea.
Namespaces are one honking great idea -- let's do more of those!
```

## Reference

Effective Python, 59 Specific Ways to Write Better Python - Brett Slatkin

Python 3.10.4 Documentation.