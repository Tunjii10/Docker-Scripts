# Original command (broke)
docker run -it --net=host --gpus all \
    --env="NVIDIA_DRIVER_CAPABILITIES=all" \
    --env="DISPLAY=host.docker.internal:0.0" \
    --env="LIBGL_ALWAYS_INDIRECT=0" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    --volume="${PWD}/scripts":"/home/ros/catkin_ws/src/test/src/":rw \
    project_stonefish