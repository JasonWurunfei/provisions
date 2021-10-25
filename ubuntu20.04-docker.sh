#!/bin/bash
echo "Provisioning virtual machine..."

echo "[1/6] apt-get update..."
sudo apt-get update

echo "[2/6] Uninstall old versions"
sudo apt-get remove docker docker-engine docker.io containerd runc

set -e

echo "[3/6] Install tools"
sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release -y

echo "[4/6] Add Docker’s official GPG key"
curl -fsSL http://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor --yes -o /usr/share/keyrings/docker-archive-keyring.gpg

echo "[5/6] set up the stable repository"
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] http://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "[6/6] Install Docker Engine"
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io -y

echo "Installation complete!"
docker -v
