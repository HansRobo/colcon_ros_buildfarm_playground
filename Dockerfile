FROM ros:rolling-ros-base-noble

# install wget
RUN apt-get update && apt-get install -y wget

# download repos
RUN mkdir -p /root/ros2_ws/src

WORKDIR /root/ros2_ws/src

RUN wget https://raw.githubusercontent.com/HansRobo/colcon-ros-buildfarm/refs/heads/devel/crb.repos

RUN source /opt/ros/rolling/setup.bash && \
    vcs import < crb.repos && \
    colcon build

RUN source /root/ros2_ws/install/setup.bash && \
    ros_buildfarm release
