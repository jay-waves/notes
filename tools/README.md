---
revised: 2026-01-27
---

品味如下:
- 命令行优先，GUI 扁平现代。
- 开源优先。
- 最好支持多平台。
- 控制资源占用，不喜欢大杂烩应用。
- 复杂，但不能繁琐丑陋，不能绕圈子解决问题。
- 喜欢 WEB 应用，但不喜欢 Chome 套壳的独立应用。

***

## Windows GUI

* 邮箱： GMail、QQMail WEB 
* PDF、EPUB 阅读：epub.ts / pdf.ts 
* PDF、EPUB 编辑：Stirling PDF / Sigil 
* 笔记：NVim
* 代码：Zed 、~~VSCode~~
* 流程图：DrawIO、PPT、reveal.js、Mermaid.js 
* 截图与贴图：Snipaste
* 远程桌面：向日葵、RustDesk 
* 应用卸载器：geek, O&O AppBuster
* 视频播放：mpv
* 视频处理：ffmpeg、HandBrake、ClipChamp 
* 图像处理：ImageMagic、GIMP3 
* 媒体库：[Allusion](https://github.com/RafaUC/Allusion)、Calibre、Jellyfin 
* ~~手机传文件：LocalSend~~     
* 访达：Wox

文件系统增强：

* 文件压缩、解压缩：[7-Zip-zstd](https://github.com/mcmilk/7-Zip-zstd)
* 文件系统缩略图：SageThumbs2K
* 文件索引：Everything 
* 文件格式转换（右键菜单增强）：~~[FileConverter](https://github.com/Tichau/FileConverter)~~
* 右键菜单管理：ContextMenuManagerv4.6

Windows 系统：

* Sysinternals Process Explorer，有一个 TrayIcons 挺好用，比自带的资源管理器好用
* 硬件信息：CPU-Z, DiskGenius, LibreHardwareMonitor
* HotCornersWin

## Shell & Terminal 

详见 [shell.md](./shell.md)

终端：Windows Terminal，Ghostty（Linux 平台）, Alacritty

基础终端工具配置：

* `VISUAL = 'nvim'`
* `EDITOR = 'nvim'`
* `PAGER = 'bat --pager=builtin'`
* `SHELL = 'pwsh'`

一些 TUI 程序：

* [lf](https://github.com/gokcehan/lf), 命令行文件管理和浏览
* psmux, tmux 终端多路复用


## Browser Plugins

- BewlyCat、BewlyBewly 
- Google Scholar Button 
- Markdownload、Obsidian Web Extracter 
- TimeTab（edge 浏览器）
- uBlock Origin、WebRTC Leak Shield 
- vimium C
- TemperMonkey
	- Github 增强 - 高速下载
	- m3u8-downloader
	- CSDN Greener
	- 知乎增强, 知乎美化, 知乎下载器
	- 网盘直链下载助手
- SuperSimple Highlighter 
- Picture in Picture
- Obsidian Web Clipper 
- Read Aloud 

## Linux GUI

also see [.bashrc](bashrc.md), here is the GUI choice:

* flameshot 截图贴图工具
* ~~Alacritty~~ Ghostty 命令行
* chrome 比 firefox 稳定很多
* ibus with rime engine

## DEV

缓存目录放在默认位置即可，重点是其他位置配置地更加紧凑。

* Rust: 放到 WSL 中
* Python：放到 WSL 中
* LLVM： 放到 WSL 中
* JS： dir, cache-dir, store-dir 
* C：MSBuild Tools DIR , VCPKG_ROOT 
* GO: GOBIN, GOROOT, GOPATH 

## 各类配色

- [snow](https://github.com/haystackandroid/snow)
- [typewritter](https://github.com/logico/typewriter)
- [material](https://github.com/hzchirs/vim-material)
- nord
- github
- Catppuccin
- [solarized](https://github.com/altercation/vim-colors-solarized)
- vim-material
- Gruvbox
- Dracula 
