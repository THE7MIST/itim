#!/usr/bin/env bash

#sudo date -s "2026-04-23 14:30:00"

set -e

echo "🔹 Updating system..."
sudo apt update -y

echo "🔹 Installing Docker..."
if ! command -v docker &> /dev/null; then
    sudo apt install -y docker.io
else
    echo "Docker already installed"
fi

echo "🔹 Starting Docker..."
sudo systemctl enable docker
sudo systemctl start docker

echo "🔹 Adding user to docker group..."
sudo usermod -aG docker $USER

echo "⚠️ Re-loading group permissions..."
newgrp docker <<EOF

echo "🔹 Downloading Minikube..."
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64

echo "🔹 Making it executable..."
chmod +x minikube-linux-amd64

echo "🔹 Installing Minikube..."
sudo mv minikube-linux-amd64 /usr/local/bin/minikube

echo "🔹 Verifying installation..."
minikube version

echo "🔹 Starting Minikube..."
minikube start --driver=docker --memory=2000mb

echo "🔹 Checking cluster..."
minikube kubectl -- get nodes

echo "✅ Setup complete!"
EOF


#docker system prune -a -f
#rm -rf ~/.minikube
#rm -rf ~/.kube

#df -h

#docker ps

#minikube start --driver=docker --memory=2000mb

