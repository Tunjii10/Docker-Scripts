ARG BASE_IMAGE=nvidia/cuda
ARG BASE_TAG=12.1.0-base-ubuntu18.04

FROM ${BASE_IMAGE}:${BASE_TAG}

ENV DEBIAN_FRONTEND=noninteractive
ENV ROS_MASTER_URI=http://172.16.0.1:11311
ENV ROS_IP=172.16.0.3

#Setup and dependencies
RUN apt-get update && apt-get install -y \
 wget \
 curl \
 vim \
 locales \
 inetutils-ping \
 lsb-release \
 git \
 bash-completion \
 build-essential \
 sudo \
 && dpkg-reconfigure locales \
 && rm -rf /var/lib/apt/lists/*

# Install ROS Melodic and dependencies
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list' \
 && curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add - 
RUN apt-get update \
 && apt-get install -y  ros-melodic-desktop-full \
 python-rosdep \
 python-rosinstall \
 python-rosinstall-generator \
 python-wstool \
 ros-melodic-franka-ros \
 ros-melodic-libfranka \
 ros-melodic-franka-description \
 ros-melodic-moveit \
 ros-melodic-rviz-visual-tools \
 ros-melodic-moveit-visual-tools \
 && rosdep init \
 && rosdep update \
 && rm -rf /var/lib/apt/lists/*


# Create User
ARG UID=1000
ARG GID=1000
RUN addgroup --gid ${GID} ros
RUN adduser --gecos "ROS User" --disabled-password --uid ${UID} --gid ${GID} ros
RUN usermod -a -G dialout ros 
RUN usermod -a -G audio ros 
ADD config/99_aptget /etc/sudoers.d/99_aptget
RUN chmod 0440 /etc/sudoers.d/99_aptget && chown root:root /etc/sudoers.d/99_aptget

# Change user
ENV USER ros
USER ros 

# Change HOME environment variable
ENV HOME /home/${USER} 

# workspace setup
RUN mkdir -p ${HOME}/catkin_ws/src

# initialise workspace 
SHELL [ "/bin/bash" , "-c" ]

WORKDIR ${HOME}/catkin_ws/src

# RUN source /opt/ros/melodic/setup.bash \ 
#  && catkin_init_workspace 
#  && catkin_create_pkg automation std_msgs rospy roscpp \ 

# set up entrypoint
COPY config/entrypoint.sh /ros_entrypoint.sh
RUN sudo chmod +x /ros_entrypoint.sh \
 && sudo chown ros /ros_entrypoint.sh 

# Clean image
RUN sudo apt-get clean && sudo rm -rf /var/lib/apt/lists/* 

#Entrypoint and CMD
ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]



