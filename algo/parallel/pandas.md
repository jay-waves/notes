- Series : 带索引的列表
- DataFrame : 二维表
- Index : 索引

```python
import pandas as pd 

data = {
    "name": ["Alice", "Bob", "Charlie"],
    "age": [25, 30, 35],
    "city": ["Beijing", "Shanghai", "Guangzhou"]
}
df = pd.DataFrame(data)
```