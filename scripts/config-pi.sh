#!/bin/sh

set -e 

hostname=

# Set locale
#sudo grep ^en_US\.UTF-8 /usr/share/i18n/SUPPORTED > /var/lib/locales/supported.d/local
#sudo dpkg-reconfigure locales
#sudo dpkg-reconfigure keyboard-configuration
#sudo echo "America/New York" > /etc/timezone
#sudo dpkg-reconfigure -f noninteractive tzdata
#sudo sed -i '/ftp.uk.debian.org/s/uk/us/g' /etc/apt/sources.list


# Change hostname
hostnamectl set-hostname $hostname

# Disable wait for network at boot
sudo rm /etc/systemd/system/dhcpcd.service.d/wait.conf

# Disable wifi
printf "\ndtoverlay=pi3-disable-wifi\n" | sudo tee -a /boot/config.txt

# Disable IPv6
printf "\nnet.ipv6.conf.all.disable_ipv6 = 1\n" | sudo tee -a /etc/sysctl.conf

# Create VLANs
#ip link add link eth0 name eth1 address xx:xx:xx:xx:xx:xx type macvlan
#ip link add link eth0 name eth2 address yy:yy:yy:yy:yy:yy type macvlan

#sudo systemctl restart dhcpcd.service

# Disable Bluetooth
#dtoverlay=pi3-disable-bt

# Uninstall BlueZ and related packages
sudo apt-get purge bluez -y
sudo apt-get autoremove -y

sudo apt-get update && sudo apt-get upgrade -y && sudo apt-get autoremove && sudo apt-get autoclean

sudo reboot now