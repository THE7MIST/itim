#!/bin/bash

echo "=== Installing SSH + Python ==="
sudo apt update -y
sudo apt install openssh-server python3 -y

echo "=== Starting SSH service ==="
sudo systemctl start ssh
sudo systemctl enable ssh

echo "=== Allowing SSH in firewall ==="
sudo ufw allow ssh

echo "=== Client ready for Ansible ==="