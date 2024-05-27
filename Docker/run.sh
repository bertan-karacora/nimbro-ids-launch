#!/usr/bin/env bash

set -euo pipefail

readonly path_script="$(dirname "$(realpath -s "$BASH_SOURCE")")"
source "$path_script/config.sh"

readonly name_image="ids"

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
        --rm \
        --volume "$path_repo:/repos/$name_repo" \
        --volume /etc/localtime:/etc/localtime:ro \
        --volume /etc/timezone:/etc/timezone:ro \
        --device="/dev/bus/usb/$bus_usb" \
        --device="/dev/dri/card0" \
        "$name_image"
}

main() {
    parse_args "$@"
    run_docker
}

main "$@"
