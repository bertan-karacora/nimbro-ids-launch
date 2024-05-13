#!/usr/bin/env bash

set -euo pipefail

readonly path_script="$(dirname "$(realpath -s "$0")")"
source "$path_script/config.sh"

readonly name_image="ids"
clean=""

show_help() {
    echo "Usage:"
    echo "  ./build.sh [--clean]"
    echo
    echo "Build the Docker image."
    echo
}

parse_args() {
    local arg=""
    while [[ $# -gt 0 ]]; do
        arg="$1"
        shift
        case $arg in
        -h | --help)
            show_help
            exit 0
            ;;
        --clean)
            clean=0
            ;;
        *)
            echo "Unknown option $1"
            exit 1
            ;;
        esac
    done
}

build() {
    docker build \
        --build-arg CONTAINER_ROS_DOMAIN_ID="$CONTAINER_ROS_DOMAIN_ID" \
        --build-arg CONTAINER_BRIDGE_INTERFACE="$CONTAINER_BRIDGE_INTERFACE" \
        --build-arg USERNAME_GITLAB="$USERNAME_GITLAB" \
        --build-arg TOKEN_GITLAB="$TOKEN_GITLAB" \
        ${clean:+--no-cache} \
        --tag "$name_image" \
        --file "$path_script/Dockerfile" \
        "$path_script"
}

main() {
    parse_args "$@"
    build
}

main "$@"
