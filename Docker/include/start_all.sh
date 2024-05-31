#!/usr/bin/env bash

set -eo pipefail

source /etc/profile.d/idsGigETL_64bit.sh
source /opt/ros/humble/setup.bash
source /colcon_ws/install/setup.bash

set -u

source /repos/nimbro-ids-launch/libs/nimbro_config/source_configs.sh

main() {
    /repos/nimbro-ids-launch/scripts/setup_dds.sh
    /repos/nimbro-ids-launch/scripts/start_watchdog_tmux.sh
    /repos/nimbro-ids-launch/scripts/start_camera_tmux.sh

    # Stay alive
    exec "$@"
}

main "$@"
