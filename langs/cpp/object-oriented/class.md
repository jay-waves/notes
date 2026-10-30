C++ 类定义:

```cpp
class classname{
	access_specifiers: // 访问修饰符, 如 private/public/protected
		var; // 类成员变量
		member_functions(){}; // 类方法
}
```

例子:
```cpp
class Complex {
	typedef Complex Self;
	double real, imag;
public:
	Complex(double r, double i) : real{r}, imag{i} {}
	Complex(double r) : real{r}, imag{0} {}
	Complex() : real{0}, imag{0} {}

	double real() const { return real; }
	void real(double d) { real = d; }
	double imag() const { return imag; }
	void imag(double d) { imag = d; }

	Complex& operator+=(Complex z) { 
		real += z.real;
		imag += z.imag;
		return *this;
	}

	Complex operator+(Complex, Complex);
	Complex operator-(Complex, Complex);
	bool operator==(Complex a, Complex b) {
		return a.real() == b.real() && a.imag() == b.imag();
	}
}
```

## 结构体

C++ 的类是**基于结构体实现的**, 结构体允许继承, 也允许定义方法. 两者主要区别是类成员默认被保护, 结构体成员默认公开.

C 语言的最大缺点是不适合面向对象, 结构体没办法定义方法, 所有数据都要用传参来在函数间流动, 不利于抽象, 也导致函数参数列表巨长.

```c
// 使用 C 语言强行模拟面向对象
typedef struct Point {
	int x;
	int y;
	void (*print)(struct Point*);
} Point;

void point_print(Point *p) 
{
	printf("....", p->x, p->y);
}

Point* point_new(int x, int y) 
{
	Point* p = (Point *)malloc(sizeof(Point));
	if (p) {
		p->x = x;
		p->y = y;
		p->print = point_print;
	}	
	return p;
}
```

## 类构造与析构

...

### 拷贝构造函数

C++ 默认的拷贝是*浅拷贝*. 如果需要*深拷贝*, 需要手动实现*拷贝构造函数 (copy constructor)* 和*拷贝赋值函数 (copy assignment)*.

```cpp
class Vector {
private:
	double *elem_;
	int size_;
public:
	Vector(int s);
	~Vector() { delete[] elem_; }

	// copy constructor
	Vector(const Vector& a) : elem_{new double[a.size_]}, size_{a.size_} {
		for (int i = 0; i != size_; ++i)
			elem_[i] = a.elem_[i];
	}
	// copy asignment 
	Vector& operator=(const Vector& a) {
		double *p = new double[a.size_];
		for (int i = 0; i != a.size_, ++i)
			p[i] = a.elem_[i];
		delete[] elem_;
		elem_ = p;
		size_ = a.size_;
		return *this;
	}

	double& operator[](int i);
	const double& operator[](int i) const;
};
```

### 移动构造函数

```cpp
class Vector {
	// ...
	// move constructor
	Vector(Vector&& a) : elem_{a.elem_}, size_{a.size_} {
		a.elem_ = nullptr;
		a.size_ = 0;
	}
	// move assignment
	Vector& operator=(Vector&& a);

	// ...
};
```

C++ 中, 如果提供了移动构造函数, 而没手动提供拷贝构造函数, 那么后者被自动禁用.

### 类型转换运算符

```cpp
class People {

	// 允许类型转换为 Person 
	// 不加 explicit 时, 默认是隐式转换.
	explicit operator Person() {
	}
	
	explicit operator Person() && {
		return std::move(person); // 允许右值的移动构造
	}
};
```

## 成员初始化列表

成员初始化列表, Members Initializer List, 是 C++ 类构造函数的一部分, 用于初始化类成员, 成员初始化列表发生于类成员默认初始化之前. 用于解决以下问题:
- 高效, 避免两次初始化(一次默认值, 一次传入参数初始化)
- 可以用来初始化常量和引用类型.

其他特性:
- 初始化顺序和类中定义顺序相同, 和初始化列表中无关.
- 可以在初始化列表中定义基类或成员对象的构造函数.

正确初始化引用和 `const` 成员:
```cpp
codeclass Example {
    const int a; // 常量成员
    int &b; // 引用成员
public:
    Example(int x, int &y) : a(x), b(y) {} // 在成员初始化列表中初始化常量和引用
};
```

调用基类的构造函数:
```cpp
codeclass Base {
public:
    Base(int x) {}
};

class Derived : public Base {
public:
    Derived(int y) : Base(y) {} // 调用基类的构造函数
};
```

注意和 `std::initializer_list` (STL C++11) 区分, 初始化列表是指 `{}` 形式的类 C 初始化方式.

```cpp
#include<initializer_list>
class MyClass {
public:
	std::vector<int> data_;
	MyClass(initializer_lsit<int> list): data_(list) {} // 一般是只读的
}

MyClass arr = {1, 2, 3, 5, 6}; // 对于一般 C++ 是非法的
```

## 多态

### 运行时多态

ABC (Abstract Base Class) 纯虚类型定义虚函数, 支持运行时多态, 称为 *动态分发 (dynamic dispatch)*[^2].
- early binding / static dispatch ==> direct function call overload resolution 
- late binding ==> indirect function call resolution 
- dynamic dispatch ==> virtual function override resolution 

在运行时多态中，**类指针或引用不改变对象的真实类型，只是限制调用方只能使用基类声明过的接口**。能调用什么由静态类型决定，实际执行哪个实现由对象的动态类型决定。virtual 函数让调用方依赖稳定抽象，而具体行为由派生类提供。

```cpp
class Base {
public:
	struct VTable* vptr; // hidden
	virtual void func1() {};
	virtual void func2() {};
};
/*
	vptr --> Base::VTable : {&Base::func1, &Base::func2}
*/

class D1 : public Base {
public:
	void func1() override {};
};
/*
	vptr --> D1::VTable : {&D1::func1, &Base::func2}
*/

class D2 : public Base {
public:
	void func2() override {};
}
/*
	vptr --> D2::VTable : {&Base::func1, &D2::func2}
*/

{
	D1 d1{};
	Base* ptr = &d1;
	ptr->func1(); // (*Base)ptr->(*D1)vptr-->func1();
}
 
```

<img src="../../../attach/img/langs/vtable.avif" alt="vtable" width="400">

vtable 由编译器生成, 放在 `.rodata` 段供链接器使用. 含有虚函数的类都会有一个静态的*虚函数表 (vtable)*, 而每个对象实例中会有隐藏的*虚表指针 (vptr)*, 指向 vtable.

### 基类与子类间的类型转换

派生类可安全地转化为基类，即*向上转换* 。所有使用基类的地方，都可以安全使用子类。

```cpp
derived d;
base* p = &d;
base& r = d;
```

基类需要显式转换为子类，称为*向下转换*。可以使用子类的地方，不一定能使用基类。

```cpp
/*
	dynamic_cast 通过运行时信息来判断此对象的实际类型，
	该实际类型必须包含此处强制转换的目标类型 derived ，
	也就是说，编译器不假设 p 此时是基类静态类型，而是根据多态信息判断
	
	检查失败时：
	* 绑定到 auto* , 则返回 nullptr 
	* 绑定到 auto& , 则抛出异常 std::bad_cast
*/
auto* d = dynamic_cast<derived*>(p);
if (d != nullptr)  
	d->derived_func();
	
/*
	用 static_cast 也可以，但是不会自动保证类型正确，
	此时可能会有未定义行为。
*/
auto* d = static_cast<derived*>(p);
```