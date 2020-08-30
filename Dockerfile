FROM ubuntu:18.04

RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository ppa:git-core/ppa -y && \
    apt-get install -y git gnupg2 wget

RUN echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list && \
    apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

RUN echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable $(lsb_release -sc) main" > /etc/apt/sources.list.d/gazebo-stable.list && \
    wget https://packages.osrfoundation.org/gazebo.key -O - | apt-key add -

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y ros-melodic-desktop-full \
    python-catkin-tools \
    ros-melodic-tf2-ros \
    ros-melodic-robot-state-publisher \
    ros-melodic-joint-state-publisher \
    ros-melodic-joint-state-controller \
    ros-melodic-effort-controllers \
    ros-melodic-dynamic-reconfigure \
    ros-melodic-nodelet \
    ros-melodic-nodelet-topic-tools \
    ros-melodic-camera-info-manager \
    ros-melodic-tf2-geometry-msgs \
    ros-melodic-gazebo-ros-control \
    ros-melodic-xacro \
    ros-melodic-rviz-visual-tools \
    ros-melodic-rqt-plot \
    ros-melodic-rqt-rviz \
    ros-melodic-rqt-image-view \
    ros-melodic-rqt-common-plugins \
    ros-melodic-gazebo-plugins \
    ros-melodic-moveit \
    ros-melodic-moveit-ros-visualization \
    ros-melodic-geometry-msgs \
    ros-melodic-cmake-modules \
    ros-melodic-stereo-msgs \
    ros-melodic-stereo-image-proc \
    libgtk2.0-dev \
    libglew-dev \
    openjdk-8-jdk \
    ant \
    gperf \
    && rm -rf /var/lib/apt/lists/*