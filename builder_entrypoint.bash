#!/bin/bash
set -e

USER_ID=${HOST_USER_ID:-9001}
useradd --shell /bin/bash -u $USER_ID -o -c "" -m ow_user
export HOME=/home/ow_user

# setup ros environment
source /ow_env/setup.bash

exec /usr/local/bin/gosu ow_user "$@"