#!/usr/bin/env bash

set -euo pipefail

readonly name_image="ids"
# TODO: This is hard-coded. Add paths to nimbro_config and source it here?
readonly path_nimbro_config_dir="$HOME/Repos/nimbro_config"
found_overlay_nimbro_config=""
readonly path_nimbro_utils_dir="$HOME/nimbro_ros2_ws/src/nimbro_utils"
found_overlay_nimbro_utils=""

show_help() {
    echo "Usage:"
    echo "  ./run.sh"
    echo
    echo "Run Docker container."
    echo
}

parse_args() {
    if [ "$#" -ne 0 ]; then
        show_help
        exit 1
    fi
}

get_usb_bus() {
    local bus_usb="$(lsusb | grep 'IDS' | awk '{print $2}')"

    echo "$bus_usb"
}

check_configs() {
    if [ -d "$path_nimbro_config_dir" ]; then
        found_overlay_nimbro_config=0
    fi
    if [ -d "$path_nimbro_utils_dir" ]; then
        found_overlay_nimbro_utils=0
    fi
}

run_docker() {
    local path_repo="$(dirname "$path_script")"
    local name_repo="$(basename "$path_repo")"
    local bus_usb="$(get_usb_bus)"

    docker run \
        --name "$name_image" \
        --shm-size 12G \
        --env SHELL \
        --interactive \
        --tty \
        --net=host \
        --restart=unless-stopped \
        --device="/dev/bus/usb/$bus_usb" \
        --device="/dev/dri/card0" \
        --volume "$path_repo:/repos/$name_repo" \
        --volume /etc/localtime:/etc/localtime:ro \
        --volume /etc/timezone:/etc/timezone:ro \
        ${found_overlay_nimbro_config:+--volume "$path_nimbro_config_dir:/repos/nimbro-ids-launch/libs/nimbro_config"} \
        ${found_overlay_nimbro_utils:+--volume "$path_nimbro_utils_dir:/colcon_ws/src/nimbro_utils"} \
        "$name_image"
}

main() {
    parse_args "$@"
    check_configs
    run_docker
}

main "$@"
