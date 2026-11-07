```ascii
User space
──────────

Process
  fd 0 ── stdin
  fd 1 ── stdout
  ...

Kernel space
────────────

                 ┌────────────────────┐
                 │   task_struct      │
                 │────────────────────│
                 │ pid                │
                 │ mm      ────────────────→ mm_struct
                 │ fs      ────────────────→ fs_struct
                 │ files   ───────┐   │
                 │ cred    ───┐   │   │
                 └────────────┘   │   │
                                  │
                                  ▼
                         ┌────────────────┐
                         │ files_struct   │
                         │────────────────│
                         │ count          │
                         │ fdt ─────┐     │
                         └──────────┘     │
                                          │
                                          ▼
                                ┌────────────────┐
                                │ fdtable        │
                                │────────────────│
                                │ fd[0] ─────────────→ struct file (stdin)
                                │ ...   ─────────────→ struct file (...)
                                │ fd[3] ───────┐
                                │ fd[4] ───┐   │
                                └──────────┘   │
                                               │
                                               ▼
                                      ┌────────────────────┐
                                      │ struct file        │
                                      │────────────────────│
                                      │ f_count            │
                                      │ f_mode             │
                                      │ f_flags            │
                                      │ f_pos              │
                                      │ f_op ──────────────┼──→ file_operations
                                      │ private_data       │
                                      │ f_inode ───────────┼──┐
                                      │ f_path             │  │
                                      └────────────────────┘  │
                                                              │
                                                              ▼
                                                   ┌────────────────────┐
                                                   │ struct inode       │
                                                   │────────────────────│
                                                   │ i_ino              │
                                                   │ i_mode             │
                                                   │ i_uid / i_gid      │
                                                   │ i_size             │
                                                   │ i_sb ──────────────┼──→ super_block
                                                   │ i_mapping ─────────┼──→ address_space
                                                   │ i_op ──────────────┼──→ inode_operations
                                                   │ i_fop ─────────────┼──→ default file_operations
                                                   └────────────────────┘
```