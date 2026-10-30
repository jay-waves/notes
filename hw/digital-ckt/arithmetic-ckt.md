
### 半加器

<img src="../../attach/img/hw/logic-half-adder.avif" alt="" width="300">

真值表:

| In1 | In2 | Sum | Carry |
| --- | --- | --- | ----- |
| 0   | 0   | 0   | 0     |
| 0   | 1   | 1   | 0     |
| 1   | 0   | 1   | 0     |
| 1   | 1   | 0   | 1      |


### 全加器

全加器有三个输入: A, B, $C_{in}$. A, B 是二进制单比特输入数据, $C_{in}$ 是前一阶段加法的进位. 

<img src="../../attach/img/hw/logic-full-adder.avif" alt="" width="500">

真值表:

| A   | B   | $C_{in}$ | S (Sum) | $C_{out}$ (Carray) |
| --- | --- | -------- | ------- | ------------------ |
| 0   | 0   | 0        | 0       | 0                  |
| 0   | 0   | 1        | 1       | 0                  |
| 0   | 1   | 0        | 1       | 0                  |
| 0   | 1   | 1        | 0       | 1                  |
| 1   | 0   | 0        | 1       | 0                  |
| 1   | 0   | 1        | 0       | 1                  |
| 1   | 1   | 0        | 0       | 1                  |
| 1   | 1   | 1        | 1       | 1                   |

布尔代数:

$$S=A\oplus B\oplus C_{in}=ABC_{in}+A\overline{B}\overline{C_{in}}+\overline{A}B\overline{C_{in}}+\overline{AB}C_{in}$$

$$C=AB+AC_{in}+BC_{in}$$

```verilog 
module full_adder(
	input wire a,
	input wire b,
	input wire cin,
	output wire sum,
	output wire count
);

	assign sum = a ^ b ^ cin;
	assign cout = (a & b) | (b & cin) | (a & cin);
endmodule
```

### 时序加法器

### 并行加法器

### 四位加法器