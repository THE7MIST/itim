#!/bin/bash

echo "Opening official Docker installation documentation..."
echo "https://docs.docker.com/engine/install/ubuntu/"
echo "--------------------------------------------------"

echo "[STEP 1] Removing any old or conflicting Docker packages..."
# Remove old versions of Docker and related packages
sudo apt remove $(dpkg --get-selections docker.io docker-compose docker-compose-v2 docker-doc podman-docker containerd runc | cut -f1)

echo "[STEP 2] Updating package index..."
# Update package list
sudo apt update

echo "[STEP 3] Installing required dependencies (ca-certificates, curl)..."
# Install required packages
sudo apt install ca-certificates curl

echo "[STEP 4] Creating directory for Docker GPG key..."
# Create directory for keyrings
sudo install -m 0755 -d /etc/apt/keyrings

echo "[STEP 5] Downloading Docker's official GPG key..."
# Download Docker GPG key
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc

echo "[STEP 6] Setting permissions for GPG key..."
# Set read permissions
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo "[STEP 7] Adding Docker repository to APT sources..."
# Add Docker repository
sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF

echo "[STEP 8] Updating package index with Docker repo..."
# Update package list again
sudo apt update

echo "[STEP 9] Installing Docker Engine, CLI, Containerd, Buildx, and Compose plugin..."
# Install Docker packages
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "[STEP 10] Checking Docker service status..."
# Check Docker service status
sudo systemctl status docker

echo "[STEP 11] Starting Docker service..."
# Start Docker service
sudo systemctl start docker

echo "[STEP 12] Running test container (hello-world)..."
# Test Docker installation
sudo docker run hello-world

echo "--------------------------------------------------"
echo "Docker installation and basic test completed!"
