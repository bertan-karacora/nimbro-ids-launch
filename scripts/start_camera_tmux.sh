#!/usr/bin/env bash

set -euo pipefail

readonly path_repo="$(dirname "$(dirname "$BASH_SOURCE")")"
source "$path_repo/libs/nimbro_config/source_configs.sh"

readonly session_name="ids"

start_tmux() {
    tmux new-session -d -s "$session_name" /repos/nimbro-ids-launch/scripts/start_camera.sh
}

main() {
    start_tmux
}

main "$@"
