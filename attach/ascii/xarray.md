```ascii
XArray
+------------------+
| xa_flags         |
| xa_lock          |
| xa_head ---------+-----------------------------+
+------------------+                             |
                                                 v
                                      +----------------------+
                                      | xa_node              |
                                      | shift = 12           |
                                      | offset = 0           |
                                      | count                |
                                      | slots[64]            |
                                      +----------+-----------+
                                                 |
              index bits                         |
              [ 17..12 ] choose slot             |
                                                 |
        +----------------+-----------------------+----------------+
        |                |                       |                |
        v                v                       v                v
   slot 0           slot 1                  slot 2           ...
   empty            internal node           internal node
                    shift = 6               shift = 6
                    slots[64]               slots[64]
                       |                       |
                       | index bits            | index bits
                       | [11..6]               | [11..6]
                       v                       v
                  +---------+             +---------+
                  | xa_node |             | xa_node |
                  | shift=6 |             | shift=6 |
                  +----+----+             +----+----+
                       |                       |
       index bits      |                       |
       [5..0] choose final slot                |
                       v
              +----------------+
              | slots[64]      |
              +---+---+---+----+
                  |   |   |
                  |   |   +--> value pointer / entry
                  |   +------> value pointer / entry
                  +----------> empty / sibling / retry / tagged entry
```