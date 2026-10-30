逻辑符号:
- 且 (析取) $\land$ $\wedge$
- 或 (合取) $\lor$ ${} \vee {}$
- 非 $\lnot$ $\neg$

运算优先级 ($\theta$ 指比较运算符): $$()> \theta> \neg >\wedge> \vee$$

## 逻辑门

### 非门

使用 BJT 晶体管实现非门

<img src="../../attach/img/hw/not-bjt-gate.avif" alt="" width="300">

### 与门

使用 BJT 晶体管实现与门.

<img src="../../attach/img/hw/and-bjt-gate.avif" alt="" width="300">

### 与非门

与非门: $Y=\overline{A\cap B}=\overline{A}\cup \overline{B}$

<img src="../../attach/img/hw/logic-nand-gate.avif" alt="" width="250">

使用 BJT 晶体管实现与非门. 与非门也被称为通用逻辑门, 可以通过自组合表示任意逻辑门.

<img src="../../attach/img/hw/logic-nand-bjt-gate.avif" alt="" width="300">

### 或门

使用 BJT 晶体管实现或门.

<img src="../../attach/img/hw/or-bjt-gate.avif" alt="" width="300">

### 或非门

或非门: $Y=\overline{(A\cup B)}$

<img src="../../attach/img/hw/logic-nor-gate.avif" alt="" width="250">

或非门可以构造取反器: $Y=\overline{A}$

<img src="../../attach/img/hw/logic-nor-inverter.avif" alt="" width="200">

### 异或门

真值表:

| In1 | In2 | XOR |
| --- | --- | --- |
| 0   | 0   | 0   |
| 1   | 0   | 1   |
| 0   | 1   | 1   |
| 1   | 1   | 0    |

布尔代数: $Y=A\oplus B=A\overline{B}+\overline{A}B$

<img src="../../attach/img/hw/xor-using-logic-gate.avif" alt="" width="350">

用 XOR 构造取反器: 

<img src="../../attach/img/hw/xor-inverter.avif" alt="" width="200">

用 XOR 构造缓冲: 产生相同的输出, 但是延迟一个时钟再输出.

<img src="../../attach/img/hw/xor-buffer.avif" alt="" width="200">

## 通用门

### NOT using NAND

<img src="../../attach/img/hw/logic-not-using-nand.avif" alt="" width="200">

### AND usin NAND

<img src="../../attach/img/hw/logic-and-using-nand.avif" alt="" width="300">

### OR using NAND

<img src="../../attach/img/hw/logic-or-using-nand.avif" alt="" width="300">

### 3NAND using NAND

<img src="../../attach/img/hw/3nand-using-nand.avif" alt="" width="300">

### XOR using NAND

<img src="../../attach/img/hw/xor-using-nand.avif" alt="" width="350">
