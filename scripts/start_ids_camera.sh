#!/usr/bin/env bash

set -eo pipefail

source /opt/ros/humble/setup.bash
source /colcon_ws/install/setup.bash

export GENICAM_GENTL64_PATH=/usr/lib/ids/cti

start_camera() {
    ros2 run nimbro_camera_ids spin
}

main() {
    start_camera
}

main "$@"
