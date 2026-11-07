/*
 * 内核版本**循环队列**, 队列含义是: first data in is the first data out, fifo. 
 * kfifo 内部数据是一段缓冲 buffer, 输入输出数据也是指定长度的缓冲.
 */

// 计算余数的成本比较高. 所以将大小规定为 2^n, 通过 (in - out) & mask 直接计算标的.
// 如果 `in = out`, 队列是空的.
// 如果 `(in - out) > mask`, 队列已满
struct kfifo {
    void *buffer;    
    unsigned int esize;  /* element size */
    unsigned int mask;   /* size of kfifo, 2^n */
    unsigned int in;     /* index of queue in */
    unsigned int out;    /* index of queue out */
};

// allocate and initialize kfifo, return 0 on success.
int kfifo_alloc(struct kfifo *fifo, unsigned int size, gfp_t gfp_mask);
void kfifo_free(struct kfifo *fifo);

unsigned int kfifo_in(struct kfifo *fifo, const void *from, unsigned int len);
unsigned int kfifo_out(struct kfifo *fifo, const void *to, unsigned int len);
unsigned int kfifo_out_peek(struct kfifo *fifo, const void *to, 
													unsigned int len, unsigned offet);

/**
 * kfifo_len - returns the number of used elements in the fifo
 * @fifo: address of the fifo to be used
 */
#define kfifo_len(fifo) \
({ \
	typeof((fifo) + 1) __tmpl = (fifo); \
	__tmpl->kfifo.in - __tmpl->kfifo.out; \
})

/**
 * kfifo_is_empty - returns true if the fifo is empty
 * @fifo: address of the fifo to be used
 */
#define	kfifo_is_empty(fifo) \
({ \
	typeof((fifo) + 1) __tmpq = (fifo); \
	__tmpq->kfifo.in == __tmpq->kfifo.out; \
})

/**
 * kfifo_is_full - returns true if the fifo is full
 * @fifo: address of the fifo to be used
 */
#define	kfifo_is_full(fifo) \
({ \
	typeof((fifo) + 1) __tmpq = (fifo); \
	kfifo_len(__tmpq) > __tmpq->kfifo.mask; \
})


/*
 * 宏用法解释:
- `fifo+1` 利用了 c 指针特性, 其地址实际增加的值为 `sizeof(kfifo)`. 实际隐式检查了 fifo 的类型.
- `typeof()` 声明 `__tmpq` 为 `fifo` 同类型. 这是一种非标准编译器扩展, 可用 `__typeof__` 避免编译器严格检查.
- `__tmpq = (fifo)` 用临时变量存储 fifo, 避免传入的是右值 (无法复用), 如传入 `kfifo_get(&my_fifo)`
*/
