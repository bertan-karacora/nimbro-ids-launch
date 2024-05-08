#!/usr/bin/env bash

set -euo pipefail

readonly session_name="ids"

start_tmux() {
    tmux new-session -s "$session_name" /repos/nimbro-ids-launch/scripts/start_ids_camera.sh
}

main() {
    start_tmux
}

main "$@"
