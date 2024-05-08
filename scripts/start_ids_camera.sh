#!/usr/bin/env bash

set -eo pipefail

source /opt/ros/humble/setup.bash
source /ros2_ws/install/setup.bash

set -u

export GENICAM_GENTL64_PATH=/usr/lib/ids/cti

start_camera() {
    ros2 run camera_ids publish --config default
}

main() {
    start_camera
}

main "$@"
