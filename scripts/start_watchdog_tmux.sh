#!/usr/bin/env bash

set -euo pipefail

readonly path_repo="$(dirname "$(dirname "$(realpath "$BASH_SOURCE")")")"
source "$path_repo/libs/nimbro_config/source_configs.sh"

readonly name_session="watchdog_ids"

start_tmux() {
    tmux new-session -d -s "$name_session" /repos/nimbro-ids-launch/scripts/start_watchdog.sh
}

main() {
    start_tmux
}

main "$@"
