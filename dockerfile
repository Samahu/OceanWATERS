ARG BASE_DOCKER_IMAGE=ubuntu:18.04

FROM $BASE_DOCKER_IMAGE AS oceanwaters_builder

ARG ROS_DISTRO=melodic
ARG ROS_DISTRO_POSTFIX=desktop-full
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
    ros-${ROS_DISTRO}-${ROS_DISTRO_POSTFIX} \
    ros-${ROS_DISTRO}-tf2-ros \
    ros-${ROS_DISTRO}-robot-state-publisher \
    ros-${ROS_DISTRO}-joint-state-publisher \
    ros-${ROS_DISTRO}-joint-state-controller \
    ros-${ROS_DISTRO}-effort-controllers \
    ros-${ROS_DISTRO}-joint-trajectory-controller \
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
    default-jre \
    ant \
    gperf

# install the right build tool depending on ros distribution
RUN if [ "$ROS_DISTRO" = "melodic" ] ; then \
        apt-get install -y python-catkin-tools ; \
    else \
        apt-get install -y python3-catkin-tools python3-pip ; \
        pip3 install osrf-pycommon ; \
    fi \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir /ow_env
COPY *.bash /ow_env
RUN /ow_env/build_plexil.bash
RUN /ow_env/build_gsap.bash

RUN echo -e "\
#!/bin/bash \n \
source /opt/ros/$ROS_DISTRO/setup.bash \n \
source /usr/share/gazebo/setup.sh \n \
echo 'ROS($ROS_DISTRO) sourced \n \
export PLEXIL_HOME=/plexil \n \
source /plexil/scripts/plexil-setup.sh \n \
echo 'PLEXIL sourced' \n \
export GSAP_HOME=/gsap \n" > /ow_env/setup.bash

ENTRYPOINT [ "/bin/bash", "/ow_env/setup.bash" ]

FROM oceanwaters_builder AS oceanwaters_docker
RUN mkdir /OceanWATERS
WORKDIR /OceanWATERS
COPY src /OceanWATERS/src/
RUN /ow_env/build_oceanwaters.bash

RUN echo -e "\
#!/bin/bash \n \
source /ow_env/setup.bash \n \
source /OceanWATERS/devel/setup.bash \n \
echo 'OceanWATERS sourced'" > startup.bash

ENTRYPOINT [ "/bin/bash", "/OceanWATERS/entrypoint.bash" ]
CMD [ "roslaunch", "ow", "atacama_y1a.launch" ]
