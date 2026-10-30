UBI (Unsorted Block Images) 是用于裸 Flash 的文件系统管理层, 比较适合嵌入式设备. 

与 YAFFS2 和 JFFS2 相比, 它更适合大容量 NAND Flash. 

## 内核模块架构

<img src="../../attach/img/os/vfs2flash.avif" alt="" width="400">

* MTD (memory technology device) 提供了对 Flash 裸硬件的抽象和基础接口
* UBI . 专为 NAND Flash 设计, 负责坏块管理和磨损均衡 (wear leveling). 并在 MTD 之上, 提供逻辑卷管理的功能.
* UBIFS 是运行于 UBI 上的文件系统. 

对于 U 盘 / SSD / SD 等设备, 它们通过 FTL 抽象为*块设备*, 供传统磁盘文件系统使用. 而 MTD 设备既不是字符设备, 也不是块设备. MTD 设备一般出现在 `/dev/mtdX`

## 日志型文件系统

ubifs 是 LFS (Log-Structured File System)，写入效率和崩溃一致性很高, 但定期需要垃圾回收（GC）

LFS 原理详见 [LSM-Tree](../../db/storage/lsm-tree.md)
