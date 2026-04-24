#!/bin/bash

set -e  # stop on error

echo "🔹 Updating system..."
sudo apt update -y

echo "🔹 Installing dependencies..."
sudo apt install -y curl

echo "🔹 Downloading latest kubectl..."
KUBECTL_VERSION=$(curl -L -s https://dl.k8s.io/release/stable.txt)

curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl"

echo "🔹 Making kubectl executable..."
chmod +x kubectl

echo "🔹 Moving kubectl to /usr/local/bin..."
sudo mv kubectl /usr/local/bin/

echo "🔹 Verifying kubectl installation..."
kubectl version --client

echo "🔹 Checking Minikube status..."
minikube status || echo "⚠️ Minikube not running"

echo "🔹 Checking Kubernetes nodes..."
kubectl get nodes || echo "⚠️ Unable to fetch nodes"

echo "🔹 Checking all pods..."
kubectl get pods -A || echo "⚠️ Unable to fetch pods"

echo "✅ Setup complete!"