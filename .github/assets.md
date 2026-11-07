# 附件分支

`assets` 是独立历史的附件分支，本地通过 worktree 映射到 `attach/tmp/`。
主分支忽略这个目录；笔记仍使用本地相对路径引用附件。
CI 将 `assets` 检出到同一目录，附件随站点部署，不再依赖 R2。

## 日常使用

首次准备工作目录：

```text
python .github/scripts/assets.py setup
```

也可运行 `python .github/setup.py`，同时更新本地 Typst 模板。
已有 worktree 时，setup 不覆盖文件或自动拉取更新。

将附件放进 `attach/tmp/` 后，在主仓库根目录执行：

```text
git -C attach/tmp add .
git -C attach/tmp commit -m "Update assets"
git -C attach/tmp push -u origin assets
```

主分支正常提交笔记和代码。`git add .` 不会把附件混入主分支。
先推送附件，再推送引用它们的笔记；只更新附件时，手动运行站点 workflow。
CI 使用最新附件，因此旧笔记提交不保证还原当时的附件。
附件变化不触发笔记重新编译，普通附件仍在每次构建时复制到站点。
需要刷新已编译页面中的嵌入图片时，手动开启 workflow 的 `full_build`，或本地运行 `--full`。

## 按需清理历史

先查看将执行的操作：

```text
python .github/scripts/assets.py reset-history --push --dry-run
```

确认附件工作目录干净后，重建为只保留当前文件的根提交：

```text
python .github/scripts/assets.py reset-history --push
```

脚本检查远端变更，并用明确的 `--force-with-lease` 更新 `assets`。
`--dry-run` 只预览，不改写提交或推送；各子命令可用 `--help` 查看用法。
省略 `--push` 则只重置本地分支；主分支不受影响。
其他附件工作副本随后需要重新对齐，不能把旧历史合并回来。
脚本不运行仓库级垃圾回收，旧对象仍可能存在于 reflog、其他克隆和托管平台缓存中。
