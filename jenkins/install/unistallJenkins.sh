#!/bin/bash
set -e

echo "🧹 Jenkins Uninstallation Script"

# --- FLAGS ---
DRY_RUN=false
FORCE=false

for arg in "$@"; do
  case $arg in
    --dry-run) DRY_RUN=true ;;
    --force) FORCE=true ;;
  esac
done

run_cmd() {
  if [ "$DRY_RUN" = true ]; then
    echo "[DRY-RUN] $*"
  else
    eval "$@"
  fi
}

# --- CHECK ROOT ---
if [ "$EUID" -ne 0 ]; then
  echo "❌ Please run as root (use sudo)"
  exit 1
fi

# --- CONFIRM ---
if [ "$FORCE" = false ]; then
  echo "⚠️ This will REMOVE Jenkins completely (including /var/lib/jenkins)"
  read -p "Continue? (y/N): " confirm
  if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo "❌ Aborted"
    exit 0
  fi
fi

echo "🛑 Stopping Jenkins..."
run_cmd "systemctl stop jenkins || true"

echo "🚫 Disabling Jenkins..."
run_cmd "systemctl disable jenkins || true"

echo "📦 Removing Jenkins package..."
run_cmd "apt purge -y jenkins || true"

echo "🗑️ Removing Jenkins data..."
run_cmd "rm -rf /var/lib/jenkins"

echo "🧹 Removing repo and keys..."
run_cmd "rm -f /etc/apt/sources.list.d/jenkins.list"
run_cmd "rm -f /etc/apt/keyrings/jenkins-keyring.asc"

echo "🔄 Cleaning unused packages..."
run_cmd "apt autoremove -y"

echo "🔍 Verifying removal..."
if command -v jenkins >/dev/null 2>&1; then
  echo "⚠️ Jenkins command still exists"
else
  echo "✅ Jenkins removed successfully"
fi

echo "🏁 Done!"