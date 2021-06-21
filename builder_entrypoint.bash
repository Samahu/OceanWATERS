#!/bin/bash
set -e

if [ "$(id -u)" = "0" ]; then
  # get gid of docker socket file
  SOCK_DOCKER_GID=`ls -ng /var/run/docker.sock | cut -f3 -d' '`

  # get group of docker inside container
  CUR_DOCKER_GID=`getent group docker | cut -f3 -d: || true`

  # if they don't match, adjust
  if [ ! -z "$SOCK_DOCKER_GID" -a "$SOCK_DOCKER_GID" != "$CUR_DOCKER_GID" ]; then
    groupmod -g ${SOCK_DOCKER_GID} -o docker
  fi
  if ! groups ow_user | grep -q docker; then
    usermod -aG docker ow_user
  fi
  # Add call to gosu to drop from root user to ow_user user
  # when running original entrypoint
  set -- gosu jenkins "$@"
fi

# setup ros environment
source /ow_env/setup.bash

exec "$@"