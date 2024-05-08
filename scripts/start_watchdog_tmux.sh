#!/usr/bin/env bash

set -euo pipefail

readonly session_name="watchdog"

start_tmux() {
    tmux new-session -s "$session_name" /repos/nimbro-ids-launch/scripts/watchdog.sh
}

main() {
    start_tmux
}

main "$@"
