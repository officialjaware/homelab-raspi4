#!/bin/bash

set -e 

#hostname=
TIMEZONE="America/New_York"

#sudo rm -f /etc/localtime
#sudo echo "$TIMEZONE" > /etc/timezone
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
sudo systemctl enable ssh

# Change hostname
#hostnamectl set-hostname $hostname

# Disable wait for network at boot
sudo rm /etc/systemd/system/dhcpcd.service.d/wait.conf

# Disable wifi
#printf "\ndtoverlay=pi3-disable-wifi\n" | sudo tee -a /boot/config.txt

# Disable IPv6
printf "\nnet.ipv6.conf.all.disable_ipv6 = 1\n" | sudo tee -a /etc/sysctl.conf

# Create VLANs
#ip link add link eth0 name eth1 address xx:xx:xx:xx:xx:xx type macvlan
#ip link add link eth0 name eth2 address yy:yy:yy:yy:yy:yy type macvlan

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

curl https://releases.hashicorp.com/vault/1.10.4/vault_1.10.4_linux_arm.zip -o vault.zip

sudo unzip vault.zip -d /usr/local/bin/

sudo apt-get update && sudo apt-get upgrade -y && sudo apt-get autoremove && sudo apt-get autoclean

sudo reboot now