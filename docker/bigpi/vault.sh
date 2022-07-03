#!/bin/bash

curl https://releases.hashicorp.com/vault/1.10.4/vault_1.10.4_linux_arm.zip -o vault.zip

sudo unzip vault.zip -d /usr/local/bin/

mkdir -p /etc/vault.d/file

cp -a /vault/. /etc/vault.d/

docker-compose up -d