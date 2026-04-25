#!/bin/bash

set -e  # Exit immediately if any command fails

echo "🔄 Updating system..."
sudo apt update -y

echo "☕ Installing Java (OpenJDK 21)..."
sudo apt install -y fontconfig openjdk-21-jre

echo "✅ Verifying Java installation..."
java -version

echo "🔐 Adding Jenkins repository key..."
sudo mkdir -p /etc/apt/keyrings

sudo wget -q -O /etc/apt/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key

echo "📦 Adding Jenkins repository..."
echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | \
  sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

echo "🔄 Updating package list again..."
sudo apt update -y

echo "🚀 Installing Jenkins..."
sudo apt install -y jenkins

echo "🔁 Reloading systemd..."
sudo systemctl daemon-reload

echo "⚙️ Enabling Jenkins service..."
sudo systemctl enable jenkins

echo "▶️ Starting Jenkins..."
sudo systemctl start jenkins

echo "📊 Checking Jenkins status..."
sudo systemctl status jenkins --no-pager

echo "🔑 Getting initial admin password..."
sudo cat /var/lib/jenkins/secrets/initialAdminPassword

echo ""
echo "🌐 Open Jenkins in browser:"
echo "👉 http://localhost:8080"
echo ""
echo "🎯 Installation complete!"