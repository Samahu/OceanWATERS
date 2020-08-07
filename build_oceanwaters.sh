#!/bin/bash

# this script assumes that we have already checked out all required repositories into src folder
source /opt/ros/melodic/setup.bash
source $PLEXIL_HOME/scripts/plexil-setup.sh

catkin init
catkin build