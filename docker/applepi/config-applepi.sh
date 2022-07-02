#!/bin/bash

set -e 

## Variables ##
#hostname=

# Set locale
#sudo rm -f /etc/localtime
#sudo echo "America/New York" > /etc/timezone
#sudo dpkg-reconfigure -f noninteractive tzdata
#sudo grep ^en_US\.UTF-8 /usr/share/i18n/SUPPORTED > /var/lib/locales/supported.d/local
#sudo cat >/etc/default/keyboard <<'KBEOF'
    #XKBMODEL="pc105"
    #XKBLAYOUT="us"
    #XKBVARIANT=""
    #XKBOPTIONS=""

    #KBEOF
#sudo dpkg-reconfigure locales
#sudo dpkg-reconfigure -f keyboard-configuration
#sudo sed -i '/ftp.uk.debian.org/s/uk/us/g' /etc/apt/sources.list

# Enable SSH
#sudo systemctl enable ssh

# Change hostname
#hostnamectl set-hostname $hostname

# Disable wait for network at boot
sudo rm /etc/systemd/system/dhcpcd.service.d/wait.conf

# Disable wifi
#printf "\ndtoverlay=pi3-disable-wifi\n" | sudo tee -a /boot/config.txt

# Disable IPv6
printf "\nnet.ipv6.conf.all.disable_ipv6 = 1\n" | sudo tee -a /etc/sysctl.conf

# Set a static IP for wlan0
sudo tee -a /etc/dhcpcd.conf <<EOF

interface wlan0
static ip_address=10.0.1.5
static routers=10.0.1.1
static domain_name_servers=10.0.1.2 1.1.1.1 10.0.1.7
EOF

# Set a static IP for eth0
sudo tee -a /etc/dhcpcd.conf <<EOF

interface eth0
static ip_address=10.0.1.7
static routers=10.0.1.1
static domain_name_servers=10.0.1.7 1.1.1.1 10.0.1.2
EOF

# Create VLANs
#ip link add link eth0 name eth1 address xx:xx:xx:xx:xx:xx type macvlan
#ip link add link eth0 name eth2 address yy:yy:yy:yy:yy:yy type macvlan

sudo systemctl restart dhcpcd.service
sudo systemctl restart networking

sleep 5

# Disable Bluetooth
#dtoverlay=pi3-disable-bt

sudo apt-get update

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

sudo apt-get update && sudo apt-get upgrade -y && sudo apt-get autoremove && sudo apt-get autoclean

sudo reboot now