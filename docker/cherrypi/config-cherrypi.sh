#!/bin/bash

set -e

WLAN=wlan0
WLAN_STATIC_IP=10.0.1.2
WLAN_STATIC_ROUTERS=10.0.1.1

ETH=eth0
ETH_STATIC_IP=10.0.1.9
ETH_STATIC_ROUTERS=10.0.1.1

DNS1=10.0.1.2
DNS2=10.0.1.9
DNS3=


# Set a static IP for wlan0
sudo tee -a /etc/dhcpcd.conf <<EOF

interface $WLAN
static ip_address=$WLAN_STATIC_IP
static routers=$WLAN_STATIC_ROUTERS
static domain_name_servers=$DNS1 $DNS2
EOF

# Set a static IP for eth0
sudo tee -a /etc/dhcpcd.conf <<EOF

interface $ETH
static ip_address=$ETH_STATIC_IP
static routers=$ETH_STATIC_ROUTERS
static domain_name_servers=$DNS1 $DNS2
EOF

sudo systemctl daemon-reload