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
    CONTAINER_ROS_DOMAIN_ID=42
    CONTAINER_BRIDGE_INTERFACE=enp176s0
    IDS_USERNAME=testuser
    IDS_PASSWORD=testpw
    PORT_USB="004"
    MEMORY_USB_BUFFER=1000
fi

unset hostname
set +a
