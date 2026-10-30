模板是编译时泛型技术, 运行时开销比较小. 但是模板对每种类型都生成独立的代码, 会导致程序体积膨胀和编译变慢.

模板不仅接受类型参数, 也能接受值参数:

```cpp
template<typename T, int N>
struct Buffer {
	constexpr int size() { return N; }
	T[N]; // 可以在栈上.
};
```

模板函数:

```cpp
template<typename Container, typename Value>
Value sum(const Contianer&c, Value v) {
	for (auto x: c)
		v += x;
	return v;
}
```

## functor

通过重载 `()` 符号, 类可以像函数一样被调用. 函数对象的优点是可以存储局部状态, 而不是通过静态 / 全局变量的方式.

```cpp
template<typename T>
class Less_than {
	const T val; // value to compare against 
public:
	Less_than(const T& v) : val(v) {}
	bool operator()(const T& x) const {return x < val; } // call operator 
};
```

## variadic template

*variadic template* 指可以接受**任意数量的任意类型参数**的模板.

```cpp
void f() {} // 用于处理递归结束

template<typename T, typename...Tail>
void f(T head, Tail... tail) {
	g(head); // 处理第一个参数
	f(tail...); // 继续处理接下来参数
}
````

如果是齐次参数列表 (类型相同的任意数量参数), 考虑使用*初始化列表*.

### SFINAE 

https://jguegant.github.io/blogs/tech/sfinae-introduction.html

Substitution Failure Is Not An Error: 一般指模板特化.

## CRTP 

详见 [设计模式/MixIn](../../object-oriented/mixin.md)