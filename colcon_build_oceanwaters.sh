#!/bin/bash

# this script assumes that we have already checked out all required repositories into src folder
source /opt/ros/noetic/setup.bash

# source plexil again
export PLEXIL_HOME=/plexil
source $PLEXIL_HOME/scripts/plexil-setup.sh

colcon build