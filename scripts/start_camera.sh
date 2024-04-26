#!/usr/bin/env bash

set -eo pipefail

source /opt/ros/humble/setup.bash
source /ros2_ws/install/setup.bash

set -u

main() {
    ros2 run camera_ids publish
}

main "$@"
