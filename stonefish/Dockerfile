ARG BASE_IMAGE=nvidia/cuda
ARG BASE_TAG=12.1.1-base-ubuntu20.04

FROM ${BASE_IMAGE}:${BASE_TAG}

ENV DEBIAN_FRONTEND=noninteractive

#Setup and dependencies
RUN apt-get update && apt-get install -y \
 wget \
 curl \
 mesa-utils \
 vim \
 locales \
 lsb-release \
 git \
 bash-completion \
 build-essential \
 sudo \
 #stonefish dependencies
 libglm-dev \
 libsdl2-dev \
 libfreetype6-dev \
 doxygen \
 && dpkg-reconfigure locales \
 && rm -rf /var/lib/apt/lists/*

# Install ROS Noetic and dependencies
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list' \
 && curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add - 
RUN apt-get update \
 && apt-get install -y --no-install-recommends ros-noetic-desktop-full \
 && apt-get install -y --no-install-recommends python3-rosdep \
 && rosdep init \
 && rosdep fix-permissions \
 && rosdep update \
 && rm -rf /var/lib/apt/lists/*


# Create User
ARG UID=1000
ARG GID=1000
RUN addgroup --gid ${GID} ros
RUN adduser --gecos "ROS User" --disabled-password --uid ${UID} --gid ${GID} ros
RUN usermod -a -G dialout ros
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

#setup stonefish
WORKDIR ${HOME}
RUN git clone "https://github.com/patrykcieslak/stonefish.git" \
 && cd stonefish \
 && mkdir build \
 && cd build \
 && cmake .. \
 && make -j$(nproc) \
 && sudo make install

#set up stone fish ros 
WORKDIR ${HOME}/catkin_ws/src
RUN source /opt/ros/noetic/setup.bash \ 
 && catkin_init_workspace \
 && git clone "https://github.com/patrykcieslak/stonefish_ros.git" \
 && git clone "https://bitbucket.org/iquarobotics/cola2_msgs.git" \
 #example project
#  && git clone "https://bitbucket.org/udg_cirs/cola2_stonefish.git" \
#  && git clone "https://bitbucket.org/iquarobotics/girona500_description.git" \
#  && git clone "https://bitbucket.org/udg_cirs/cola2_girona500.git" \
#  && git clone "https://bitbucket.org/udg_cirs/cola2_lib.git" \
 && cd ../ \
 && catkin_make \
 && source ~/catkin_ws/devel/setup.bash

#create package
RUN source /opt/ros/noetic/setup.bash \ 
 && catkin_create_pkg test std_msgs rospy roscpp stonefish_ros cola2_msgs \ 
 && cd ../ \
 && catkin_make \
 && source ~/catkin_ws/devel/setup.bash

# set up entrypoint
COPY config/entrypoint.sh /ros_entrypoint.sh
RUN sudo chmod +x /ros_entrypoint.sh \
 && sudo chown ros /ros_entrypoint.sh 

# Clean image
RUN sudo apt-get clean && sudo rm -rf /var/lib/apt/lists/* 

#Entrypoint and CMD
ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]



