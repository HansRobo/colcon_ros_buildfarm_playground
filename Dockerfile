FROM ros:humble-ros-base-jammy

SHELL ["/bin/bash", "-c"]

# install wget
RUN apt-get update && apt-get install -y wget

# download repos
RUN mkdir -p /root/ros2_ws/src

WORKDIR /root/ros2_ws

RUN wget https://raw.githubusercontent.com/HansRobo/colcon-ros-buildfarm/refs/heads/devel/crb.repos

RUN source /opt/ros/humble/setup.bash && \
    vcs import src < crb.repos && \
    colcon build

RUN source /root/ros2_ws/install/setup.bash && \
    ros_buildfarm release --continue-on-error --target-platform ubuntu:jammy
