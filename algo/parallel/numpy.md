
## Vectors

```python
import numpy as np

a = np.array([1., 2., 3.])
b = np.array([4., 5., 6.])


np.eye(3)

# [[1. 0. 0.]
#  [0. 1. 0.]
#  [0. 0. 1.]]

np.zeros(3)

# [0., 0., 0.]
```


### Vectors Op

模长：

```python
np.linalg.norm(a) 

```

逐元素相乘：

```python
a * b 

# [4., 10., 18.]
```

向量内积（欧几里得内积）： $\sum_i a_i b_i$

```python
a @ b # np.dot(a, b) 在矩阵和向量运算中两者等价

# 32 (dot product)
```

向量叉乘：

```python
np.cross(a, b) # 叉乘
```

跨维度的广播运算：

```python
a + 10 # broadcasting

# [11., 12., 13. ]
```

向量复内积 (Hermitian Inner Prodcut), $\sum_i \overline{a_i}b_i$

```python
np.vdot(a, b)
```

数值检查：

```python
np.abs(a)
np.clip(a, 0., 2.) # constrain in [0, 2]
np.isfinite(a).all() 
np.isnan(a).any() 
np.allclose(a, b) 
np.argmin(np.abs(a))
```

### Examples

```python
def angle_between(a, b):

    denominator = np.linalg.norm(a) * np.linalg.norm(b)
    if denominator < 1e-10:
        raise ValueError("zero vector has no direction")h

    cosine = np.dot(a, b) / denominator

    # use np.clip to constrain the value to a fixed range
    return np.arccos(np.clip(cosine, -1, 1.)) # radian
```

判断浮点数相等：

```python
np.allcose(
    np.array([0.1 + 0.2]),
    np.array([0.3]),
)
```

计算向量投影：

```python
v = np.array([2., 3., 0.])
d = np.array([1., 0., 0.])

projection = np.dot(v, d) / np.dot(d, d) * d
# [2., 0., 0.]

perpendicular = v - projection
# [0., 3., 0.]
```
