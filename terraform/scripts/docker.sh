#!/bin/bash

sudo apt-get update
sudo apt install wget curl git -y
curl -fsSL https://get.docker.com -o install.sh 
sudo sh install.sh
sudo systemctl start docker
sudo usermod -aG docker $USER
sudo systemctl restart docker