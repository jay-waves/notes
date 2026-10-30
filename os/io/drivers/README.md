
无操作系统时:

``` 
应用软件 --> 设备驱动 --> 硬件
```

有操作系统时: Linux 负责统一定义各类设备的外部接口.

```
userspace --> /dev/xxx --> VFS --> driver --> hardware 
```

<img src="../../../attach/img/os/linux-subsystems.avif" alt="" width="700">

设备驱动针对的对象是存储器和外设 (包括 CPU 中集成的存储器), 而不是 CPU 内核. Linux 对**用户态**暴露的统一外设驱动主要有三类:
1. 字符设备驱动: 以串行顺序依次进行访问的设备, 按字节访问和传输. 文件类型为 `c`
2. 块设备驱动: 以任意顺序进行访问的设备, 按内存块访问和传输. 文件类型为 `b`
3. 网络设备驱动: 使用套接字接口, 接受和发送数据包.

**设备文件的名称不是唯一标识符，Linux 真正的设备标识符是*主设备号*和*从设备号*，主设备号标识驱动程序，从设备标识具体硬件，一般而言一个驱动程序可以管理多个同类硬件设备**。

```bash
brw-r-----1 root disk 8, 0 /dev/sda  # 磁盘。这里共享主设备号，意味着用同一个 SATA 总线。
brw-r-----1 root disk 8, 1 /dev/sda1 # 磁盘分区1
brw-r-----1 root disk 8, 2 /dev/sda2 # 磁盘分区2
brw-r-----1 root disk 8, 5 /dev/sda5
brw-r-----1 root disk 8, 6 /dev/sda6
brw-r-----1 root disk 8, 7 /dev/sda7
```


## 内核态的外设分类

虽然通过 VFS 提供的设备抽象统一为三类，但内核中的设备类型非常多：

linux/drivers/
- char/ 字符设备
	- char/dev/null, char/dev/zero 
	- char/dev/ttyS* 串口 (legacy), 后迁移到专属的子系统
- block/ 块设备
	- block/dev/sdX 
- net/ 网络设备 
- spi/
- i2c/
- gpio/
- pwm/ PWM 输出设备
- iio/ 工业 IO 子系统, 如 ADC/DAC/LIDAR/IMU 
- input 
- gpu/ 
- virtio/ 虚拟化 IO
- kvm


## linux 设备注册

## 块设备

如硬盘 `/dev/sda` 、USB `/dev/sdb`

接口详见  [!drivers/bdev](bdev.md)

## 字符设备

如 键盘、鼠标 `/dev/input/mice`、串口 `/dev/ttyS0` ，实际种类很杂。

接口详见 ![drivers/cdev](cdev.md)

## 总线系统与设备发现

#### 设备注册

内核启动时, 先加载*总线驱动*. 总线驱动将扫描总线上的所有设备, 如果得到设备响应,
就会注册一个对象 `struct device`, 并挂载到对应总线下面.
- pci_dev
- usb_device
- i2c_client ...

设备的种类繁多, 硬件能力也多样, 使用 DMA, IRQ, MMIO, ACPI 等等方式和主机通信. 

#### 驱动注册

内核发现*设备*后, 会注册与设备型号匹配的具体*驱动*, 然后向上层提供接口:
- 块驱动 (nvme.ko, sd.ko) 会为 PCIe, NVMe, SSD 设备注册 gendisk
- 字符驱动会为串口注册一个 tty 接口
- 网络驱动也会注册 net_device 

注册驱动时, 调用 `device_create(my_class, parent, dev_num, ..., "my_dev")`, 就会在
`/sys/class/my_class/my_dev/` 下生成 sysfs 节点. 用户空间守护进程 udev 监听到 `uevent`, 会自动在 `/dev/` 下创建设备文件 `/dev/mydev`
