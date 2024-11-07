FROM ros:humble-ros-base-jammy

SHELL ["/bin/bash", "-c"]

# install wget
RUN apt-get update && apt-get install -y wget python3-jenkinsapi ca-certificates curl

# setup docker
RUN curl -fsSL https://get.docker.com -o get-docker.sh && \
    ./get-docker.sh

# download repos
RUN mkdir -p /root/ros2_ws/src

WORKDIR /root/ros2_ws

RUN wget https://raw.githubusercontent.com/HansRobo/colcon-ros-buildfarm/refs/heads/devel-customized/crb.repos
    
RUN service docker start && \
    source /opt/ros/humble/setup.bash && \
    vcs import src < crb.repos && \
    rosdep update && \
    rosdep install -riy --from-paths src && \
    colcon build

RUN source /root/ros2_ws/install/setup.bash && \
    ros_buildfarm release --continue-on-error --config-url https://raw.githubusercontent.com/HansRobo/colcon-ros-buildfarm/refs/heads/devel-customized/ros_buildfarm_config/index.yaml
