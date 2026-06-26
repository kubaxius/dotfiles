#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
ANSIBLE_DIR="$REPO_DIR/ansible"
PLAYBOOK="$ANSIBLE_DIR/playbook.yml"

log() {
  printf '
==> %s
' "$*"
}

has_command() {
  command -v "$1" >/dev/null 2>&1
}

install_ansible() {
  if has_command ansible-playbook; then
    return 0
  fi

  log "Ansible is not installed; trying to install it"

  if has_command pacman; then
    sudo pacman -Sy --needed ansible
  elif has_command apt-get; then
    sudo apt-get update
    sudo apt-get install -y ansible
  elif has_command dnf; then
    sudo dnf install -y ansible
  else
    cat >&2 <<'HINT'
Could not detect a supported package manager.
Install Ansible manually, then rerun ./bootstrap.sh.
HINT
    exit 1
  fi
}

log "Starting workstation bootstrap"
install_ansible

if [[ ! -f "$PLAYBOOK" ]]; then
  echo "Error: playbook not found: $PLAYBOOK" >&2
  exit 1
fi

log "Running Ansible playbook"
ansible-playbook   --inventory "$ANSIBLE_DIR/inventory.yml"   --ask-become-pass   "$PLAYBOOK"

log "Bootstrap complete"
