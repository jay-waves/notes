## 1, Memory Safe 

### 1.1, Uninitialized Variables 

```rust 
let x;
foobar(x); // error: borror of possibly-uninitialized variable 'x'
x = 42;
```

### 1.2, Immutablity 

变量和引用默认是不可变的 (const), 也不可赋值. 除非使用 `mut` 

```rust 
let mut  n = Number {
	odd: true,
	value: 17,
};
n.value = 18;
```

### 1.3, Lifetime 

变量超出作用域, 将会失效 (Drop)

```rust
// s is invalid
{
	let s = "helllo"; // valid
}
// s is dropped and invalid
```

#### Borrowing

C++ 的引用 `T&` 在初始化时静态检查是否绑定了一个有效对象, 但不保证后续的有效性, 可能悬垂. 

Rust 对变量的引用 (Borrowing), 不能超出变量本身的生命周期. 在编译期避免*垂悬指针*, 保证引用值总是有效.

```rust 
fn main() {
	let x_ref = {
		let x = 42;
		&x
	};
	println!("{}", x_ref);
	// Rust 中报错, C++ 不报错
}
```

一个变量在同一时间, **只能存在一个可变引用, 或者存在多个只读引用**. 编译期可以避免*数据竞争*.

#### Lifetimes Annotation 

**生命周期标注的作用是保证引用的安全性**. Rust 用泛型来实现生命周期标注, 短生命周期是长生命周期的基类. 编译器可以进行部分生命周期推导, 但是整个程序的运行时时序 (调用链和变量生命传递) 是一个停机问题, 编译器没办法控制复杂度.

函数参数的生命周期需要用泛型显式标注, 称之为*生命周期泛型参数*. 对于单参数的函数, 其参数生命周期无需标注, 可以自动推导.

```rust 
// elided (non-named) lifetimes:
fn print(x: &i32) {}

// named lifetimes:
fn print<'a>(x: &'a i32) {}
```


用于参数时, 用于标注返回值的生命周期应该小于等于所有参数的生命周期. `'a: 'b` 则表示 `'a` 至少比 `'b` 活得更久. 
```rust 
fn pick_first<'a, 'b>(x: &'a str, y: &'b str) -> &'a str {
	x
}
```

结构体有两个引用, 一个从 `'a` 处来, 一个从 `'b` 处来. 结构体成员的生命周期不应比结构体本身的生命周期更短, 否则成员就变成了垂悬引用.

```rust 
struct NumRef<'a, 'b> {
	x: &'a i32,
	y: &'b i32,
}

let x: i32 = 99;
let x_ref = NumRef { x: &x }; // x_ref cannot outlive x
```

`'static` 标识值在整个程序运行期间皆有效. 

```rust 
let s: &'static str = "hello world"; // 字符串字面量
static NAME: &str = "global"; // Rust 中全局变量要不是 static, 要不就是 unsafe 
```

### 1.4, Copy & Move

处理堆数据时 (函数传参, 赋值等), 默认资源移动, 而不是值拷贝 (Move); 处理栈数据时, 会进行值拷贝 (Copy). 

```rust
{
	let a: i32 = 15;
	let b = a; // copied 
	let c = a; // copied again 
}

// Number with no Copy trait 
{
	let n = Number { value: 51};
	let m = n; // moved 
	let o = n; // error !!!
}
```

实现 Copy Marker Trait 需要依赖 Clone Trait:
```rust 
impl std::clone::Clone for Number {
	fn close(&self) -> Self {
		Self { ..*self }
	}
}

impl std::marker::Copy for Number {}
```

也可以用 Deriving 方法, 来隐式实现 MakerTrait.

```rust 
#[derive(Clone, Copy)]
struct Number {
	value: i32,
}
```

### 1.5, Owned or Reference 

| type        | owned     | reference |
| ----------- | --------- | --------- |
| Strings     | `String`  | `&str`    |
| Paths       | `PathBuf` | `&Path`   |
| Collections | `Vec<T>`  | `&[T]`          |

## 2, Functional Programming 

### 2.1, Blocks 

代码块是一个表达式类型. 事实上, 各类代码块都是表达式.

```rust
let x = {
	let y = 1;
	let z = 2;
	y + z // return 3
}
```

### 2.2, Function Closures 

函数闭包就是带有一些上下文的函数子. 用 `|...|` 来表示闭包. `F` 支持 `Fn(), FnMut(), FnOnce()` 等 Trait.

Rsut `|...| f(...)` 对比 C++ 的 `[](...){ f(...) }`

```rust 
fn call_with_closure<F: Fn()>(f: F) {
	f();
}

{
	call_with_closure( || println!("Hi!")); // 就像一个 lambda 函数.
}
```

```rust 
fn for_each_planet<F>(f: F) 
	where F: Fn(&'static str) 
	{
		f("Earth");
		f("Mars");
		f("Jupiter");
	}

{
	for_each_planet(|planet| println!("hello, {}", planet));
}
```

```rust 
fn countdown<F>(count: usize, tick: F)
	where F: Fn(usize)
{
	for i in (1..=count).rev() {
		tick(i);
	}
}

{
	countdown(3, |i| println!("tick {}...", i));
}
```

#### FnMut 

用于在闭包中捕获一些本地的可变变量:

```rust 
fn foobar<F>(mut f:F)
	where F: FnMut(i32) -> i32 
{
	let tmp = f(2);
	println!("{}", f(tmp)); // 自动捕获了外部变量, 无需 c++ 的 [](){} 
}

{
	let mut acc = 2;
	foobar( |x| {
		acc += 1;
		x * acc
	});
} // 24
```

#### FnOnce 

```rust 
fn boobar<F>(f: F)
	where F: FnOnce() -> String 
{
	println!("{}", f());
	// f() can only be called once
}

{
	let s = String::from("alright");
	foobar(move || s); // moved s into closure. !!!String has not Copy trait!!!
}
```

#### Returning Closure 

```rust 
fn make_tester<'a>(answer: &'a str) -> impl Fn(&str) -> bool + 'a {
	move |challenge| {
		challenge == answer 
	}
}

let test = make_tester("hunter2");
println!("{}", test("......"));
println!("{}", test("hunter2"));
```

### 2.3,map & flatten 

```rust 
fo c in "xxxxxxxx"
	.chars()
	.filter(|c| c.is_lowercase())
	.flat_map(|x| c.to_uppercase())
{
	print!("{}", c);
}
```

## 3, Data Structure

除了基础数据类型, Rust 还自动引入了常用的复合类型:

```rust
Vec 
String 
Option 
Result 
```

### 3.1, Enum 

```rust 
enum MyEnum {
	One,
	Two,
}
```

### 3.2, Option 

`Option` 是一个 `Enum`. 

```rust 
enum Option<T> {
	None,
	Some(T),
}

impl<T> Option<T> {
	fn unwrap(self) -> T {
		match self {
			Self::Some(t) => t,
			Self::None => panic!(".unwrap() called on a None option"),
		}
	}
}

use self::Option::{None, Some};
```

### 3.3, Result 

`Result` 也是一个 `Enum`. 可以是结果, 也可以是一个错误 `Err`

```rust 
enum Result<T, E> {
	Ok(T),
	Err(E),
}
```

#### Error Handling 

```rust 
// return Result
let s = std::str::from_utf8(&[195, 40]); // Err(Utf8Error { valid_up_to: 0, error_len: Some(1) })

// panic 
let s = std::str::from_utf8(&[240, 159, 141, 137]).unwrap(); // panic 

// for a custom message 
let s = std::str::from_utf8(&[195, 40]).expect("valid utf-8"); // panic at 'valid utf-8' 

// match 
match std::str::from_utf8(&[240, 159, 141, 137]) {
	Ok(s) => prinln!("{}", s),
	Err(e) => panic!(e),
}

// if let 
if let Ok(s) = std::str::from_utf8(...) {
	println!{"{}", s);
}

// bubble up error 
{
	match std::str::from_utf8(...) {
		Ok(s) => println!("{}", ),
		Err(e) => return Err(e),
	}
	Ok(())
}

// use ? to bubble up error 
{
	let s = std::str::from_utf8(...)?;
}
```

### 3.4, Vec 

列表切片 (Slices):
```rust 
{
	let v = vec![1, 2, 3, 4, 5];
	let v2 = &v[2..4]; // [3, 4]
}
```

### 3.5, collections 

#### VecDeque

双端队列: `VecDeque<T>`

#### HashMap 

哈希表, `HashMap<K, V>`, 默认基于 `RandomState`

#### HashSet 

集合, 基于 HashMap, 并去重.

#### BTreeMap

K 有序映射表, `BTreeMap<K, V>`

### 3.6, Box

`Box<T>` 堆分配指针, 基础智能指针.

### 3.7 String 

`std::string::String`

<img src="../attach/img/langs/strings-in-rust.avif" alt="" width="400">

抽象, 比 C++ 的字符串还复杂. 要不咱们还是用 `GC<str>` 吧.

### 3.8 thread/sync

#### Rc 

`Rc<T>` 单线程引用计数智能指针. 需要避免循环引用.

#### Arc 

`Arc<T>` 原子版 Rc 

#### RefCell 

`RefCell<T>` 配合 Rc 使用.

#### Mutex 

#### RwLock 

## 4, Macros 

`name!(), name![], name!{}` 用于调用宏.

```rust 
println!("{}", "Hello there!"); 

// ---> 

use std::io::{self, Write};
io::stdout().lock().write_all(b"Hello there!\n").unwrap();
```

触发异常:
```rust 
panic!("this panics");
```

类型初始化:

```rust
let v1 = vec![1, 2, 3];

// --> 

let mut v1 = Vec::new();
v1.push(1);
v1.push(2);
v1.push(3);
```

格式化字符串:

```rust 
format!()
```

断言测试:

```rust 
assert!()
```

调试打印:

```rust 
dgb!()
```

代码占位符:

```rust 
todo!()
unimplemented!() // 明确标识未实现函数
```

### cfg 

条件编译宏: `cfg!, #[cfg()]`

### Pattern Match 

```rust 
fn print_number(n : Number) {
	match n.value {
		1 => println!("one"),
		2 => println!("two"),
		_ => println!("{}", n.value);
	}
}	
```

## 5, Traits 

类似 Go Interface, 定义一组接口, 用于类型抽象.

```rust 
trait Signed {
	fn is_strictly_negative(self) -> bool;
}
```

**Orphan rules**:
- one of your traits on anyone's type 
- anyone's trait on one of your types
- but not a foreign trait on a foreign type 

```rust 
// our trait on our type 
impl Signed for Number {
	fn is_strictly_negative(self) -> bool {
		self.value < 0
	}
}

// our trait on a foreign type (even like primitive type)
impl Signed for i32 {
	fn is_strictly_negative(self) -> bool {
		self < 0
	}
}

// a foreign trait on our type 
impl std::ops::Neg for Number {
	type Output = Number; 

	fn neg(self) -> Number {
		Number {
			value: -self.value,
			odd: self.odd,
		}
	}
}
```

## 6, Generics 

主要指编译期泛型.

```rust 
// 函数参数泛型
fn foobar<L, R>(left: L, right: R) {
	//...
}

// 数据结构泛型
struct Pair<T> {
	a: T,
	b: T,
}
```

就像 C++Concepts 一样, Rust 泛型也需要用 Trait 约束:

```rust 
use std::fmt::Debug; 

fn compare<T>(left: T, right: T)
where
	T: Debug + PartialEq, 
{
	println!("{:?} {} {:?}", left, if left == right { "==" } else { "!=" }, right};
}

// using like: compare("le", "ri");
```

当使用非基础类型时, 自动化类型推导可能失效, 使用 `::<...>` 来显式指定泛型类型.

```rust 
use std::any::type_name;

println!("{}", type_name::<i32>());
```

## 7 Crates 

指 Rust 的流行第三方库.

常见工具库:
- serde: 序列化反序列化 JOSN, TOML, YAML, BLOB 等
- anyhow: 基于 `Result<T, Error>` 进一步封装异常错误传播
- thiserror: 自定义错误类型
- log + env_logger: 日志 
- clap, argh: 命令行参数解析
- rayon: 基于线程池, 数据并行处理 
- regex: 正则表达式
- uuid 
- chrono: 基于 `std::time`
- rand: 随机数
- config, toml: 配置管理

异步与网络编程:
- tokio: 异步运行时 
- reqwest: 高级 HTTP 客户端, 基于 tokio/async
- hyper: 底层 HTTP 库

## Reference 

https://fasterthanli.me/articles/a-half-hour-to-learn-rust#function-types-closures

***

用 C++ 写 Rust:

```cpp
using Str = std::string;

template <typename T>
using Opt = std::optional<T>;

template <typename... Ts>
using Var = std::variant<Ts...>;

// 这里写法是错的
using Vec = std::vector<T>;
using List = std::list<T>;
using Deque = std::deque<T>;
using Set = std::set<T>;
using HashSet = std::unordered_set<T>;
using HashMap = std::unordered_map<K, V>;

using Box = std::unique_ptr<T>;

using Arc = std::shared_ptr<T>;

using Weak = std::weak_ptr<T>;

```
