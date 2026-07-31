#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
ANSIBLE_DIR="$REPO_DIR/ansible"
PLAYBOOK="$ANSIBLE_DIR/playbook.yml"
INVENTORY=""

log() {
  printf '
==> %s
' "$*"
}

has_command() {
  command -v "$1" >/dev/null 2>&1
}

select_inventory() {
  if [[ -n "${ANSIBLE_INVENTORY:-}" ]]; then
    INVENTORY="$ANSIBLE_INVENTORY"
    return
  fi

  local inventory_files=()
  local default_index=1
  local choice
  local index
  local profile

  shopt -s nullglob
  inventory_files=("$ANSIBLE_DIR"/inventories/*/inventory.yml)
  shopt -u nullglob

  if (( ${#inventory_files[@]} == 0 )); then
    echo "Error: no inventories found under $ANSIBLE_DIR/inventories" >&2
    exit 1
  fi

  printf '\nAvailable inventory profiles:\n'
  for index in "${!inventory_files[@]}"; do
    profile="$(basename -- "$(dirname -- "${inventory_files[$index]}")")"
    printf '  %d) %s\n' "$((index + 1))" "$profile"
    if [[ "$profile" == "deimos" ]]; then
      default_index=$((index + 1))
    fi
  done

  while true; do
    read -r -p "Select inventory [$default_index]: " choice
    choice="${choice:-$default_index}"

    if [[ "$choice" =~ ^[0-9]+$ ]] &&
      (( choice >= 1 && choice <= ${#inventory_files[@]} )); then
      INVENTORY="${inventory_files[$((choice - 1))]}"
      return
    fi

    echo "Please enter a number between 1 and ${#inventory_files[@]}." >&2
  done
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
select_inventory
install_ansible

if [[ ! -f "$PLAYBOOK" ]]; then
  echo "Error: playbook not found: $PLAYBOOK" >&2
  exit 1
fi

if [[ ! -f "$INVENTORY" ]]; then
  echo "Error: inventory not found: $INVENTORY" >&2
  exit 1
fi

log "Running Ansible playbook"
log "Using inventory: $INVENTORY"
ansible-playbook \
  --inventory "$INVENTORY" \
  --ask-become-pass \
  "$PLAYBOOK"

log "Bootstrap complete"
