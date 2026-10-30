
CMD 寻求帮助:

1. `/?`
2. `help for cmd`
3. **如果没有现成命令, 不要试图用 CMD 解决问题**
4. **如果有现成命令, 一定有更严谨的 PowerShell 命令**

PowerShell 寻求帮助:

- 参数: `-Help`
- 命令: `Get-Help <cmd> -Detailed -Full -Examples`
- [官方文档](https://learn.microsoft.com/en-us/powershell/)

powershell 为 bash 和 cmd 用户准备了对应命令的别名.

| bash                     | pwsh                                                    | pwsh alias                  | cmd                     |
| ------------------------ | ------------------------------------------------------- | --------------------------- | ----------------------- |
| `grep`                   | `find-string -Pattern`                                  |                             | `findstr`               |
| `ls, dir`                | `get-childitem`                                         | `gci`                       | `dir`                   |
| `pwd`                    | `get-location`                                          | `gl`, `pwd`                 | `chdir`                 |
| `mkdir`                  | `new-item -Type Directory`                              | `ni -Type Directory`, `pwd` | `mkdir`                 |
| `rm`                     | `remove-item`                                           | `ri`, `rm`, `del`           | `del` or `rmdir`        |
| `mv`                     | `move-item`                                             | `mi`, `mv`, `move`          | `move`                  |
| `cp`                     | `copy-item`                                             | `ci`, `cp`                  | `copy`                  |
| `grep`                   | `select-string`                                         | `findstr`, `sls`            | `findstr`               |
| `echo`                   | `write-output`                                          | `echo`                      | `echo`                  |
| `cat`                    | `get-content`                                           | `gc`, `type`, `cat`         | `type`                  |
| `chmod`                  | `set-acl`                                               |                             |                         |
| `export VarName="value"` | `$env:VarName="value"`                                  |                             | `set VarName=value`     |
| `clear`                  | `cls`                                                   |                             | `cls`                   |
| `cd .. && pwd`           | `cd; pwd`                                               |                             | `cd .. & cd`            |
| `ln -s`                  | `new-item -ItemType SymbolicLink -Path ... -Target ...` |                             | `mklink` or `mklink /D` |
|                          | `get-clipboard`                                         | `gcb`                       | `clip.exe` (not same)   |
| `ip addr`                | `get-netipaddress`                                      | None                        | `ipconfig`              |
| `time`                   | `Measure-Command {Start-Process <program> -Wait}`       |                             |                         |
| `traceroute`             |                                                         |                             | `tracert`, `netsh`,     |
|                          |                                                         |                             | `pause`                 |
| `ps`, `processes`        | `Get-Process`                                           |                             | `tasklist`              |
| `pkill -9 <p_name>`      | `Stop-Process -Name <p_name> -Force`                    |                             | `taskkill /IM <p_name>` |
| `kill -9 <pid>`          | `Stop-Process -Id <pid> -Force`                         |                             | `taskkill /pid <pid>`   |
| `^`  (换行跳脱符)        | \`                                                      | `\`                         |                         |
| `where`                  | `get-command`                                           | `where`                     | `where`                        |

Powershell 中想要直接使用 CMD 中命令, 而不是别名, 请加上 `.exe` 后缀. 这一点 WSL 中同理.

### Invoke-WebRequest

Powershell 中 `curl` 实际是 `Invoke-WebRequest` 的别名 (不是[原来的工具](../os/perf/net-stat.md#`curl`)), **参数**有变化 (真的坑):

- `-Uri` 
- `-Proxy` --> `-x`
- `-Headers` --> `-H`
- `-ContentType` --> `-X`

### 遍历

```powershell
Get-ChildItem -Filter *.avif | ForEach-Object {
	...
}

# 等价于:
gci -Filter *.avif | % {
	...
}
```

Powershell 的命令替换和字符串转义非常难用，建议不要手写。

## Q&A 1

管道和重定向编码问题: Powershell7 默认支持 [UTF-8](../hw/char-encoding.md), 但是不同平台上的一些功能又依赖于平台本身的语言设置. 在 Windows 上, 默认中文编码使用了非 UTf-8 编码, 导致使用管道出现乱码.

<https://github.com/PowerShell/PowerShell/issues/17523> 解决办法如下:

```powershell
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
```

<https://stackoverflow.com/questions/40098771/changing-powershells-default-output-encoding-to-utf-8>

## Q&A 2

执行 `.ps1` 脚本遇到策略问题, 使用管理员模式执行:

```powershell
# 允许本地脚本, 禁止远程脚本
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine

# 或, 完全绕过验证
Set-ExecutionPolicy -ExecutionPolicy ByPass -Scope LocalMachine
```
