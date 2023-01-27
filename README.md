# panther-navigation
A GitHub template for Panther: creating a map a using Slam Toolbox and navigation with localization using Nav2

## Running demo

Given example is configured for Velodyne Puck, but any LIDAR publishing Pointcloud2 or LaserScan data will work with some configuration.

### Running lidar interface

Before running navigation demo you need to start lidar interface. 

For Velodyne Puck see: https://github.com/husarion/velodyne-docker

:bulb: **NOTE:** Remember to provide static transform between LIDAR and robot frame (default: `velodyne` and `base_link`).

### Download this repository

```bash
git clone https://github.com/husarion/panther-navigation
```

### Setup environment

```bash
export POINTCLOUD2_TOPIC=velodyne_points # change topic name to match your LIDAR pointcloud2 topic
export USE_SIM_TIME=False
```

### Setup navigation parameters

Navigation parameters for mapping and nav2 are stored inside `/config` directory. You can modify this files to suite your needs. For example you can change costmap observation source topic to match your LIDAR.

### Map environment

Before using Nav2 for autonomus drivig it is neccessary to provide map of environment. If you already have a map you can skip this step. In terminal run:

```bash
cd panther-navigation
docker compose -f compose.ros1_bridge.yaml -f compose.pc2ls.yaml -f compose.mapping.yaml up
# if you are not using 3D LIDAR run:
# docker compose -f compose.ros1_bridge.yaml -f compose.mapping.yaml up
```

This will run `slam_toolbox` interface for mapping environment. Map will be automatically saved every 5 seconds and stored in `maps` folder. You can display map using Rviz2, you can run it directly on your compoter if you have ROS2 installed or run it from NUC using VNC - see [Running Rviz2 on NUC](#running-rviz2-on-nuc). You can drive robot around using WebUI interface available at http://10.15.20.2:8000 in your browser. After mapping is complete you can terminate docker containers with `ctrl+c`.

### Run navigation with localization

Run navigation with localization.

```bash
docker compose -f compose.ros1_bridge.yaml -f compose.pc2ls.yaml -f compose.nav2.yaml up
# if you are not using 3D LIDAR run:
# docker compose -f compose.ros1_bridge.yaml -f compose.nav2.yaml up
```

To drive robot around use Rviz2, you can run it directly on your compoter if you have ROS2 installed or run it from NUC using VNC - see [Running Rviz2 on NUC](#running-rviz2-on-nuc). Specify robot goal position by choosing `2D Goal Pose` and clicking on provided map. Robot should generate a valid path and follow it.

## Running Rviz2 on NUC

To run and visualize Rviz2 on NUC run in new terminal:

```bash
docker compose -f compose.vnc.yaml -f compose.rviz.yaml up
```

To acces NUC desktop go to [10.15.20.3:6080](http://10.15.20.3:8080/vnc_auto.html) in your browser. You need to specify password (default: husarion). This should display NUC desktop with Rviz2 running.

## Running in simulation

### Simulation

Example demo with Navigation2, using The Husarion Panther robot equipped with Velodyne Puck.

### Download this repository

```bash
git clone https://github.com/husarion/panther-navigation
```

### Setup environment

```bash
xhost +local:docker
export POINTCLOUD2_TOPIC=/velodyne_points # change topic name to match your lidar pointcloud2 topic
export USE_SIM_TIME=True
```

### Map environment using slam_toolbox

Before using Nav2 for autonomus drivig it is neccessary to provide map of environment. If you already have map you can skip this step.

```bash
cd panther-navigation2
docker compose -f compose.simulation.yaml  -f compose.pc2ls.yaml -f compose.mapping.yaml -f compose.rviz.yaml up
```

This will run `slam_toolbox` interface for mapping environment. Map will be automatically saved every 5 seconds and stored in `maps` folder. You can drive robot around using WebUI interface available at http://localhost:8000 in your browser. After mapping is complete you can terminate docker containers with `ctrl+c`.

### Run navigation with localization

Run navigation with localization.

```bash
cd panther_navigation2
docker compose -f compose.simulation.yaml  -f compose.pc2ls.yaml -f compose.nav2.yaml -f compose.rviz.yaml up
```

To drive robot around use Rviz2. Specify robot goal position by choosing `2D Goal Pose` and clicking on provided map. Robot should generate a valid path and follow it.