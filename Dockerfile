ARG BASE_DOCKER_IMAGE=ubuntu:18.04

FROM $BASE_DOCKER_IMAGE AS oceanwaters_builder

ARG ROS_DISTRO=melodic
ARG DEBIAN_FRONTEND=noninteractive
SHELL ["/bin/bash", "-c"]

RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository ppa:git-core/ppa -y && \
    apt-get install -y git gnupg2 wget

RUN echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list && \
    apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

RUN echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable $(lsb_release -sc) main" > /etc/apt/sources.list.d/gazebo-stable.list && \
    wget https://packages.osrfoundation.org/gazebo.key -O - | apt-key add -

RUN apt-get update && apt-get install -y \
    ros-${ROS_DISTRO}-desktop-full \
    ros-${ROS_DISTRO}-tf2-ros \
    ros-${ROS_DISTRO}-robot-state-publisher \
    ros-${ROS_DISTRO}-joint-state-publisher \
    ros-${ROS_DISTRO}-joint-state-controller \
    ros-${ROS_DISTRO}-effort-controllers \
    ros-${ROS_DISTRO}-dynamic-reconfigure \
    ros-${ROS_DISTRO}-nodelet \
    ros-${ROS_DISTRO}-nodelet-topic-tools \
    ros-${ROS_DISTRO}-camera-info-manager \
    ros-${ROS_DISTRO}-tf2-geometry-msgs \
    ros-${ROS_DISTRO}-gazebo-ros-control \
    ros-${ROS_DISTRO}-xacro \
    ros-${ROS_DISTRO}-rviz-visual-tools \
    ros-${ROS_DISTRO}-rqt-plot \
    ros-${ROS_DISTRO}-rqt-rviz \
    ros-${ROS_DISTRO}-rqt-image-view \
    ros-${ROS_DISTRO}-rqt-common-plugins \
    ros-${ROS_DISTRO}-gazebo-plugins \
    ros-${ROS_DISTRO}-moveit \
    ros-${ROS_DISTRO}-moveit-ros-visualization \
    ros-${ROS_DISTRO}-geometry-msgs \
    ros-${ROS_DISTRO}-cmake-modules \
    ros-${ROS_DISTRO}-stereo-msgs \
    ros-${ROS_DISTRO}-stereo-image-proc \
    libgtk2.0-dev \
    libglew-dev \
    openjdk-8-jdk \
    ant \
    gperf

# install the right build tool depending on ros distribution
RUN if [ "$ROS_DISTRO" = "melodic" ] ; then \
        apt-get install -y python-catkin-tools ; \
    else \
        apt-get install -y python3-colcon-common-extensions ; \
    fi \
    && rm -rf /var/lib/apt/lists/*

FROM oceanwaters_builder AS oceanwaters_docker
COPY src /OceanWATERS/src/
WORKDIR /OceanWATERS
COPY *.sh .
RUN ./build_plexil.sh && \ 
    if [ "$ROS_DISTRO" = "melodic" ] ; then \
        ./catkin_build_oceanwaters.sh ; \
    else \
        ./colcon_build_oceanwaters.sh ; \
    fi

RUN echo "source /opt/ros/$ROS_DISTRO/setup.bash" >> $HOME/.bashrc && \
    echo "echo 'ROS($ROS_DISTRO) sourced'" >> $HOME/.bashrc && \
    echo "export PLEXIL_HOME=/plexil" >> $HOME/.bashrc && \
    echo "source $PLEXIL_HOME/scripts/plexil-setup.sh" >> $HOME/.bashrc && \
    echo "echo 'PLEXIL sourced'"

ENTRYPOINT [ "bash" ]
