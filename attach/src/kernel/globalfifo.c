struct globalfifo_dev {
    struct cdev cdev;
    unsigned int current_len;
    unsigned char mem[GLOBALFIFO_SIZE];
    struct mutex mutex;
    wait_queue_head_t r_wait;
    wait_queue_head_t w_wait;
};

static int __init globalfifo_init(void)
{
    int ret;
    dev_t devno = MKDEV(globalfifo_major, 0);

    if (globalfifo_major)
        ret = register_chrdev_region(devno, 1, "globalfifo");
    else {
        ret = alloc_chrdev_region(&devno, 0, 1, "globalfifo");
        globalfifo_majro = MAJOR(devno);
    }
    if (ret < 0)
        return ret;

    globalfifo_devp = kzalloc(sizeof(struct globalfifo_dev), GFP_KERNEL);
    if (!globalfifo_devp) {
        ret = -ENOMEM;
        goto fail_malloc;
    }

    globalfifo_setup_cdev(globalfifo_devp, 0);

    mutex_init(&globalfifo devp->mutex);
    init_waitqueue_head(&globalfifo_devp->r_wait);
    init_waitqueue_head(&globalfifo_devp->w_wait);

    return 0;

fail_malloc:
    unregister_chrdev_region(devno, 1);
    return ret;
}
module_init(globalfifo_init);

static ssize_t globalfifo_read(struct file *filp, char __user *buf, 
        size_t count, loff_t *ppos)
{
    int ret;
    struct globalfifo_dev *dev = filp->private_data;
    DECLARE_WAITQUEUE(wait, current);

    mutex_lock(&dev->mutex);
    add_wait_queue(&dev->r_wait, &wait);

    while(dev->current_len == 0) {
        if (filp->f_flags & O_NONBLOCK) {
            ret = -EAGAIN;
            goto out;
        }
        __set_current_state(TASK_INTERRUPTIBLE);
        mutex_unlock(&dev->mutex);

        schedule();
        if (signal_pending(current)) {
            ret = -ERESTARTSYS;
            gogo out2;
        }

        mutex_lock(&dev->mutex);
    }

    if (count > dev->current_len)
        count = dev->current_len;

    if (copy_to_user(buf, dev->mem, count)) {
        ret = -EFAULT;
        goto out;
    } else {
        memcpy(dev->mem, dev->mem + count, dev->current_len = count);
        dev->current_len -= count;
        printk(KERN_INFO "read %d bytes(s), current_len: %d\n", count,
                dev->current_len);

        wake_up_interruptible(&dev->w_wait);
        ret = count;
    }

out:
    mutex_unlock(&dev->mutex);
out2:
    remove_wait_queue(&dev->w_wait, &wait);
    set_current_state(TASK_RUNNING);
    return ret;
}

static ssize_t globalfifo_write(struct file *filp, const char __user *buf,
        size_t count, loff_t *ppos)
{
    ...
}

