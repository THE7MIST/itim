#!/bin/bash

echo "=== Installing Ansible ==="
sudo apt update -y
sudo apt install ansible -y

echo "=== Creating working directory ==="
mkdir -p ~/ansible_lab
cd ~/ansible_lab

echo "=== Creating test file ==="
echo "I am testing ansible" > testfile.txt

echo "=== Creating inventory file ==="
cat <<EOL > hosts
[labclients]
192.168.189.132 ansible_user=namo
EOL

echo "=== Generating SSH key ==="
ssh-keygen -t rsa -b 2048 -f ~/.ssh/id_rsa -N ""

echo "=== Copying key to client ==="
ssh-copy-id namo@192.168.189.132

echo "=== Setup complete ==="