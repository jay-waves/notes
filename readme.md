## TOC 🚀

| toc         | en                      | zh           |
| ----------- | ----------------------- | ------------ |
| algo        | algorithm               | 算法         |
| ai          | intelligence            | 人工智能     |
| *appx*      | appendices              | 附录         |
| *assets*    | attachments             | 附件         |
| db          | databases               | 分布式系统   |
| econ        | economics               | 经济学       |
| hw          | hardware                | 体系架构     |
| langs       | languages               | 编程与编译   |
| math        | mathematics             | 数学         |
| net         | networking              | 网络         |
| os          | operating system        | 操作系统     |
| robo        | robotics system         | 机器人       |
| sec         | security                | 网络安全     |
| tools       | dev tools               | 开发工具     |
| vision      |                         | 视觉         |

## License

本仓库中的原创内容均采用 CC BY 4.0 许可证授权。您可自由使用，但须保留署名。

部分文件可能包含受其他许可证或权利约束的第三方内容，此类内容以文件内的具体说明为准。

## Workflow

笔记库采用 Typst + Markdown 混合排版。

- Markdown 文档的推荐样式见 [theme.css](https://github.com/jay-waves/yst-template/blob/main/html/theme.css)，不包含代码块与数学样式。
- Typst 文档的样式模板见 [yst-template](https://github.com/jay-waves/yst-template)

个人博客不在此仓库，详见[个人主页](https://jay-waves.cn)。

所有图片附件与笔记一起由 Git 管理，位于仓库根目录的 `./assets/`。

## Guidelines

- 语言简洁、严谨、准确、逻辑清晰。尽最大努力保持简洁。
- *斜体*的使用：新名词，需要强调的概念等。
- **粗体**的使用：重点强调，突出逻辑。
- 标题级别从二级开始，避免出现四级以下标题，保持层级扁平和简洁。
- 文章篇幅不宜过长，5 个以内三级标题为宜。
- 为了排版美观，不再要求中文强制使用英文标点，但混排时优先使用英文标点。
- 中文（全角）和任意半角符号间应隔一个半角空格，括号内侧除外。

### Markdown

- 使用严格断行
- 使用严格 `[]()` 链接与图片引用格式。
- 允许的 Markdown 扩展语法：HTML、Table、Katex、Footnote、YAML Preamble 
- 全角标点符号应位于 Markdown 标记之外，如 **粗体之后再逗号**，避免渲染异常。
- 可以使用 Mermaid 流程图，但是不保证样式稳定。

### Naming

- 普通目录及文件：用 `-` 作为连字符，*尽可能减少空格，全小写* 
- 源码目录及文件：遵循编程语言规范，通常使用 `_` 作为连字符
- 无空格

### Coding

详见 [个人代码风格描述](appx/personal-coding-styles.md)

### Reference

- 仓库整体使用 [CC-BY](license.md) 许可证，部分摘录文章或原创文章使用不同版权许可的，在文章开头标明
- 引用格式：`[Bjarne Stroustrup, 2014, p22]`, `@yayvyn2012` 皆可，可缩写，完整信息存放在 `references.bib` 文件中。

### Attachments 

* 图片附件按 `assets/<主题>/` 一级目录归档，并与引用它们的笔记一起提交。
* 图片如有版权信息，同样需要著名来源, 形式如：

```html
![foo, 2008](xxx/yyy)

<figure>
    <img src="xxx/yyy">
  <figcaption>
    Source: <a href="https://xxxx">@foo2008</a>
  </figcaption>
</figure>
```


