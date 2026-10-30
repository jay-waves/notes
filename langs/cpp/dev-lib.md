
## 变量声明

```c
void foo() {
	MyClass obj();            // 这是函数类型 (Most Vexing Parse, 解析歧义)
	MyClass obj1 = MyClass(); // 这是一个 MyClass 对象
	MyClass obj2{};           // 这是一个 MyClass 对象
}
```

## std::literals 

用户自定义字面量 (UDL, User-Defined Literal): 允许重载 `operator""xxx`, 比如重载 `"xxx"json`
- `std::literals::string_literals`
	- `"abc"s` --> string 
	- `"abc"sv` --> string_view 
- `std::literals::chrono_literals`
	- `"xxx"h`, `"xxx"min`, `"xxx"s`, `"xxx"ms`, `"xxx"us`
- `std::literals::complex_literals`
	- `1.0 + 2.0i` --> `complex<double>{1.0, 2.0}`

## 序列化

- JSON: jsoncpp, nlohmann/json 
- YAML: yaml-cpp 
- cereal, bitsery. 结构体等二进制序列化
- protobuf: 跨语言二进制序列化格式

## 单元测试

- benchmark 
- Catch2 
- doctest: 比 catch2 更轻量，catch v3 很重

### Catch2 

```cpp
TEST_CASE("xxxx test") {
	INFO("....");
	CHECK(1 + 1 == 2);
	CHECK_NOTHROW(xxx_func());
}
```

catch2 是一个纯头文件库, 为了加速编译, 应把 Catch2 主程序部分单独分离开:

```cpp
// single_file.cpp
#define CATCH_CONFIG_MAIN 
#include "catch.hpp"
```

Catch2 支持 BDD 测试风格:

```cpp
SCENARIO("xxxxx") {
	GIVEN("condition") {
		...
		WHEN("...") {
			THEN(".....)
		}
	}
}
```

## 其他开发工具库:

- cxxopts: 命令行参数解析
- spdlog: 日志

## DI 

依赖注入库: [Google Fruit](https://github.com/google/fruit), [boost/dil](https://github.com/boost-ext/di)

但是, 小项目可手写工厂函数替代.

## linalg & BLAS

BLAS (Basic Linear Algebra Subprograms) 是指线性代数接口的事实标准，[linalg](../../math/linalg/README.md) 将于 C++26 加入标准库，实现这一系列接口。

#### level 1 BLAS 

复杂度一般为 $O(n)$ 

axpy (a x plus y): $$y\leftarrow \alpha x+y$$

#### level 2 BLAS 

gemv (generalized matrix-vector multiplication): 

$$y\leftarrow \alpha Ax+\beta y$$

solver ($T$ is triangular):  

$$Tx=y$$

#### level 3 BLAS 

gemm (general matrix multiplication): 

$$C\leftarrow \alpha AB+\beta C$$

$$B\leftarrow \alpha T^{-1}B$$

$\beta$ 的目的是累加上一步的结果，一并纳入性能优化。

batched: $$C[k]=\alpha A[k]B[k]+\beta C[k]$$