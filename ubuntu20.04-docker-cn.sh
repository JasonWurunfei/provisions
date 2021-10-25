#!/bin/bash
echo "Provisioning virtual machine..."

echo "[1/7] Change apt source list..."
sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak

sudo cat > /etc/apt/sources.list << EOF
# 默认注释了源码镜像以提高 apt update 速度，如有需要可自行取消注释
deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal main restricted universe multiverse
# deb-src http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal main restricted universe multiverse
deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-updates main restricted universe multiverse
# deb-src http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-updates main restricted universe multiverse
deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-backports main restricted universe multiverse
# deb-src http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-backports main restricted universe multiverse
deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-security main restricted universe multiverse
# deb-src http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-security main restricted universe multiverse

# 预发布软件源，不建议启用
# deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-proposed main restricted universe multiverse
# deb-src http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-proposed main restricted universe multiverse
EOF

sudo apt-get update

echo "[2/7] Uninstall old versions"
sudo apt-get remove docker docker-engine docker.io containerd runc

set -e

echo "[3/7] Install tools"
sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release -y

echo "[4/7] Add Docker’s official GPG key"
curl -fsSL http://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor --yes -o /usr/share/keyrings/docker-archive-keyring.gpg

echo "[5/7] set up the stable repository"
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] http://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "[6/7] Install Docker Engine"
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io -y

echo "[7/7] Change docker hub image source"
sudo mkdir -p /etc/docker
sudo cat > /etc/docker/daemon.json << EOF
{
  "registry-mirrors": ["http://docker.mirrors.ustc.edu.cn"]
}
EOF
sudo systemctl daemon-reload
sudo systemctl restart docker

echo "Installation complete!"
docker -v
