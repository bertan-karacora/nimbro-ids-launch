#!/usr/bin/env bash

set -euo pipefail

export RMW_IMPLEMENTATION="rmw_cyclonedds_cpp"
export CYCLONEDDS_URI="$HOME/.ros/cyclonedds.xml"

readonly session_name="ids"

setup_dds() {
    echo -e "RMW_IMPLEMENTATION=$RMW_IMPLEMENTATION\tCYCLONEDDS_URI=$CYCLONEDDS_URI"
    cat "/cyclonedds.xml.template" | envsubst >$CYCLONEDDS_URI
}

start_tmux() {
    tmux new-session -s "$session_name" /repos/nimbro-ids-launch/scripts/start_ids_camera.sh
}

main() {
    setup_dds
    start_tmux
}

main "$@"
