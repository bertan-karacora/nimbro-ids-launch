#!/usr/bin/env bash

set -a

PATH_REPO_CONFIG_DIR="$HOME/Repos/nimbro_config"
PATH_REPO_UTILS_DIR="$HOME/nimbro_ros2_ws/src/nimbro_utils"

RMW_IMPLEMENTATION=rmw_cyclonedds_cpp
CYCLONEDDS_URI="$HOME/.ros/cyclonedds.xml"

unset hostname
set +a
