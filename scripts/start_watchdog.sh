#!/usr/bin/env bash

set -euo pipefail

# TODO: Could this be done without hard-coding here? Add it to the config and use when launching node?
readonly session_name="ids"
readonly topics=("/camera_ids/image_color" "/camera_ids/camera_info")
readonly duration_loop=10
readonly duration_timeout=5

try_topic() {
    local topic="$1"

    timeout \
        --preserve-status "$duration_timeout" \
        ros2 topic echo --once "$topic" >/dev/null
}

are_active() {
    for topic in "${topics[@]}"; do
        if try_topic "$topic"; then
            echo "$topic is active."
        else
            echo "$topic is silent."
            return 1
        fi
    done

    return 0
}

kill_session() {
    tmux kill-session -t "$session_name"
}

run_watchdog() {
    if ! are_active; then
        echo "At least one topic is silent for more than $duration_timeout seconds."

        if kill_session; then
            echo "Tmux session named "$session_name" killed."
        else
            echo "Tmux session named "$session_name" does not exist or could not be killed. Continuing..."
        fi

        /repos/nimbro-ids-launch/scripts/start_camera_tmux.sh

        sleep "$duration_loop"
    fi
}

main() {
    while true; do
        run_watchdog
    done
}

main "$@"
