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

run_docker() {
    local path_repo="$(dirname "$path_script")"
    local name_repo="$(basename "$path_repo")"

    docker run \
        --name "$name_image" \
        --shm-size 12G \
        --env SHELL \
        --interactive \
        --tty \
        --net=host \
        --restart=unless-stopped \
        --volume "$path_repo:/repos/$name_repo" \
        --volume /etc/localtime:/etc/localtime:ro \
        --volume /etc/timezone:/etc/timezone:ro \
        --device="/dev/bus/usb/$BUS_USB" \
        --device="/dev/dri/card0" \
        "$name_image"
}

setup_usb_buffer() {
    sudo scripts/set_usb_buffer_memory.sh 1000
}

main() {
    parse_args "$@"
    setup_usb_buffer
    run_docker
}

main "$@"
