#!/usr/bin/env bash

set -euo pipefail

readonly path_script="$(dirname "$(realpath -s "$0")")"
source "$path_script/config.sh"

readonly name_image="ids"

usage() {
    echo "Usage:"
    echo "  ./build.sh"
    echo
    echo "Build the Docker image."
    echo
}

parse_args() {
    if [ "$#" -ne 0 ]; then
        usage
        return 1
    fi
}

build() {
    docker build \
        --build-arg IDS_USERNAME=$IDS_USERNAME \
        --build-arg IDS_PASSWORD=$IDS_PASSWORD \
        --build-arg CONTAINER_ROS_DOMAIN_ID=$CONTAINER_ROS_DOMAIN_ID \
        --build-arg CONTAINER_BRIDGE_INTERFACE=$CONTAINER_BRIDGE_INTERFACE \
        --tag "$name_image" \
        --file "$path_script/Dockerfile" \
        "$path_script"
}

main() {
    parse_args "$@"
    build
}

main "$@"
