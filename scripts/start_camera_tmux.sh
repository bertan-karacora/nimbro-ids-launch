#!/usr/bin/env bash

set -euo pipefail

source /repos/nimbro-ids-launch/nimbro_config/source_configs.sh

readonly session_name="ids"

start_tmux() {
    tmux new-session -d -s "$session_name" /repos/nimbro-ids-launch/scripts/start_camera.sh
}

main() {
    start_tmux
}

main "$@"
