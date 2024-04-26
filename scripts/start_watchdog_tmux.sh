#!/usr/bin/env bash

set -euo pipefail

session_name="watchdog"

# Assuming you might need similar environment variables or setup
export RMW_IMPLEMENTATION="rmw_cyclonedds_cpp"
export CYCLONEDDS_URI="$HOME/.ros/cyclonedds.xml"

echo -e "RMW_IMPLEMENTATION=$RMW_IMPLEMENTATION\tCYCLONEDDS_URI=$CYCLONEDDS_URI"
mkdir -p $HOME/.ros

# Copy the Cyclone DDS config if necessary
cat "/cyclonedds.xml.template" | envsubst >$CYCLONEDDS_URI

# Setup a custom bashrc for the session
BASH_RC=/tmp/.bashrc_watchdog
cp ~/.bashrc $BASH_RC
echo "export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp" >>$BASH_RC
echo "export CYCLONEDDS_URI=$HOME/.ros/cyclonedds.xml" >>$BASH_RC
# Add any other environment variables or ROS setup if necessary for watchdog
echo "source /opt/ros/humble/setup.bash" >>$BASH_RC

# Create or attach to an existing tmux session named $session_name
tmux has-session -t $session_name 2>/dev/null
if [ $? != 0 ]; then
  tmux new-session -d -s $session_name "tmux set-option default-command \"bash --rcfile $BASH_RC\"; bash --rcfile $BASH_RC"
fi

# Start the watchdog script in the tmux session
# Replace '/path/to/watchdog.sh' with the actual path to your watchdog script
tmux send-keys -t $session_name:0 "bash /repos/nimbro_orbbec_launch/scripts/watchdog.sh" Enter

# Attach to the tmux session unless the script is called with '-d' (detach)
if [[ "$1" != "-d" ]]; then
  tmux -2 attach-session -t $session_name
fi
