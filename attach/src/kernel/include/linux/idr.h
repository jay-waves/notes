/*
 * maps, associative array, hash table. 
 *
 * Linux IDR (ID Allocator) 是类似哈希表的数据结构
 */

void idr_init(struct idr *idp);

/*
 * allocate a new *UID in [start, end)*, and associate it with `ptr`
 */
int idr_alloc(struct idr *idp, void *ptr, 
							int start, int end, fgp_t fgp_mask);

/*
 * allocates memory and disables preemption
 */
int idr_preload(gfp_t fgp_mask);

/*
 * reenables preemption
 */
int idr_preload_end(void);

void *idr_find(struct idr *idp, int id);

void idr_remove(struct idr *idp, int id);

void idr_destroy(struct idr *idp);
