#!/usr/bin/env bash

set -eo pipefail

source /opt/ros/humble/setup.bash

set -u

main() {
    # /repos/nimbro_ids_launch/scripts/start_watchdog_tmux.sh -d
    # /repos/nimbro_ids_launch/scripts/start_tmux.sh

    exec "$@"
}

main "$@"
