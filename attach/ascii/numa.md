NUMA Machine:

```ascii

  +-----------------------------+        +-----------------------------+          
  |         NUMA Node 0         |        |         NUMA Node 1         |        
  |  CPUs: CPU0 CPU1 CPU2 CPU   |        |  CPUs: CPU4 CPU5 CPU6 CPU7  |        
  |  Local Memory: RAM bank 0   |        |  Local Memory: RAM bank 1   |        
  |                             |        |                             |        
  |  pg_data_t node_data[0]     |        |  pg_data_t node_data[1]     |        
  |  +-----------------------+  |        |  +-----------------------+  |          
  |  | Zone DMA              |  |        |  | Zone DMA              |  |          
  |  | Zone Normal           |  |        |  | Zone Normal           |  |          
  |  | Zone Movable          |  |        |  | Zone Movable          |  |          
  |  +-----------------------+  |        |  +-----------------------+  |          
  |            |                |        |            |                |          
  |            v                |        |            v                |          
  |  +-----------------------+  |        |  +-----------------------+  |          
  |  | Per-zone Buddy System |  |        |  | Per-zone Buddy System |  |            
  |  +-----------------------+  |        |  +-----------------------+  |          
  |            |                |        |            |                |          
  |            v                |        |            v                |          
  |  +-----------------------+  |        |  +-----------------------+  |          
  |  | struct page mem_map   |  |        |  | struct page mem_map   |  |          
  |  | one per physical page |  |        |  | one per physical page |  |          
  |  +-----------------------+  |        |  +-----------------------+  |              |                             |        |                             |          
  |  +-----------------------+  |        |  +-----------------------+  |          
  |  | LRU / reclaim lists   |  |        |  | LRU / reclaim lists   |  |          
  |  | active anon/file      |  |        |  | active anon/file      |  |          
  |  | inactive anon/file    |  |        |  | inactive anon/file    |  |          
  |  +-----------------------+  |        |  +-----------------------+  |          
  +-----------------------------+        +-----------------------------+          
                  \                                      /                       
                   \                                    /                        
                    +------------ NUMA interconnect ----+                         
                         remote memory access is slower                           
```