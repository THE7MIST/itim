#!/bin/bash
#docker logout 

#docker login

# --- INPUT ---
read -p "Enter Docker Hub username: " USERNAME
read -p "Enter Image name (e.g., rolling): " IMAGE
read -p "Enter Tag (e.g., 1.0): " TAG

# --- VALIDATION ---
if [[ -z "$USERNAME" || -z "$IMAGE" || -z "$TAG" ]]; then
  echo "❌ All fields are required"
  exit 1
fi

# Convert username to lowercase (Docker requirement)
USERNAME=$(echo "$USERNAME" | tr '[:upper:]' '[:lower:]')

echo " Using username: $USERNAME"

# --- FIX DOCKER PERMISSIONS ---
echo "🔧 Setting docker permissions..."
sudo usermod -aG docker $USER
newgrp docker

# --- FIX DNS ISSUE ---
echo "🔧 Restarting DNS resolver..."
sudo systemctl restart systemd-resolved

# --- CHECK IMAGE EXISTS ---
IMAGE_ID=$(docker images -q "$IMAGE:$TAG")

if [[ -z "$IMAGE_ID" ]]; then
  echo "Image $IMAGE:$TAG not found locally"
  exit 1
fi

# --- TAG IMAGE ---
echo " Tagging image..."
docker tag "$IMAGE:$TAG" "$USERNAME/$IMAGE:$TAG"

# --- LOGIN CHECK ---
echo " Checking Docker login..."
docker info | grep -i username

# --- PUSH IMAGE ---
echo " Pushing image..."
docker push "$USERNAME/$IMAGE:$TAG"

echo "✅ Done!"