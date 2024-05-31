#!/usr/bin/env bash

set -euo pipefail

source /repos/nimbro-ids-launch/nimbro_config/source_configs.sh

readonly name_session="watchdog_ids"

start_tmux() {
    tmux new-session -d -s "$name_session" /repos/nimbro-ids-launch/scripts/start_watchdog.sh
}

main() {
    start_tmux
}

main "$@"
