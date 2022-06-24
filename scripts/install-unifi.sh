#!/bin/bash

set -e

dependencies=(
    openjdk-8-jre-headless
    rng-tools  
)

for i in ${dependencies[@]}; do
    sudo apt install -y $i
done

sudo sed -i -e "s/#HRNGDEVICE=\/dev\/hwrng/HRNGDEVICE=\/dev\/hwrng/g" /etc/default/rng-tools-debian

sudo systemctl restart rng-tools

sudo tee -a /etc/apt/preferences.d/99stretch-mongodb.pref > /dev/null <<EOT
#Never Prefer packages from Stretch
Package: *
Pin: release n=stretch
Pin-Priority: 1
EOT

echo "deb http://archive.raspbian.org/raspbian stretch main" | sudo tee /etc/apt/sources.list.d/stretch_mongodb.list

sudo apt update

echo 'deb [signed-by=/usr/share/keyrings/ubiquiti-archive-keyring.gpg] https://www.ui.com/downloads/unifi/debian stable ubiquiti' | sudo tee /etc/apt/sources.list.d/100-ubnt-unifi.list

curl https://dl.ui.com/unifi/unifi-repo.gpg | sudo tee /usr/share/keyrings/ubiquiti-archive-keyring.gpg >/dev/null

sudo apt update

sudo apt install -y unifi

