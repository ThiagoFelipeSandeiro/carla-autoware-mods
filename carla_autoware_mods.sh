################################
##  Update to version 0.9.11  ##
################################

# INSTALL GIT LFS
curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash
sudo apt-get install git-lfs
git lfs install

# INSTALL CARLA-SIMULATOR
sudo apt-get install carla-simulator=0.9.11

# INSTALL CARLA-ROS-BRIDGE
# Setup folder structure
mkdir -p ~/carla-ros-bridge/catkin_ws/src
cd ~/carla-ros-bridge
git clone -b 0.9.11 https://github.com/carla-simulator/ros-bridge.git
cd ros-bridge
git submodule update --init
cd ../catkin_ws/src
ln -s ../../ros-bridge
source /opt/ros/melodic/setup.bash # Watch out, this sets ROS Melodic 
cd ..

# Install required ros-dependencies
rosdep update
rosdep install --from-paths src --ignore-src -r

# Build
catkin_make

# Add the source path
source ~/carla-ros-bridge/catkin_ws/devel/setup.bash

# INSTALL CARLA-AUTOWARE
git clone --recurse-submodules https://github.com/Kailthen/carla-autoware.git
patch ~/carla-autoware/Dockerfile ~/carla-autoware/update_Dockerfile.patch
cd carla-autoware && sudo ./build.sh
patch ~/carla-autoware/run.sh ~/carla-autoware/update_run.sh.patch


###########################
##  Live Docker Updates  ##
###########################

# COPY AUTOWARE-CONTENTS DIR TO RUNNING DOCKER
docker ps | grep -Eo '([0-9]|[a-z]){12}' | xargs -I %% docker cp ~/carla-autoware/autoware-contents %%:/home/autoware/autoware-contents

    ##################

# Create documents folder in running docker
docker ps | grep -Eo '([0-9]|[a-z]){12}' | xargs -I %% docker exec --user autoware -i %% mkdir ./Documents

    ##################

# Create patch for my_mission_planning.launch
diff ~/autoware.ai/install/vehicle_description/share/vehicle_description/launch/vehicle_model.launch ~/Documents/vehicle_model.launch > ~/Documents/state_publisher.patch

# Copy patch file to running docker
docker ps | grep -Eo '([0-9]|[a-z]){12}' | xargs -I %% docker cp ~/Documents/state_publisher.patch %%:/home/autoware/Documents

## Live Patch
# Run the patch file
docker ps | grep -Eo '([0-9]|[a-z]){12}' | xargs -I %% docker exec --user autoware -i %% patch Autoware/install/vehicle_description/share/vehicle_description/launch/vehicle_model.launch ./Documents/state_publisher.patch

## Local Patch
# Patch update vehicle_model.launch by changing state_publisher
#patch Autoware/install/vehicle_description/share/vehicle_description/launch/vehicle_model.launch ~/Documents/state_publisher.patch

# OR change manually
# vim Autoware/install/vehicle_description/share/vehicle_description/launch/vehicle_model.launch
# Change line 17 from state_publisher to robot_state_publisher

    ##################

# Create patch for my_mission_planning.launch
diff ~/carla-autoware/carla-autoware-agent/agent/launch/my_mission_planning.launch my_mission_planning.launch > update_my_mission_planning.patch

# Copy patch file to running docker
docker ps | grep -Eo '([0-9]|[a-z]){12}' | xargs -I %% docker cp ~/Documents/update_my_mission_planning.patch %%:/home/autoware/Documents

## Live Patch
# Run the patch file
docker ps | grep -Eo '([0-9]|[a-z]){12}' | xargs -I %% docker exec --user autoware -i %% patch carla-autoware/carla-autoware-agent/agent/launch/my_mission_planning.launch ./Documents/update_my_mission_planning.patch

## Local Patch
# Patch my_mission_planning.launch by changing enableRvizInput
#patch ~/carla-autoware/carla-autoware-agent/agent/launch/my_mission_planning.launch ~/Documents/update_my_mission_planning.patch

# OR change manually
# vim ~/carla-autoware/carla-autoware-agent/agent/launch/my_mission_planning.launch
# Change line 41 from true to false

####################################
##        Roslaunch Command       ##
####################################

roslaunch carla_autoware_agent carla_autoware_agent.launch town:=Town01 spawn_point:='338.761,-320.678,0.2,0,0,90'

roslaunch carla_autoware_agent carla_autoware_agent.launch town:=Town01 spawn_point:='340,240,0.2,0,0,270' spawn_ego_vehicle:=false remap_rviz_initialpose_goal:=false use_ground_truth_localization:=true synchronous_mode:=true synchronous_mode_wait_for_vehicle_control_command:=false enableRvizInput:=true

####################################
##        Useful Commands         ##
####################################

# Command for TTY bash terminal
docker ps | grep -Eo '([0-9]|[a-z]){12}' | xargs -I %% docker exec --user autoware -it %% bash

# Copy to local drive the current PythonAPI
docker ps | grep -Eo '([0-9]|[a-z]){12}' | xargs -I %% docker cp %%:/home/autoware/PythonAPI/carla-0.9.11-py2.7-linux-x86_64.egg .
vim ~/.bashrc

# Start carla-simulator server
/opt/carla-simulator/CarlaUE4.sh -carla-server

####################################
##        Start/Goal Pose         ##
####################################

# Create SimulationData folder and EgoCar.csv file
mkdir -p autoware_openplanner_logs/SimulationData
echo 'X,Y,Z,A,C,V,name,' >> ~/autoware_openplanner_logs/SimulationData/EgoCar.csv 
echo '338.761,-320.678,0.2,1.58954,0,0,0,' >> ~/autoware_openplanner_logs/SimulationData/EgoCar.csv
echo '339.013,-209.597,0,1.58954,0,0,destination_1,' >> ~/autoware_openplanner_logs/SimulationData/EgoCar.csv

#338.761,-206.678,0.00323963,1.57023,0,0,0,
#339.013,-209.597,0,1.58954,0,0,destination_1,



