---
code: <mutex>, <condition_variable>, <thread>
---

标准库 `<thread>`, `<mutex>` 等提供了对底层的线程和同步原语的直接控制.

```cpp
#include<thread>

void work() {
}

std::thread t(work);
```

启动线程后, 要保证其正确汇入 (joined) 或分离 (detached).

```cpp
void main(){
	std::thread t(work);
	t.detach(); // 不等待线程结束, 分离执行
}
```

使用 `detach()` 时, 如果 `work` 访问了作用域 `main` 中的局部变量, 并且 `main` 结束释放后 `work` 尚未结束工作, 可能会造成未定义行为 (UAF).

```cpp
void main(){
	std::thread t(work);
	t.join(); // 等待线程结束, 收回所有资源
}
```

### 传递参数方式

当编译器构造 `t1` 时, 会先使用 `f()` 构造一个类似 `F()()` 的[*函数子*](../stl/functor.md), 通过函数子的方式, 向 `f()` 传递参数. 用于输入数据的函数参数可以使用 `const` 修饰, 用于输出数据的函数参数应传入数据指针.

```cpp
void f(vector<double>& v);
struct F {
	vector<double>& v;
	F(vector<double>& vv) : v{vv} {}
	void operator()();
};

int main() {
	//...
	thread t1 {f, ref(vec1)}; // f(vec1)
	thread t2 {F{vec2}};      // F(vec2)()
	// ...
}
```

## 共享数据

标准输出 `cout` 不是线程安全, 多个线程的输出可能会相互混叠.

```cpp
voif f() { cout << "Hello"; }

struct F {
	void operator()() { cout << "world"; }
};

void user() {
	thread t1 {f};
	thread t2 {F()};

	t1.join();
	t2.join();
}
```

要在多个线程间安全共享数据, 避免[数据竞争](../../../sec/software-analysis/thread-safety/data-race.md), 需要使用各类[同步原语](../../../os/proc/thread-sync.md). 比如, 通过 `lock()` 获取一个*互斥量 (Mutex)*. 与传参方式相比, 共享数据不一定效率更高, 因为锁和原子操作是比较耗时的.

### lock_guard

基础的临界区 mutex 管理, 构造时加锁, 析构时解锁. 不支持手动解锁 (`unlock()`), 不支持各类标记类型 (如 `defer_lock`), 不支持条件变量. 

```cpp
#include <mutex>

{
	lock_guard<mutex> lock(mtx);
	// do something
}
```

### unique_lock

`unique_lock` 负责调用和管理 `m.lock() / m.unlock()`, 类似 `unique_ptr` 对内存的管理. 比 `lock_guard` 功能更多, 支持手动 `unlock()`, 性能开销稍高.

```cpp
#include <mutex>

mutex m;
int sh;

void f() {
	unique_lock<mutex> lck {m}; 
	sh += 7;
} // release mutex implicityly
```

### defer_lock

为了避免[死锁](../../../os/proc/thread-sync.md), 持有多个锁的线程要**同时**获取多个锁资源. 标准库提供了 `defer_lock` 标记类型, 使 `unique_lock` 不立即锁住互斥量, 等待后续显式调用 `lock`:

```cpp
void f() {
	...
	unique_lock<mutex> lck1 {m1, defer_lock};
	unique_lock<mutex> lck2 {m2, defer_lock};
	unique_lock<mutex> lck3 {m3, defer_lock};

	lock(lck1, lck2, lck3); // 同时获取
}
```

类似的标记类型还有 `std::try_to_lock`, `std::adopt_lock`

### try_to_lock

使 `unique_lock` 变为非阻塞锁:
- 若互斥量未锁定, 则 `unique_lock` 成功地将其锁定.
- 若互斥量已锁定, 则 `unique_lock` 不阻塞等待, 而是将锁状态设置为**未拥有**. 此时调用方法 `owns_lock()` 返回 `false`

```cpp
unique_lock<mutex> lock(m, std::try_to_lock);
if (lock) {
	...
}
```

### adopt_lock 

`std::unique_lock` 是对 `mutex` 的智能管理, 如果一个**已经存在且锁定**的互斥量, 想要使用 `unique_lock` 接管, 就需要 `std::adopt_lock` 标记. 通常是与更低级的调用 (比如 C API) 集成时使用, 转化为 C++ RAII 模式.

```cpp 
mtx.lock(); // 已锁定
unique_lock<mutex> lock(mtx, std::adopt_lock); // 接管
```

## ConditionVariable

详见 [condition_variable](condition_variable.md)

## StopToken 

C++20 引入 `stop_token`, 标准化: 异步任务的取消模型. 
- `request_stop()` 发出取消请求
- 线程中有两种取消方式:
	- 轮询 `stop_token.stop_requested()` 检查是否退出
	- 注册退出回调 `stop_token.register_callback(fn)`

比自己写 `atomic<bool>` 标志位更标准和简单.

## JThread 

`std::jthread` 在 `std::thread` 基础上, 添加了 `stop_token` 与 RAII 自动 `join()` 的封装. 

```cpp
jthread(F&& f, Args&&... args);

jthread t([] {
	...
});

// 自动注入 stop_token
jthread t([] (stop_token st) {
	...
	while(!st.stop_requested()) {
		...
	}
})
```