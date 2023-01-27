# panther-navigation
A GitHub template for Panther: creating a map using Slam Toolbox and navigation with localization using Nav2

## Running the demo

The given example is configured for Velodyne Puck, but any LIDAR publishing Pointcloud2 or LaserScan data will work with some configuration.

### Running lidar interface

Before running the navigation demo you need to start the LIDAR interface. 

For Velodyne Puck see: https://github.com/husarion/velodyne-docker

:bulb: **NOTE:** Remember to provide static transform between LIDAR and robot frame (default: `velodyne` and `base_link` see: https://github.com/husarion/velodyne-docker#run-with-the-husarion-panther-robot).

### Download this repository

```bash
git clone https://github.com/husarion/panther-navigation
```

### Setup environment

```bash
cd panther-navigation
source setup_virtual_desktop.sh
export POINTCLOUD2_TOPIC=velodyne_points # change topic name to match your LIDAR pointcloud2 topic
export USE_SIM_TIME=False
```

### Setup navigation parameters

Navigation parameters for mapping and nav2 are stored inside `/config` directory. You can modify these files to suit your needs. For example, you can change the costmap observation source topic to match your LIDAR.

### Map environment

Before using Nav2 for autonomous driving it is necessary to provide a map of the environment. If you already have a map you can skip this step. In terminal run:

```bash
docker compose -f compose.ros1_bridge.yaml -f compose.pc2ls.yaml -f compose.mapping.yaml -f compose.vnc.yaml -f compose.rviz.yaml up
# if you are not using 3D LIDAR run:
# docker compose -f compose.ros1_bridge.yaml -f compose.mapping.yaml up
```

To access the NUC desktop and Rviz2 interface go to [10.15.20.3:8080](http://10.15.20.3:8080/vnc_auto.html) in your browser. You need to specify the password (default: husarion).

`slam_toolbox` interface for mapping the environment will be launched. Map will be automatically saved every 5 seconds and stored in the `maps` directory. You can drive the robot around using the WebUI interface available at http://10.15.20.2:8000 in your browser. After mapping is complete you can terminate docker containers with `ctrl+c`.

### Run navigation with localization

Run navigation with localization.

```bash
source setup_virtual_desktop.sh
docker compose -f compose.ros1_bridge.yaml -f compose.pc2ls.yaml -f compose.nav2.yaml -f compose.vnc.yaml -f compose.rviz.yaml up
docker compose -f compose.ros1_bridge.yaml -f compose.pc2ls.yaml -f compose.nav2.yaml up
# if you are not using 3D LIDAR run:
# docker compose -f compose.ros1_bridge.yaml -f compose.nav2.yaml up
```

To access the NUC desktop and Rviz2 interface go to [10.15.20.3:8080](http://10.15.20.3:8080/vnc_auto.html) in your browser. You need to specify the password (default: husarion).

To drive the robot around use Rviz2. Specify the robot goal position by choosing `2D Goal Pose` and clicking on the provided map. The robot should generate a valid path and follow it. You can also use the `2D Pose Estimate` button to fix the robot's position on the map.

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

Before using Nav2 for autonomous driving it is necessary to provide a map of the environment. If you already have a map you can skip this step.

```bash
cd panther-navigation2
docker compose -f compose.simulation.yaml  -f compose.pc2ls.yaml -f compose.mapping.yaml -f compose.rviz.yaml up
```

This will run the `slam_toolbox` interface for mapping environment. A map will be automatically saved every 5 seconds and stored in the `maps` directory. You can drive the robot around using the WebUI interface available at http://localhost:8000 in your browser. After mapping is complete you can terminate docker containers with `ctrl+c`.

### Run navigation with localization

Run navigation with localization.

```bash
cd panther_navigation2
docker compose -f compose.simulation.yaml  -f compose.pc2ls.yaml -f compose.nav2.yaml -f compose.rviz.yaml up
```

To drive the robot around use Rviz2. First, use the `2D Pose Estimate` button to fix the robot's position. Specify the robot goal position by choosing `2D Goal Pose` and clicking on the provided map. The robot should generate a valid path and follow it.