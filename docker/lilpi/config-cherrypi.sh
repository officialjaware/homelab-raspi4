#!/bin/bash

set -e

WLAN=wlan0
WLAN_STATIC_IP=10.0.1.2
WLAN_STATIC_ROUTERS=10.0.1.1

ETH=eth0
ETH_STATIC_IP=10.0.1.9
ETH_STATIC_ROUTERS=10.0.1.1

DNS1=10.0.1.2
DNS2=1.1.1.1
DNS3=

# Uninstall BlueZ and related packages
sudo apt-get purge bluez -y
sudo apt-get autoremove -y

# docker
dependencies=(
    libffi-dev
    libssl-dev
    python3-dev
    python3
    python3-pip
    git
)

for i in ${dependencies[@]}; do
    sudo apt install -y $i
done

sudo apt-get update

curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker pi
sudo pip3 install docker-compose
sudo systemctl enable docker

# log2ram
git clone https://github.com/azlux/log2ram.git
pushd log2ram/
chmod +x install.sh
sudo ./install.sh
sudo sed -i -e "s/^SIZE=40M/SIZE=128M/g" /etc/log2ram.conf
popd

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

printf "\nnet.ipv6.conf.all.disable_ipv6 = 1\n" | sudo tee -a /etc/sysctl.conf

sudo systemctl daemon-reload

sudo apt-get update && sudo apt-get upgrade -y && sudo apt-get autoremove && sudo apt-get autoclean

sudo reboot now