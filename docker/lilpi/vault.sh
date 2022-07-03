#!/bin/bash

set -e

curl -sS https://releases.hashicorp.com/vault/1.10.4/vault_1.10.4_linux_arm.zip -o vault.zip

sudo unzip vault.zip -d /usr/local/bin/

sudo mkdir -p /etc/vault.d/file

sudo cp -a ./vault/. /etc/vault.d/

docker-compose up -d