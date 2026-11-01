# Monaspace Xenon Var 字体示例

Good typography makes technical writing easier to read. A clear distinction between prose and code helps readers follow an explanation, inspect examples, and return to the main idea without losing their place.

This sample compares ordinary English text with source code. The quick brown fox jumps over the lazy dog; numbers such as 0123456789 and punctuation also help reveal differences in spacing, weight, and letter shape.

行内代码：`const answer = 42;`、`0O 1Il | != == => ->`、`中文注释`。

```python
from dataclasses import dataclass

@dataclass
class Point:
    x: float
    y: float

def distance(a: Point, b: Point) -> float:
    # 两点之间的欧氏距离
    return ((a.x - b.x) ** 2 + (a.y - b.y) ** 2) ** 0.5

print(f"distance = {distance(Point(0, 0), Point(3, 4)):.2f}")
```

```typescript
interface User {
    id: number;
    name: string;
    active: boolean;
}

const activeNames = (users: User[]): string[] =>
    users.filter(user => user.active).map(user => user.name);

// 字符区分、符号及连字
// 0 O o   1 I l |   {} [] ()   != == === <= >= => ->
```

<style>
@font-face {
    font-family: "Xenon Preview";
    src: local("Monaspace Xenon Var ExtraLight"), local("MonaspaceXenonVar-ExtraLight");
    font-weight: 200 800;
    font-style: normal;
}
#content {
    --md-code-font-size: 13px;
    --md-font-mono: "Xenon Preview", "Monaspace Xenon Var ExtraLight", "Sarasa Mono SC", "Microsoft YaHei Mono", monospace;
}
#content pre, #content code, #content pre code, #content pre code * {
    font-family: "Xenon Preview", "Monaspace Xenon Var ExtraLight", "Sarasa Mono SC", "Microsoft YaHei Mono", monospace !important;
    font-size: 13px !important;
}
</style>
