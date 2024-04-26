#!/usr/bin/env bash

set -euo pipefail

readonly session_name="ids"
readonly path_rcfile="/tmp/.bashrc_ids"

start_tmux() {
    tmux -2 new-session -s $session_name /repos/nimbro-ids-launch/scripts/start_camera.sh
}

main() {
    start_tmux
}

main "$@"

# append2file() {
#     local path="$1"
#     local string="$2"

#     cat >>"$path" <<EOF
# $string
# EOF
# }

# setup_rcfile() {
#     local string_bashrc="
# export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp
# export CYCLONEDDS_URI=$HOME/.ros/cyclonedds.xml
# export ROS_DOMAIN_ID=$ROS_DOMAIN_ID
# source /opt/ros/humble/setup.bash
# source /colcon_ws/install/local_setup.bash"

#     cp ~/.bashrc $path_rcfile
#     append2file "$path_rcfile" "$string_bashrc"
# }

# export RMW_IMPLEMENTATION="rmw_cyclonedds_cpp"
# export CYCLONEDDS_URI="$HOME/.ros/cyclonedds.xml"

# echo -e "RMW_IMPLEMENTATION=$RMW_IMPLEMENTATION\tCYCLONEDDS_URI=$CYCLONEDDS_URI"
# mkdir -p "$HOME/.ros"

# cat "/cyclonedds.xml.template" | envsubst >$CYCLONEDDS_URI
