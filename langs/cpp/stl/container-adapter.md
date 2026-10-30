容器适配器 (container adpaters) 是对基础容器 (vector, list, deque) 的上层封装, 并提供特定的接口和抽象. 

- `stack`: 底层容器为 `deque` (也支持 `list`), 限定了 LIFO 操作.
- `queue`: 底层容器为 `deque` (也支持 `list`), 限定了 FIFO 操作.
- `priority_queue`: 底层容器为 `vector` , 使用堆排序. 插入删除的效率为 $O(\log n)$


```cpp
#include <iostream>
#include <stack>

int main() {
    std::stack<int> stack;

    // 入栈
    stack.push(1);
    stack.push(2);
    stack.push(3);

    // 访问和出栈
    while (!stack.empty()) {
        std::cout << "Top: " << stack.top() << std::endl;
        stack.pop();
    }

    return 0;
}

```

## stack

栈是先进后出 (FILO) 数据结构, 只有同一个出入口, 只能操作栈顶元素. 栈不能迭代.

```cpp
stack<T> stkT;

push(elem);
pop();
top();
```

## queue

队列是一种先进先出 (FIFO) 的数据结构. 队列不能迭代.

```cpp
queue<T> queT;

push(elem);
pop();
back();
front();
```

## priority_queue

`std::priority_queue` 是 STL 中的一种[container-adapter](container-adapter.md). 默认情况下是最[堆](../../../algo/tree/binary-heap.md), 但是可自定义比较函数 `Compare()` 来改变行为. 

```cpp
template<
	class T,
	class Container = std::vector<T>,
	class Compare = std::less<typename Container::value_type>
> class priority_queue;

empty()
size()
top()
push()
pop()
```

模拟最小堆:

```cpp
using std::priority_queue;
using std::vector;
using std::greater;

priority_queue<int, std::vector<int>, std::greater<int>> min_heap;
```