#include <linux/kfifo.h>

/*
 * internal helper to calculate the unused elements in kfifo.
 */
static inline unsigned int kfifo_unused(struct __kfifo *fifo)
{
	return (fifo->mask + 1) - (fifo->in - fifo->out);
}

// similar as kfifo_init, which not accepts buffer array outside.
int kfifo_alloc(struct kfifo *fifo, unsigned int size, 
								size_t esize, gfp_t gfp_mask)
{
	/*
	 * round up to the next power of 2, since our 'let the indices
	 * wrap' technique works only in this case.
	 */
	size = rounddown_pow_of_two(size);
	fifo->in = 0;
	fifo->out = 0;
	fifo->esize = esize;

	if (size < 2) {
		fifo->data = NULL;
		fifo->mask = 0;
		return -1; // -EINVAL
	}

	fifo->data = kmalloc(size *esize, gfp_mask);
	if (fifo->data == NULL) {
		fifo->mask = 0;
		return -1; // -ENOMEM
	}
	fifo->mask = size - 1;
	return 0;
}

void kfifo_free(struct kfifo *fifo)
{
	kfree(fifo->data);
	fifo->data = NULL;
	fifo->in = 0;
	fifo->out = 0;
	fifo->esize = 0;
	fifo->map = 0;
}


static void kfifo_copy_in(struct kfifo *fifo, const void *src,
		unsigned int len, unsigned int off)
{
	unsigned int size = fifo->mask + 1;
	unsigned int esize = fifo->esize;
	unsigned int l;

	off &= fifo->mask;
	if (esize != 1) {
		off *= esize;
		size *= esize;
		len *= esize;
	}
	l = min(len, size - off);

	memcpy(fifo->data + off, src, l);
	memcpy(fifo->data, src + l, len - l);
}

unsigned int kfifo_in(struct kfifo *fifo, const void *buf, unsgned int len)
{
	unsigned int l;
	l = kfifo_unused(fifo);
	// truncate the buffer if its length exceeds available space in kfifo.
	if (len > l)
		len = l;
	kfifo_copy_in(fifo, buf, len, fifo->in);
	fifo->in += len;
	return len; // check len==len' outside
}

static void kfifo_copy_out(struct kfifo *fifo, void *dst,
		unsigned int len, unsigned int off)
{
	unsigned int size = fifo->mask + 1;
	unsigned int esize = fifo->esize;
	unsigned int l;

	off &= fifo->mask;
	if (esize != 1) {
		off *= esize;
		size *= esize;
		len *= esize;
	}
	l = min(len, size - off);

	memcpy(dst, fifo->data + off, l);
	memcpy(dst + l, fifo->data, len - l);
}

unsigned int kfifo_out_peek(struct kfifo *fifo,
		void *buf, unsigned int len)
{
	unsigned int l;

	l = kfifo_len(fifo);
	if (len > l)
		len = l;

	kfifo_copy_out(fifo, buf, len, fifo->out);
	return len;
}

unsigned int kfifo_out(struct kfifo *fifo,
		void *buf, unsigned int len)
{
	len = kfifo_out_peek(fifo, buf, len);
	fifo->out += len; // remove from queue
	return len;
}
