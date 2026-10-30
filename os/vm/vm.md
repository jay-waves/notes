## 云服务

| 层次         | 云服务 |
| ------------ | ------ |
| 软件         | SaaS   |
| 开发平台     | PaaS   |
| 抽象计算资源 | IaaS   |
| 虚拟化层     |        |
| 物理硬件     |        |
| 网络基础设施             |        |

![On-prem and Cloud -- Network Academic IO, Fig 6](../../attach/img/os/on-prem-off-prem.webp)

vSphere 这类虚拟化平台专用于将所有硬件集群统一为虚拟化平台，允许 CPU 和硬件资源超卖。VMWare vSphere 基于 EXSi 虚拟机内核，类似的还有 OpenStack （基于 Linux KVM 内核）、Windows System Center（基于 Hyper-V 内核）

## 虚拟机类型

<img src="../../attach/img/os/vm-type.avif" alt="" width="400">

type-1 hypervisor (bare-metal hypervisor) 直接管理服务器硬件, 本身是最底层 OS. 如 KVM, Xen, ESXi, Hyper-V.

type-2 hypervisor 则是 Host OS 和 Guest OS 间的中间层. 所有 I/O 都要走 Host OS. 如 VMware Workstation, VirtualBox.

container. 不虚拟硬件, 也不提供内核, 只在内核基础上进行资源隔离. 

### 特权指令处理

## [Docker](docker.md) 

* Linux [Namespaces & Control Groups](linux-ns&cgroup.md) 
* Union File SYstem (OverlayFS): Read-only Image Layers + a Writable Container Layer 

## 参考

A study of security isolation techniques. @shu2016.

[On-prem and Cloud -- Network Academic IO](https://www.networkacademy.io/ccna/network-fundamentals/on-prem-and-cloud)
