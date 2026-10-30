*函数对象 (function object)* 指重载了函数调用操作符 `()` 的**类**. 换言之, 它是模拟函数行为的一种类, 也称为*仿函数 (functor)*, 可以像函数一样调用. 函数对象比静态变量更适合定义"局部状态".

注意事项:
- 函数对象通常不定义构造函数和析构函数
- 函数对象适合内联汇编, 而用函数指针几乎不可能.

*谓词*是指返回 `bool` 类型的函数对象. 一元谓词指 `()` 接受一个参数, 二元谓词指 `()` 接受两个参数.

## 算术运算

```cpp
template<class T> T plus<T> // +
template<class T> T minus<T> // -
template<class T> T multiplies<T> 
template<class T> T divides<T>
template<class T> T modulus<T>
template<class T> T negate<T>
```

## 逻辑运算

```cpp
template<class T> bool logical_and<T>
template<class T> bool logical_or<T>
template<class T> bool logical_not<T> // 一元
```

## 比大小

```cpp
template<class T> bool equal_to<T>
template<class T> bool not_equal_to<T>
template<class T> bool greater<T>
template<class T> bool greater_equal<T>
template<class T> bool less<T>
template<class T> bool less_equal<T>
```

### less

`std::less` 是函数对象, 用于执行 `<`

```cpp
#include <functional>

template <class T = void>
struct less {
	constexpr bool operator()(const T& lhs, const T& rhs) const {
		return lhs < rhs;
	}
};
```

### greater

`std::greater` 是函数对象, 用于执行 `>`

```cpp
#include <functional>

template <class T = void>
struct less {
	constexpr bool operator()(const T& lhs, const T& rhs) const {
		return lhs > rhs;
	}
};
```

## 函数适配器

C++11 之前通常用 `bind()` 和 `mem_fn()` 来完成[函数柯里化 ](../functional-programming.md). 


```cpp
#include <functional>

int f1(double);
function<int(double)> fct {f1}; // fct = f1;
auto fct = [](double d) { return round(d); }; // fct = lambdaxxx
```