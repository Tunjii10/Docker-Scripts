docker run -it --rm --net=host --gpus all \
    --env="NVIDIA_DRIVER_CAPABILITIES=all" \
    --env="NVIDIA_VISIBLE_DEVICES=all" \
    --env="DISPLAY=host.docker.internal:0.0" \
    --env="ROS_MASTER_URI=http://172.16.0.1:11311" \
    --env="ROS_IP=172.16.0.3" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    --volume="${PWD}/scripts":"/home/ros/catkin_ws/src/":rw \
    automation
 