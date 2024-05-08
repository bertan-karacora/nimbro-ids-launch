#!/usr/bin/env bash

set -euo pipefail

readonly session_name="ids"
readonly topics=("/camera_ids")
readonly duration_loop=10
readonly duration_timeout=5

is_active() {
    local topic = "$1"
    local duration_timeout = "$2"

    timeout \
        --preserve-status "$duration_timeout" \
        ros2 topic echo --once "$topic" >/dev/null

    return $?
}

are_active() {
    for topic in "${topics[@]}"; do
        if is_active "$topic" "$duration_timeout"; then
            echo "$topic is active."
        else
            echo "$topic is silent."
            return 1
        fi
    done

    return 0
}

run_watchdog() {
    if ! are_active; then
        echo "At least one topic is silent for more than $duration_timeout seconds."

        tmux kill-session -t "$session_name" 2>/dev/null
        if [ $? -ne 0 ]; then
            echo "Tmux session named "$session_name" does not exist or could not be killed. Continuing..."
        else
            echo "Tmux session named "$session_name" killed."
        fi

        /repos/nimbro_orbbec_launch/scripts/start_tmux.sh

        sleep "$duration_loop"
    fi
}

main() {
    while true; do
        run_watchdog
    done
}

main "$@"
