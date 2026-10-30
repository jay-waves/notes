感知、认识交互、运动控制

## pipeline 

### 1. 目标表达

用 TF 将目标统一到规划坐标系，检查是否在 workspace 

### 2. 逆运动学

把“末端姿态”变为“关节角”的解

### 3. 路径规划

从当前关节到目标关节找一个无碰路径，路径由离散的 waypoint 表示

约束：碰撞、关节限位、速度与加速度

### 4. 轨迹生成

给路径加时间维度，得到执行轨迹

约束：限速、限加速度、平滑


### 5. 控制执行 

执行器 controller 执行路径轨迹，同时以固定循环频率，读取关节状态，计算控制量（位置、速度、力矩）

#### 速度

`geometry_msgs/Twist /cmd_vel` 
* `linear.x` 前进速度
* `angular.z` 角速度

### 6. 底层驱动 

控制器交给硬件驱动，主要是电机驱动。传感器实时回传状态给控制器。 


## 坐标系

```
map
 └── odom
      └── base_link
           ├── camera_link
           ├── lidar_link
           └── ee_link
```


#### map, world 

全局参考系，一般固定不动

#### base_link 

一般指机器人本体坐标系：
* x 前
* y 左
* z 上

<img src="../attach/img/robo/adam-lite.webp" alt="pnd-botics" width="400">


#### odometry 里程计坐标系

局部连续坐标系，不会跳变，会漂移 （drift）

`nav_msgs/Odometry /odom` 


#### 传感器坐标系 

camera_link, lidar_link, imu_link 传感器坐标系，这是数据的默认坐标系

#### end-effector 坐标系

机械臂末端

## Software 

* Eigen 线性代数
* KDL (Kinematics and Dynamics Library) 
* 
