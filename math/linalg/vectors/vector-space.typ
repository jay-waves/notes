== 向量空间

*向量空间 (vector space)* 满足:
- 域 $bb(F)$ 用于定义标量运算.
- 向量集合 $bb(V)$ 
- 定义在 $bb(V)$ 上的矢量加法有封闭性 $forall upright(bold(u \, v)) in bb(V) \, med upright(bold(u + v)) in bb(V)$ 
- 定义在 $bb(V)$ 上的标量乘法有封闭性 $forall a in bb(F) \, med upright(bold(v)) in bb(V) \, med a dot.op upright(bold(v)) in bb(V)$
- 交换性 (commutativity): $forall upright(bold(u)) \, upright(bold(v)) in bb(V) \, med upright(bold(u)) + upright(bold(v)) = upright(bold(v)) + upright(bold(u))$
- 结合性 (associativity): $( upright(bold(u)) + upright(bold(v)) ) + upright(bold(w)) = upright(bold(u)) + ( upright(bold(v)) + upright(bold(w)) ) \, med ( a b ) upright(bold(v)) = a ( b upright(bold(v)) )$
- 加法单位元 (additive identity): $exists upright(bold(0)) \, forall upright(bold(v)) in bb(V) \, med upright(bold(v)) + upright(bold(0)) = upright(bold(v))$
- 加法逆元 (additive inverse): $forall upright(bold(w)) in bb(V) \, exists upright(bold(v)) \, upright(bold(v)) + upright(bold(w)) = upright(bold(0))$
- 乘法单位元 (multiplicative identity): $forall upright(bold(v)) in bb(V) \, 1 upright(bold(v)) = upright(bold(v))$
- 分配律 (distributive properties): $a ( upright(bold(u + v)) ) = a upright(bold(u)) + a upright(bold(v)) \, ( a + b ) upright(bold(v)) = a upright(bold(v)) + b upright(bold(v))$

上述条件中 $( bb(V) \, + )$ 构成了#link("https://notes.jay-waves.cn/math/algebra/%E7%BE%A4/%E9%98%BF%E8%B4%9D%E5%B0%94%E7%BE%A4/")[交换群], 向量空间 $( bb(V) \, + \, dot.op )$ 构成了特殊的*模*代数结构 (模不要求系数环为域).

> *向量空间*, 也称为*线性空间*. 线性空间是苏系译法.

=== 向量加法


$
( a_1 \, a_2 \, . . . \, a_n ) + ( b_1 \, b_2 \, . . . \, b_n ) = ( a_1 + b_1 \, a_2 + b_2 \, . . . \, a_n + b_n )
$


=== 向量哈达玛积

哈达玛积 (Hadamard Product)


$
( a_1 \, a_2 \, . . . \, a_n ) compose ( b_1 \, b_2 \, . . . \, b_n ) = ( a_1 dot.op b_1 \, a_2 dot.op b_2 \, . . . \, a_n dot.op b_n )
$


=== 向量内积

向量内积见 #link("https://notes.jay-waves.cn/math/linalg/vectors/inner-product/")[内积空间]. 在内积空间上, 可以定义距离 (范数) 和角度的度量.
