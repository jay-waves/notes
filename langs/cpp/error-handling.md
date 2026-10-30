## 错误处理

- 基于返回值
- 抛出异常
- `std::optional` 
- `tl::expected` 
- outcome, 类似 Rust `anyhow, thiserror`


异步程序的错误处理：
- 调用栈如果是线性的 (入栈出栈), 异常就可以顺着栈向上回溯.
- 调用栈如果是树状的 (异步逻辑), 就要顺着树枝向上回溯, 直到第一个分叉点.

## 返回值

通过返回值表示成功或失败. 可以使用特定错误码 `errno`, 或者规定一个正常值定义域之外的数字来标识错误. 不打断正常控制流, 因此必须显式检查.

```c
```

### error_code 

C++11 引入 `std::error_code` 类, 位于 `<system_error>` 头文件. 比异常性能更好, 更底层.

```cpp
std::error_code ec(ENOENT, std::generic_category());

std::cerr << ec.value() << "\n";
std::cerr << ec.message() << "\n";
std::cerr << ec.category().name() << "\n";

std::error_code ec = std::make_error_code(std::errc::no_such_file_or_directory);

if (ec) {
	... // 如果有错误
}

// 结合异常使用
throw std::system_error(ec);
```

error_code 错误类别包括:
- `std::generic_category` 通用错误类别, 映射到 POSIX errno 
- `std::system_category()` 操作系统特定错误

常见错误码 `std::errc`, 对应 [POSIX ERRNO](../../attach/src/kernel/errno.h).
```cpp
// 没有列出网络相关错误码

// fs
directory_not_empty
bad_file_descriptor
file_exists
file_too_large
filename_too_long
is_a_directory
not_a_directory
no_such_file_or_directory
text_file_busy
too_many_files_open
too_many_links
too_many_symbolic_link_levels
read_only_file_system


// func
not_supported
argument_list_too_long
argument_out_of_domain
invalid_argument

executable_format_error
function_not_supported

// io & device 
illegal_byte_sequence
inappropriate_io_control_operation
io_error
no_stream_resources
no_such_device_or_address
no_such_device
device_or_resource_busy
broken_pipe
stream_timeout

// os
resource_deadlock_would_occur
resource_unavailable_try_again
owner_dead
permission_denied
result_out_of_range
state_not_recoverable
timed_out

// process 
no_child_process
no_such_process
interrupted
no_lock_available


// memory 
not_enough_memory
no_space_on_device
no_buffer_space
```

### Expected 

将返回值封装为两种可能: `ok(T), err(E)`. c++ 常见的库是 [`tl::expected`](https://github.com/TartanLlama), 在 c++23 可以用 `std::expected`

```cpp
template <typename T, typename E>
struct Expected {
	enum Type {
		Ok,
		Err,
	};
	
	Type type;
	union {
		T value;
		E error;
	};
};
```

优点是天然适合链式编程 (monadic). c++ 提供了 `and_then()` 方法, 让错误 `E` 自动透传 (propagate), 在错误时立刻返回, 不执行后续调用链. 

```cpp
std::expected<V, E> f() {
	... 
		return std::unexpected(...);
	
	return xxx;
}

f().and_then(g).and_then(h);

// 不需要层层检查
auto a = f();
if (!a) return a;
auto b = g(*a);
if (!b) return b;
h(*b);
```

由于 `std::expected` 是值语义, 因此无需像 异常 一样进行栈展开. 控制流是明确的.

### Option

类似 Rust 的 Option 概念, 或者 Haskell 的 Maybe. 用 Option 包装一个返回值, 返回值可能正常, 也可能是错误的 (`nullopt`), 在语义上区分了正确与错误的返回值, 并且不打断控制流.

```cpp
#include <optional>

std::optional<int> parseSomething(const std::string& str) noexcept {
	size_t pos;
	int result = std::stoi(str, &pos); 
	if (pos == str.length())
		return result;
	return std::nullopt;
}

std::optional<int> opt = 1;

// 直接取值, 可能失败
*opt;

// 使用 value(), 无值则抛出异常
try {
	opt.value();
} catch (const std::bad_optional_access& e) { }

// 使用 value_or() 提供默认值
opt.value_or(0);

// 无异常判断方法:
if (opt.has_value()) 
	...

if (opt == std::nullopt)
	...
```

## 断言

检查失败立即终止程序. 适合开发阶段正确性测试, 在发布时利用编译手段禁用内部断言, 提高整体效率. 

```cpp
#include <cassert>

assert(b != 0);
```

## 异常

使用*异常 (Exceptions)* 会打断正常控制流, 将常规逻辑和错误处理逻辑分离. 常见设计错误是常规逻辑依赖于*异常*导致的控制流.

声明方法: 
```cpp
throw domain_error ("divided by zero");
```

常见异常: 
- `domain_error`: 定义在 `<stdexcept>`, 报告函数参数取值不可接受.


捕捉异常:
```cpp
try {
	/**/
}catch( some_error ){
	/* handle an exception*/
}
```

```cpp
class TracedException {
public:
    TracedException(
                std::string_view msg = {},
                std::stacktrace trc = std::stacktrace::current()) {
        if (!msg.empty()) {
            std::cerr << msg << '\n';
        }
        std::cerr << trc;
    }
};
 
void f() {
    // ...
    throw TracedException("Full stacktrace");
}
```

错误较可能发生, 并且我们能处理的时候, 使用返回值. 这样看上去就像正常的业务逻辑. 当错误有很小概率发生, 发生后又很难恢复, 使用异常, 将错误和业务逻辑隔离开. C++ 标准库也在混用异常和返回值 (如 `filesystem`)

有一些情景必须使用异常:
- 重载运算符

有一些情景则必须使用返回值 (某种定义好的错误码):
- 分布式, 远程服务. 如 HTTP 的 4xx, 5xx 返回码.
- 操作系统调用相关.

有一些情景需要特殊处理:
- 异步编程. 需要回调函数, 如注册一个 `onFailure()`. 或者 Promise 机制, 来实现链式执行.

不捕获异常可能导致的问题:
- 未捕获的异常, 会调用 `terminate()`, 这导致析构不会被执行.
- 异常跨 DLL 边界, 导致主 EXE 异常. 因为 SO 和 EXE 不一定使用同一版本标准库运行时.
- 由于 c++ 异常没有根类, 理论上任何类型都会被抛出, 用 `try{}catch(...)` 兜底

### 异常分类

```cpp
#include <exception>
std::exception  // 标准异常
std::bad_exception  // 意外异常处理失败时抛出
```

异常类型:
```cpp
#include <stdexcept>
using namespace std;

logic_error
domain_error
invalid_argument 
length_error 
out_of_range

runtime_error 
overflow_error // 算术溢出
underflow_error // 算术下溢
range_error 
system_error 

#include <new>
bad_alloc 
bad_array_new_length 

#include <typeinfo>
bad_cast  // dynamic_cast 失败
bad_typeid
```

### 禁用异常

`-fno-exceptions` 或 `/EHs- /EHc-`. 禁用 `try-catch-throw`, 所以标准库异常都会直接终止程序. 由于代码无需异常表 (EH tables), 二进制小, 性能稳定. 

标准库有抛异常的接口, 但也提供不抛异常的接口. 使用 `noexcept` 可以让编译器检查, 函数中是否有隐藏的可能抛出异常的接口.

### noexcept

声明某函数不会抛出异常. 标准库 STL 的优化行为会参考这个关键字:
- `std::vector<T>` 扩容时, 如果 STL 没有禁用异常, 并且 `T` 的移动构造函数没有声明 `noexcept`, 扩容函数不会调用移动构造函数, 而实用拷贝构造函数. ???


### StackTrace 

提供异常中捕获调用栈的能力, 类似 Python 的报错:
- https://github.com/jeremy-rifkin/cpptrace
- `boost::stacktrace`
