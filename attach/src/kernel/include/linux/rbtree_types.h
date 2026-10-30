/*
 * Copyright: GPL2, Andrea Arcangeli (1999)
 */

// in include/linux/rbtree_types.h
struct rb_node {
	unsigned long __rb_parent_color;
	struct rb_node *rb_right;
	struct rb_node *rb_left;
};

struct rb_root {
	struct rb_node *rb_node;
};

// not care rightmode node.
struct rb_root_cached {
	struct rb_root rb_root;
	struct rb_node *rb_leftmost;
}

#define RB_ROOT (struct rb_root) { NULL, }
#define RB_ROOT_CACHED (struct rb_root_cached){{NULL,},NULL}
