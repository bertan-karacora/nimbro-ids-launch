#!/usr/bin/env bash

set -euo pipefail

readonly path_repo="$(dirname "$(dirname "$BASH_SOURCE")")"
source "$path_repo/libs/nimbro_config/source_configs.sh"

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
        --build-arg USERNAME_GITLAB="$NIMBROATHOMEDEPLOYUSER" \
        --build-arg TOKEN_GITLAB="$NIMBROATHOMEDEPLOYTOKEN" \
        --tag "$name_image" \
        --file "$path_script/Dockerfile" \
        ${clean:+--no-cache} \
        "$path_script"
}

main() {
    parse_args "$@"
    build
}

main "$@"
