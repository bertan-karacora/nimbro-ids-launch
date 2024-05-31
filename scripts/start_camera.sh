#!/usr/bin/env bash

set -euo pipefail

readonly path_repo="$(dirname "$(dirname "$BASH_SOURCE")")"
source "$path_repo/libs/nimbro_config/source_configs.sh"

start_camera() {
    ros2 run nimbro_camera_ids spin
}

main() {
    start_camera
}

main "$@"
