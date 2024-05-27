#!/usr/bin/env bash

set -a

RMW_IMPLEMENTATION=rmw_cyclonedds_cpp
CYCLONEDDS_URI=~/.ros/cyclonedds.xml

hostname=$(hostname)
if [[ "$hostname" == "nimbro-athome" ]]; then
    INTERFACE_BRIDGE=eno1
    ROS_DOMAIN_ID=42
elif [[ "$hostname" == "nimbro-athome2" ]]; then
    INTERFACE_BRIDGE=eno1
    ROS_DOMAIN_ID=42
else
    INTERFACE_BRIDGE=eno1
    ROS_DOMAIN_ID=42
fi

unset hostname
set +a
