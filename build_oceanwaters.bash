#!/bin/bash

# this script assumes that we have already checked out all required repositories into src folder
source /OceanWATERS/setup_ros.bash

# source plexil again
export PLEXIL_HOME=/plexil
source $PLEXIL_HOME/scripts/plexil-setup.sh

catkin init
catkin build --cmake-args -Wno-dev