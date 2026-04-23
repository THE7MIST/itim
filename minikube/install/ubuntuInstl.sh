#!/usr/bin/env bash
set -Eeuo pipefail

# -----------------------------
# CONFIG
# -----------------------------
MINIKUBE_URL="https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64"
INSTALL_PATH="/usr/local/bin/minikube"
TMP_FILE="/tmp/minikube-linux-amd64"
MEMORY_MB=2000

# -----------------------------
# HELPERS
# -----------------------------
log()  { echo -e "\e[32m[INFO]\e[0m $*"; }
warn() { echo -e "\e[33m[WARN]\e[0m $*"; }
err()  { echo -e "\e[31m[ERROR]\e[0m $*"; exit 1; }

require_root() {
  if [[ $EUID -ne 0 ]]; then
    err "Run this script with sudo or as root"
  fi
}

check_network() {
  log "Checking internet connectivity..."
  ping -c1 google.com &>/dev/null || err "No internet connection"
}

# -----------------------------
# MAIN
# -----------------------------
require_root
check_network

log "Updating system..."
apt update -y

# -----------------------------
# INSTALL DOCKER
# -----------------------------
if ! command -v docker &>/dev/null; then
  log "Installing Docker..."
  apt install -y docker.io
else
  log "Docker already installed"
fi

log "Starting Docker..."
systemctl enable docker
systemctl restart docker

# -----------------------------
# FIX PERMISSIONS
# -----------------------------
USER_NAME="${SUDO_USER:-$(whoami)}"
log "Adding user '$USER_NAME' to docker group..."
usermod -aG docker "$USER_NAME"

# -----------------------------
# REMOVE OLD MINIKUBE
# -----------------------------
log "Cleaning old Minikube (if any)..."
rm -f "$INSTALL_PATH" "$TMP_FILE"

# -----------------------------
# DOWNLOAD MINIKUBE
# -----------------------------
log "Downloading Minikube..."
curl -fsSL -o "$TMP_FILE" "$MINIKUBE_URL" || err "Download failed"

# -----------------------------
# VALIDATE DOWNLOAD
# -----------------------------
SIZE=$(stat -c%s "$TMP_FILE" || echo 0)

if [[ "$SIZE" -lt 50000000 ]]; then
  err "Downloaded file too small ($SIZE bytes) → likely wrong URL or network issue"
fi

FILE_TYPE=$(file "$TMP_FILE")

if ! echo "$FILE_TYPE" | grep -q "ELF"; then
  err "Downloaded file is not a valid binary → got: $FILE_TYPE"
fi

log "Download verified (size: $SIZE bytes)"

# -----------------------------
# INSTALL MINIKUBE
# -----------------------------
chmod +x "$TMP_FILE"
mv "$TMP_FILE" "$INSTALL_PATH"

log "Minikube installed at $INSTALL_PATH"

# -----------------------------
# VERIFY DOCKER ACCESS
# -----------------------------
if ! sudo -u "$USER_NAME" docker ps &>/dev/null; then
  warn "Docker permission not active yet."
  warn "User must re-login OR run: newgrp docker"
fi

# -----------------------------
# START MINIKUBE
# -----------------------------
log "Starting Minikube..."

if ! sudo -u "$USER_NAME" minikube start --driver=docker --memory=${MEMORY_MB}mb; then
  warn "Retrying with sudo (fallback)..."
  minikube start --driver=docker --memory=${MEMORY_MB}mb || err "Minikube failed to start"
fi

# -----------------------------
# FINAL STATUS
# -----------------------------
log "Cluster status:"
sudo -u "$USER_NAME" minikube kubectl -- get nodes || true

log "✅ Setup completed successfully"
log "👉 If docker permission issue occurs, run: newgrp docker"