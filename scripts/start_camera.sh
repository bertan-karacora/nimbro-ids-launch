#!/usr/bin/env bash

set -euo pipefail

source /repos/nimbro-ids-launch/config.sh

start_camera() {
    # ros2 run nimbro_camera_ids spin
    bash
}

main() {
    start_camera
}

main "$@"
