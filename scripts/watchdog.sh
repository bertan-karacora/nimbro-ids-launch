#!/usr/bin/env bash

set -euo pipefail

topics=("/camera_ids/ir/image_raw")
loop_duration=10
timeout_duration=5
cmd="/repos/nimbro_orbbec_launch/scripts/start_tmux.sh"

check_topics() {
    for topic in "${TOPICS[@]}"; do
        if ! timeout --preserve-status $timeout_duration ros2 topic echo --once "$topic" >/dev/null; then
            echo "$topic is silent."
            return 1
        else
            echo "$topic has data."
        fi
    done

    return 0
}

main() {
    while :; do
        if ! check_topics; then
            echo "At least one topic is silent for more than $timeout_duration seconds."

            tmux kill-session -t ids 2>/dev/null
            if [ $? -ne 0 ]; then
                echo "Tmux session named ids does not exist or could not be killed. Continuing..."
            else
                echo "Tmux session named ids killed."
            fi

            # Running another script
            exec "./$LAUNCH_SCRIPT"

            # Wait a bit before restarting the loop
            sleep 10
        fi
    done
}

main "$@"
