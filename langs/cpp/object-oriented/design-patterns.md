## 设计模式

设计模式 (Design Pattern)

1. [创建型模式:](factory-pattern.md)
	- [工厂模式 (Factory Pattern)](factory-pattern.md)
	- 抽象工厂模式 (Abstract Factory Pattern, Family Creator). 创建一组相关的对象.
    - 建造者模式 (Builder Pattern, Lego Master). 按步骤创建对象.
	- [单例模式 (Singleton Pattern, One and Only). 全局唯一对象.](singleton-pattern.md)
	- 原型模式 (Prototype Pattern, Cloner). 学习样例创建副本.
2. 结构型模式
	- 适配器模式 (Adapter Pattern, Universal plug). 连接不同的接口.
	- 桥接模式 (Bridge Pattern, Connector). Link what it is to how it works.
	- 过滤器模式 (Filter, Criteria Pattern)
	- 组合模式 (Composite Pattern, Tree Builder). 创建树形数据结构.
	- [装饰器模式 (Decorator Pattern, Customizer). 向已存在对象添加新功能.](mixin.md)
	- 外观模式 (Facade Pattern, One-stop shop). 整个系统对外仅暴露简单接口.
	- [享元模式 (Flyweight Pattern, Space Saver). 共享小的可复用的资源.](../../../algo/concurrency/mem-pool.md)
	- 代理模式 (Proxy Pattern, Stand-In Actor). 
3. 行为型模式:
	- 责任链模式 (Chain of Responsibility Pattern, Request Relay). 不断向下传递请求, 直到负责者.
	- 命令模式 (Command Pattern, TaskWrapper), 将请求变为一个就绪对象
	- 解释器模式 (interpreter Pattern)
	- [迭代器模式 (Iterator, Collection Explorer)](../stl/iterator.md)
	- 中介者模式 (Mediator, Communication Hub). 用中介来简化对象间的通信.
	- 备忘录模式 (Memento, Time Capsule). 捕获并保存对象状态.
	- [观察者模式 (Observer, Broadcaster)](observer-pattern.md)
	- 状态机模式
	- 空对象模式
	- 策略模式
	- 模板模式
	- 访问者模式 (Visitor, Skillful Guest). 类似 `std::apply([](){}, ...)`

## 设计模式原则(SOLID)

Robert C. Martin:
* SRP (Single Responsibility Principle, 单一职责原则)
* OCP (Open-Closed Principle, 开闭原则): 对扩展开放, 对修改关闭, 实现热插拔.
* LSP (Liskov Substitution Principle, 里氏代换原则): 子类总可以替换基类.
* ISP (Interface Segregation Principle, 接口隔离原则): 接口有独立性.
* DIP (Dependency Inversion Principle, 依赖倒转原则): 依赖于抽象而不是具体

总之, 类的变化边界要清晰. 类内变化原因一致, 无关变化不传播, 职责清晰, 复杂性藏于局部. 

* 迪米特法则 (Demeter Principle): 少与其他实体发生相互作用, 保持独立性.
* 合成复用原则 (Composite Reuse Principle): 组合优于继承

## 参考

Design Patterns in Modern C++. Dmitri Nesteruk.

PoF.


