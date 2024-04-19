#!/usr/bin/env bash

set -a

hostname=$(hostname)

if [[ "$hostname" == "nimbro-athome" ]]; then
    CONTAINER_ROS_DOMAIN_ID=42
    CONTAINER_BRIDGE_INTERFACE=enp176s0
elif [[ "$hostname" == "nimbro-athome2" ]]; then
    CONTAINER_ROS_DOMAIN_ID=42
    CONTAINER_BRIDGE_INTERFACE=enp176s0
else
    IDS_USERNAME=testuser
    IDS_PASSWORD=testpw
    CONTAINER_ROS_DOMAIN_ID=42
    CONTAINER_BRIDGE_INTERFACE=enp176s0
fi

unset hostname
