Fedora 更新比 Debian 系更快, 是 RHEL 的上游版本. 

## 包管理 DNF/RPM

```bash
sudo dnf upgrade --refresh -y
```

```bash
# basic tools 
sudo dnf install -y \
  vim nano less \
  git curl wget unzip tar xz \
  gcc gcc-c++ cmake ninja make pkgconf-pkg-config \
  openssl-dev zlib-devel \
  ca-certificates \
  procps-ng psmisc \
  iproute iputils \
  findutils which tree 
  
# enhanced tools 
sudo dnf install -y \
  nvim less \
  ripgrep fd-find fzf du-dust htop 
  
# 启用 COPR 源
sudo dnf copr enable -y atim/starship 
sudo dnf install -y starship
```

增强工具的配置详见 [tools/bashrc](../../tools/bashrc.md)

启动 RPM Fusion 扩展库：

```bash
sudo dnf install -y \
https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

sudo dnf upgrade --refresh -y
```

## 访问控制

Fedora 默认开启 [Selinux](../perf/access-control.md)

## 网络服务

系统服务管理: `systemd`

防火墙: `firewalld` 

### 配置代理

修改 `/etc/systemd/system.conf`

```conf
DefaultEnvironment="http_proxy=http://127.0.0.1:7890" \
                   "https_proxy=http://127.0.0.1:7890" \
                   "ftp_proxy=http://127.0.0.1:7890" \
                   "no_proxy=localhost,127.0.0.1,::1"
```

刷新 systemd 服务 `sudo systemctl daemon-reexec`

修改 dnf 的代理（必须手动配的）: `/etc/dnf/dnf.conf`

```conf
proxy=http://127.0.0.1:7890
```