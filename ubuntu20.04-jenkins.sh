#!/bin/bash
echo "Installing openjdk-11..."

sudo apt update
sudo apt install openjdk-11-jdk -y

echo "Installing Jenkins Long Term Support release"
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > \
    /etc/apt/sources.list.d/jenkins.list'
sudo apt-get update
sudo apt-get install jenkins -y
