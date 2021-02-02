#!/bin/bash

# this script assumes that we have already checked out all required repositories into src folder
source /OceanWATERS/setup_ros.bash

# source plexil again
export PLEXIL_HOME=$(pwd)/plexil
source $PLEXIL_HOME/scripts/plexil-setup.sh

echo "running tests"
catkin --catkin-make-args run_tests
echo "summary of tests"
catkin_test_results --all
echo "tests done"