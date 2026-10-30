---
revised: 24-07-09
copyright:
  - JayWaves (2024)
---

- 所配置软件: VSCode
- 操作系统: Windows10
- 预备知识: C/C++ 编译基础知识, 了解常见 IDE 功能.

## 方案一

使用微软自带编译器提供 C 环境, **需要通过 Visual Studio Installer 下载完整的桌面开发 C/C++ 环境**. 该方案配置复杂, 更推荐直接用完整的 Visual Studio, 开箱即用.
- 编译器: MSVC
- 插件: (Miscosoft) C/C++
- C/C++ 标准库: ucrt/MSVC++ [^1]

> 微软是不是写代码也只想在 GUI 上点点点, 不敢想这是21世纪的编程工具.... 

### 配置语言服务器

VSCode 安装 Microsoft C/C++ 插件. VSCode 的用户工作区配置文件放在 `.vscode` 文件夹下, 包括:
- `task.json` 编译配置
- `launch.json` 调试配置
- `c_cpp_preperties.json` C语言环境配置

配置 LSP Inlay Hints (行内代码提示): `Settings > Extension > C/C++ > IntelliSense > Inlay Hints`. 设置为按 ctrl+alt 才显示, 减少视觉干扰. 

```json
// in settings.json
// C++ > inlay hints
"editor.inlayHints.padding": true,
"C_Cpp.inlayHints.parameterNames.hideLeadingUnderscores": false,
"C_Cpp.inlayHints.parameterNames.enabled": true,
"C_Cpp.inlayHints.referenceOperator.enabled": true,
"C_Cpp.inlayHints.autoDeclarationTypes.enabled": true,
"C_Cpp.inlayHints.autoDeclarationTypes.showOnLeft": true,
```

### 配置自动格式化

配置位于 `Settings > Extension > C/C++ > Formatting` 以及 `Settings > Text Editor > Formatting`. C/C++ 插件支持自带的 vcFormat 以及 Clang-Format. 尽量轻量化配置, 配置自动插入空格和换行即可, 培养代码习惯, 保持对多种 Coding Style 的兼容[^4].

```
// in settings.json
"editor.formatOnPaste": true,
"editor.formatOnType": true,
"editor.renderWhitespace": "none",

// C++ > Formatting, using vsFormat instead of clang_format
"C_Cpp.formatting": "vcFormat",
"C_Cpp.vcFormat.newLine.beforeElse": false,
"C_Cpp.vcFormat.newLine.beforeCatch": false,
```

### 配置编译

命令面板 (ctrl+shift+p) 输入 `tasks:configure default build task`, 自动生成针对 `cl.exe` 编译器[^6]的 `task.json`, 下面是自定义的一些编译参数.

```json
// in tasks.json
{ 
  "tasks": [
    {
      "type": "cppbuild",
      "label": "MSVC build",
      "command": "..VC\\Tools\\MSVC\\14.32.31326\\bin\\Hostx64\\x64\\cl.exe",
      "args": [
        "/Zi",     // 完整调试信息
        "/EHsc",   // 异常处理
        "/nologo", // 不显示版权信息
        "/O2",      // 优化等级
        "/source-charset:utf-8",    // 源文件编码
        "/execution-charset:utf-8", // 执行文件编码
        // 执行文件/链接文件的输出位置, 设置为 ./build/hello.exe
        "/Fe${fileDirname}\\build\\${fileBasenameNoExtension}.exe",
        // 目标文件的输出位置, 设置为 ./build/hello.o
        "/Fo${fileDirname}\\build\\", 
        "${file}"
      ],
```

命令面板输入 `C/C++:edit configuration`, 打开 `c_cpp_properties.json`, 修改 C/C++ 配置. 包括头文件目录, windows sdk 目录, C/C++ 标准等. 着重注意, Windows 下的 libc 库为 `ucrt`, 编译器 `cl.exe` 的头文件目录则在 VS 目录下 [^3].


```json
// in c_cpp_properties.json
"configurations": [
{
	"name": "Win32",
	"includePath": [
		"${default}",
		"C:\\Program Files (x86)\\Microsoft Visual Studio\\2022\\VC\\Tools\\MSVC\\14.30.3170\\Include",
		"C:\\Program Files (x86)\\Windows Kits\\10\\Include\\10.0.19041.0\\ucrt",
		"C:\\Program Files (x86)\\Windows Kits\\10\\Lib\\10.0.19041.0\\ucrt\\x64",
	],
	"defines": [
			"_DEBUG",
			"UNICODE",
			"_UNICODE"
	],
	"windowsSdkVersion": "10.0.19041.0",
	"compilerPath": "C:/Program Files (x86)/Microsoft Visual Studio/2022/BuildTools/VC/Tools/MSVC/14.31.31103/bin/Hostx64/x64/cl.exe",
	"cStandard": "c11",
	"cppStandard": "c++17",
	"intelliSenseMode": "windows-msvc-x64"
}
],
```

> 理论上, 这里的编译器还可以使用:
> - cl.exe on Windows for MSVC CompilerOpe
> - clang.exe on Windows for LLVM
> - gcc.exe on Windows for Mingw-w64
> - gcc on WSL 

**接着使用 Developer Command Prompt for VS2022 [^2] 运行 VSCode, 编译运行 C/C++ 文件**即可. 该 DCPVS2022 自带了必须的环境, 将 `cl.exe` 添加入 `PATH` 变量, 并将必要头文件导入 `IncludePath` 变量中. 

修改默认 Shell, 向其中添加 VS 环境. (下面的命令, 其实就是 Developer Command Prompt for VS 的启动命令)

```json
// in setting.json
"terminal.integrated.defaultProfile.windows": "Developer Command Prompt",
"terminal.integrated.profiles.windows": {
	"Developer Command Prompt": {
		"path": "C:\\WINDOWS\\System32\\cmd.exe",
		"args": [
			"/k", 
			"F:\\vs\\ide\\Common7\\Tools\\VsDevCmd.bat", 
			"-arch=x64", 
			"-host_arch=x64"
		],
	}
},
```

### 配置调试

使用 Developer Command Prompt for VS 打开 VSCode, 完成上述编译配置后, 理论上可直接开始调试. VS 编译套件对代码安全性和现代性要求较高, 所以部分检查和报错比较苛刻. 

这里介绍一种将调试过程和编译过程分离的方案: 不需要生成 `tasks.json`, 直接用已经编译好的可执行文件作为 `program`, 然后使用 VS Debugger 进行调试. 这种方式甚至不需要用 Developer Command Prompt for VS 打开 VSCode, 因为不需要前置编译链.

在使用外置的一些编译系统时, (如 CMake) 不需要借助 C/C++ 插件生成活动文件, 提供了更高的灵活性.

```json
// launch.json
{
  "version": "0.2.0",
  "configurations": [
      {
          "name": "Debug Executable",
          "type": "cppvsdbg",
          "request": "launch",
          "program": "${workspaceFolder}/build/main.exe", 
          "args": [ "-f", "xxxxx"], 
          "stopAtEntry": true,
          "cwd": "${workspaceFolder}",
          "environment": [],
          "console": "externalTerminal",
          "preLaunchTask": "", 
          "postDebugTask": "", 
          "logging": {
              "trace": true,
              "engineLogging": true,
              "programOutput": true,
              "exceptions": true
          }
      }
  ]
}
```

### 配置静态检查

Clang Tidy 默认集成在 clang 项目, 或者使用包管理器单独下载. MSVC 有内置的部分 LLVM 工具, 其中包括 Clang-Tidy, 所以直接使用即可. 可以在 `Settings > Extension > Code Analysis > Clang-Tidy` 配置, 也可以提供独立的 `.clang-tidy` 配置文件.

```yaml
# .clang-tidy
Checks: >
  -*              # 禁用所有检查
  ,modernize-*    # 开启代码 C++ 现代化审查
  ,bugprone-*     # 开启基础错误检查
  ,performance-*  # 开启性能检查
  ,readability-*  # 开启可读性检查
  ,clang-analyzer-*  # 代码数据流检查
  ,-modernize-use-trailing-return-type # 禁用 auto func() -> return_type
  ,-modernize-use-nodiscard # 允许忽略函数返回值
  ,-performance-avoid-endl  # 允许 std::endl, 因为其会刷新缓冲区, 慢.
  ,-readability-identifier-length # 允许较长的标识符名称
  ,-readability-braces-around-statements  # 允许单行 if/for 后不 {}
  ,-cppcoreguidelines-avoid-magic-numbers # 允许使用数字, 否则须定义为宏
WarningsAsErrors: ''
HeaderFilterRegex: '.*'
AnalyzeTemporaryDtors: false
FormatStyle: none
CheckOptions: []
```

## 方案二

- 编译器: clang.exe / gcc.exe
- 插件: clangd
- C/C++ 标准库: UCRT/MSVC++

### 配置语言服务器

安装 Clangd VSCode 插件 (一个前端, 不是本体). 然后安装本体 [Clangd 软件](https://github.com/clangd/clangd).  

clangd 内置了 clang-tidy, 并默认在 `PATH` 中寻找 `gcc.exe`. 请确保 Windows 中的第三方 C 环境已正确配置:
- 使用 mingw32 或 [mingw-w64](https://www.mingw-w64.org/downloads/#mingw-builds), 推荐 mingw-w64.
- 正确配置了 `PATH`, `C_INCLUDE_PATH`, `CPLUS_INCLUDE_PATH`, `LIBRARY_PATH`. 
	1. 命令行执行 `gcc.exe -v` 查看编译器版本和库.
	2. 命令行编译简单 C/C++ 程序, 确保链接过程正确.
- 头文件版本和编译器版本匹配 (错误使用 mingw-get 可能导致该问题)

### 配置编译
	
Clangd 本身无编译功能, 需要调用外部编译器环境 (如 `gcc.exe`) 来执行语言服务器功能. 

配置 `.clangd`.  `CompileFlags` 是 Clangd 调用 `gcc.exe `时输入的参数. 这里手动将 `C_INCLUDE_PATH` 和 `CPLUS_INCLUDE_PATH` 路径传入, 避免语言服务器找不到引用的头文件 (注意, 自己项目文件夹的目录, 如 `.\include` 可能也需要加进去).

```yaml
# .clangd
CompileFlags:
  Add: [
    -isystem, F:/c/mingw/include,
    -isystem, F:/c/mingw/lib/gcc/mingw32/6.3.0/include,
    -isystem, F:/c/mingw/lib/gcc/mingw32/4.8.1/include/c++,
    --target=x86_64-w64-windows-gnu,
    --gcc-toolchain=F:/c/mingw,
  ]
  Compiler: gcc.exe
```

### 配置静态检查

Clangd 内置了 clangd-tidy 工具. 直接复用上文的 `.clang-tidy` 配置即可.

### 配置代码格式化

Clangd 不内置 clang-format, 但是有格式化功能??. clang-format 使用 `.clang-format` 文件进行配置, 不推荐自行配置, 实在想折腾, 上 Github 找一个模板吧.

可下载 VSCode Clang-Format 插件, 作为前端 (不包含 `clang-format.exe`, 可独立下载[^5]), 包含了较多内置格式化风格.

```json
// in settings.json
"clang-format.executable": "F:\\c\\clang-format.exe",
"clang-format.fallbackStyle": "Google",
```

[^1]: 参见 [C ReadMe](../os/libc/libc.md), UCRT 为微软 MSVCrt 标准库的升级版. 在 Windows 平台上, 默认的 C 标准为 UCRT, C++ 标准为 MSVC++. 皆在 Visual Studio 套件中.

[^2]: https://code.visualstudio.com/docs/cpp/config-msvc

[^3]: 显然, MSVC 可以安装在其他目录下, 所以 `cl.exe` 和 `MSVC/14/Include` 也可能随之在不同路径下. 这里的路径仅供参考. 

[^4]: [google-cpp-style](../langs/cpp/google-cpp-style.md)

[^5]: https://llvm.org/builds/ 页面底部有独立的 clang-format. 当然也可以使用 Visual Studio 内建的 clang-format.

[^6]: cl.exe 编译器详见 [msvc](../langs/cc/toolchain/msvc.md).md)l.md)