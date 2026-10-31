## tar

早期压缩格式, 如 `gzip`, 仅支持单文件压缩. 压缩多文件时 (尤其是小文件较多时), 需要搭配 `tar` 归档程序将多文件归档为单个 `.tar` 文件, 再执行压缩. 

后续改进压缩算法, 自身已支持多文件和文件夹压缩, 也支持加密[^1]. 因此, 归档概念仅在 Linux 下比较常见.

[^1]: 显然不太符合 Unix 的 "Do one thing, and do it well" 风格, 高手还是喜欢 tar + xz + gpg ...

```bash
tar -xvf a.tar              # 不指定压缩算法时, 不压缩
tar -xvfz a.tar.gz          # gzip + tar
```

`tar` 常用指令:
- `c` create, 创建新归档文件
- `x` extract
- `v` verbose
- `f` file, 指定文件名
- `zjJ` 指定压缩算法 gzip/bzip2/xz
- `k` keep exisitn files

## zip

常见有界面压缩工具有 7zip, winrar, bandzip, peazip 等, 推荐 7zip, 跨平台且开源.

### Algorithms

| 算法             | 压缩率        | 压缩/解压速度 | 运存占用 | 场景             | 描述 (同名算法有变种)                           |
| ---------------- | ------------- | ------------- | -------- | ---------------- | -------------------------------- |
| DEFLATE          | 中            | 快            | 低       | 打包, 兼容性环境 | LZ77 + Huffman 熵编码 |
| LZMA             | 极高          | 慢            | 高       | 软件分发, 归档   | LZ77 + 范围 熵编码                |
| Zstandard (zstd) | 高            | 快            | 中       | 实时传输         | LZ77 + ANS 熵编码              |
| BWT              | 高 (文本最优) | 慢            | 高       | 文本压缩         |  BWT + MTF + 熵编码                                |
| LZ4              | 低            | 极快        | 低         |  小文件, 文本文件               | LZ77, 无熵编码                                |

*字典编码 (Dictionary Coding)*, 指构建一个滑动窗口, 将数据中重复序列换位更短的字典引用 (偏移 + 长度). 
字典编码是对字符串的无损压缩, 消除冗余重复, 速度依赖于字典和滑动窗口大小. 常用 LZ77 算法. 

*熵编码 (Entropy Coding)* 是利用数据的统计特性, 为高频符号分配更短的编码, 从而逼近理论最小熵. 
编码后, 变为不定长比特流. Huffman 算法一般以字节为单位划分符号, 
算术编码 / 范围编码 (LZMA 使用) / ANS (Zstd 使用) 则以更小区间 (低至比特) 为单位, 压缩率可接近香农极限, 但计算复杂度越高.

### 7zip

指定压缩比:

- `mx0` 无压缩
- `mx1` 最快速压缩
- `mx9` 最高压缩比

指定压缩格式:

- `tar` 非压缩算法, 用于模拟 TAR 归档. 注意 7zip 命令行工具不会负责归档.
- `zip`, zip 和 gzip 格式都默认使用 Deflate 算法. 
- `gzip`, `.gz` 常用于 Unix , 但只支持单个文件 (需要配合 `tar`). 
- `7z` 默认, 基于 LZMA 算法. 7z 格式支持**强加密**.
- `bzip2`, 基于 BWT 算法.
- `xz` 基于 LZMA2 算法.
- `lz4` 
- `zstd` 

```sh
7z a archive.7z  -mx9 "C:\My\Files"

7z a -t7z encrypted.7z "..." -p123456 -mx=9

7z a -ttar archive.tar "..."
7z a -tgzip -mx5 archive.tar.gz archive.tar
```

> 7z 加密有个问题, 无法保密文件夹结构. 新版加入了参数 `-mhe=on`

