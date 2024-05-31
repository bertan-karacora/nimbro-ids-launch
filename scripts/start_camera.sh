#!/usr/bin/env bash

set -euo pipefail

source /repos/nimbro-ids-launch/nimbro_config/source_configs.sh

start_camera() {
    ros2 run nimbro_camera_ids spin
}

main() {
    start_camera
}

main "$@"
