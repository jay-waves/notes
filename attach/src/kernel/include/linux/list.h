/*
 * 内核中使用**双向循环列表**
 *  内核链表使用入侵式设计, 即将链表头嵌入其他数据结构的末尾来使用, 
 *  链表接口不负责相关内存管理 (即, 不假设数据是在栈还是在堆实现的).
 */

typedef struct list_head {
	struct list_head *next;
	struct list_head *prev;
} list_head;

struct some_data {
	int a;
	int b;
	list_head list;
};

/*
 * 入侵式链表, 仍通过链表头 list_head 管理链表结构. 
 * 但由于 list_head 嵌入在数据头 some_data 之中, 通过 list_head 获取数据比较麻烦, 
 * 需要手动计算成员偏移量:
 */

/*
 * The trick here is that `(st *)0` is equivalent to `(st *)NULL`, 
 * indicating that the new ptr of `st` points at the zero address.
 * for example: offsetof(struct data, a) = &data.a - &data. 
 * size_t, offsetof is defined in <stddef.h>
 */
#define offsetof(st, m) ( (size_t) &(((st *)0)->m) )

// access the container of list_head
#define container_of(ptr, type, member) (           \
	(type *)( (char *)ptr - offsetof(type, member) )  )

// add type-check: if ptr is actually a ptr of member.
// also known as `list_entry()`
#define container_of_safe(ptr, type, member) ({                \
	const typeof( ((type *) 0)->member ) *__mptr = (ptr);   \
	(type *)( (char *)__mptr - offsetof(type, member) );   })

/* API */

// initialize a list_head's prev/next pointer at runtime.
#define INIT_LIST_HEAD(ptr) do { \
    (ptr)->next = (ptr); \
    (ptr)->prev = (ptr); \
} while (0)

// get a linked_list_head variable named `name` at compile time.
#define LIST_HEAD(name)                        \
    struct list_head name = { &(name), &(name) }

#define list_add(new, head) do {               \
    (new)->next = (head)->next;                \
    (new)->next->prev = (new);                 \
    (new)->prev = (head);                      \
    (head)->next = (new);                      \
} while (0)

// add new at the end of list (immeadiately before head)
#define list_add_tail(new, head) do {        \
    struct list_head *_prev = (head)->prev;  \
    (new)->next = (head);                    \
    (new)->prev = _prev;                     \
    _prev->next = (new);                     \
    (head)->prev = (new);                    \
} while (0)

// remove entry from the list structure, but not free its memory
#define list_del(entry) do {                    \
    struct list_head *_prev = (entry)->prev;    \
    struct list_head *_next = (entry)->next;    \
    _next->prev = _prev;                        \
    _prev->next = _next;                        \
    (entry)->next = (entry)->prev = NULL;       \
} while (0)

// member is the name of list_head in typeof(*pos)
#define list_next_entry(pos, member)     \
	container_of((pos)->member.next, typeof(*(pos)), member)

// `ptr` points at the header of linked list, which is independent from data.
#define list_first_entry(ptr, type, member) \
	container_of((ptr)->next, type, member)

#define list_for_each(pos, head) \
	for (pos = (head)->next; pos != (head); pos = pos->next)

#define list_for_each_entry(pos, head, member)                       \
    for (pos = list_first_entry(head, typeof(*pos), member); \
         &pos->member != (head);                                     \
         pos = list_next_entry(pos, member))

