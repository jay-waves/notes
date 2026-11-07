# 本地准备

将 `cmrak`、`ypst` 和 `typst` 加入 PATH，安装构建依赖：

```text
python -m pip install -r .github/scripts/requirements-related.txt
```

统一准备本地资源：建立 `assets` worktree，再更新 `@local/ypst-template:0.1.0`：

```text
python .github/setup.py
```

附件分支映射到 `attach/tmp/`，日常提交和历史清理见 [附件分支](assets.md)。
模板从最新 release 的独立 ZIP 下载，直接覆盖本地包内对应文件，保留本地字体等资源。
安装标记与当前 ypst 编译器匹配，避免下次编译覆盖模板。
更换 ypst 编译器后，重新运行本脚本。
CI 继续使用 `jay-waves/ypst@main` 原有的 `ypst install` 流程，不调用本地 setup。

准备完成后构建和预览：

```text
python .github/scripts/build_site.py
python -m http.server 8000 --bind 127.0.0.1 --directory _site
```

访问 http://127.0.0.1:8000 。构建只接受 `--output`、`--report` 和 `--full` 参数。
缓存目录由环境变量 `SITE_CACHE_DIR` 指定；CI 设置为 `.site-cache`，未设置时禁用缓存。
增量构建只按主分支 Git diff 判断笔记变化；附件、编译器或模板更新后，需要重新编译时
使用 `--full`，或手动开启 workflow 的 `full_build`。无可用缓存时仍会全量构建。
