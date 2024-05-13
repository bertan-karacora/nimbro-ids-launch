#!/usr/bin/env bash

set -a

hostname=$(hostname)

USERNAME_GITLAB=athome
TOKEN_GITLAB=bckY_h7nq4djzxXyAGSG

if [[ "$hostname" == "nimbro-athome" ]]; then
    CONTAINER_ROS_DOMAIN_ID=42
    CONTAINER_BRIDGE_INTERFACE=enp176s0
    BUS_USB="004"
elif [[ "$hostname" == "nimbro-athome2" ]]; then
    CONTAINER_ROS_DOMAIN_ID=42
    CONTAINER_BRIDGE_INTERFACE=enp176s0
    BUS_USB="004"
else
    CONTAINER_ROS_DOMAIN_ID=42
    CONTAINER_BRIDGE_INTERFACE=enp176s0
    BUS_USB="004"
fi

unset hostname
set +a
