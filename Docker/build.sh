#!/usr/bin/env bash

set -euo pipefail

# See https://stackoverflow.com/questions/59895/how-do-i-get-the-directory-where-a-bash-script-is-located-from-within-the-script
readonly path_script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
source "$path_script_configs/nimbro_config/source_configs.sh"

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
