## 锁存器 

## 触发器

### SR 触发器

S-R Flip-Flop 有两个输入 S (Set) 和 R (Reset). 通电状态下, 一旦输出被建立, S/R 不改变, 输出 Q 也保持不变.

<img src="../../attach/img/hw/hw-digital-ckt-sr-flip-flop.avif" alt="" width="400">

| S   | R   | Q   | State     |
| --- | --- | --- | --------- |
| 0   | 0   | 0   | No Change |
| 0   | 1   | 0   | Reset     |
| 1   | 0   | 1   | Set       |
| 1   | 1   | x   | Undefined          |

当 `S = R = 1` 时, `Q = Q' = 0`. 这个状态是不稳定的, 在下一次 SR 输入时, 输出并不确定.

### JK 触发器

SR Flip-Flop 在 S=R=1 时存在未定义状态, JK Flip-Flop 就是为了解决该问题. 当 `J=K=1` 时, Q 值翻转.

<img src="../../attach/img/hw/hw-digital-ckt-jk-flip-flop.avif" alt="" width="400">

| J   | K   | Q      | State     |
| --- | --- | ------ | --------- |
| 0   | 0   | 0      | 保持 |
| 0   | 1   | 0      | 置一     |
| 1   | 0   | 1      | 置零       |
| 1   | 1   | Q' | 翻转          |

### D 触发器

D Filp-Flop 只在时钟边沿触发, 输出 Q 存储此时输入 D 的值.

<img src="../../attach/img/hw/hw-digital-ckt-d-flip-flop.avif" alt="" width="400">

| D   | Q   |
| --- | --- |
| 0   | 0   |
| 1    |    1 |

### T 触发器

| T   | Q   | Q'  |
| --- | --- | --- |
| 0    |     |     |

### 地址锁存器

...