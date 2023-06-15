#!/bin/bash
set -e

# Adding all the necessary ros sourcing
echo "" >> ~/.bashrc
echo "## ROS" >> ~/.bashrc
echo "source /opt/ros/melodic/setup.bash" >> ~/.bashrc
echo "source ~/catkin_ws/devel/setup.bash" >> ~/.bashrc

# setup environment
source $HOME/.bashrc 
# start in home directory 
cd  
exec bash -i -c $@
