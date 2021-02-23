#!/bin/bash
set -e

# setup ros/oceanwaters environment
source /OceanWATERS/startup.bash

exec "$@"