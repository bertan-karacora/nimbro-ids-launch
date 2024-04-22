#!/usr/bin/env bash

set -a

hostname=$(hostname)

if [[ "$hostname" == "nimbro-athome" ]]; then
    CONTAINER_ROS_DOMAIN_ID=42
    CONTAINER_BRIDGE_INTERFACE=enp176s0
    PORT_USB="004"
    MEMORY_USB_BUFFER=1000
elif [[ "$hostname" == "nimbro-athome2" ]]; then
    CONTAINER_ROS_DOMAIN_ID=42
    CONTAINER_BRIDGE_INTERFACE=enp176s0
    PORT_USB="004"
    MEMORY_USB_BUFFER=1000
else
    CONTAINER_ROS_DOMAIN_ID=42
    CONTAINER_BRIDGE_INTERFACE=enp176s0
    PORT_USB="004"
    MEMORY_USB_BUFFER=1000
fi

unset hostname
set +a
