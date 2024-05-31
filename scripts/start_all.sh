#!/usr/bin/env bash

set -eo pipefail

source /etc/profile.d/idsGigETL_64bit.sh
source /opt/ros/humble/setup.bash
source /colcon_ws/install/setup.bash

set -u

source /repos/nimbro-ids-launch/libs/nimbro_config/source_configs.sh

readonly path_repo="$(dirname "$(dirname "$(realpath "$BASH_SOURCE")")")"
source "$path_repo/config.sh"

main() {
    "$path_repo/scripts/start_watchdog_tmux.sh"
    "$path_repo/scripts/setup_dds.sh"
    "$path_repo/scripts/start_camera_tmux.sh"

    # Stay alive
    exec "$@"
}

main "$@"
