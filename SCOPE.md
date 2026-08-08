# Scope

## Purpose

This repository is a personal workstation bootstrap and dotfiles project.

The goal is to test a one-command setup flow for a fresh Linux machine or VM,
using:

- Ansible for system provisioning
- chezmoi for user dotfiles

## Target workflow

1. Clone this repository.
2. Run one main command.
3. Install required packages and system dependencies.
4. Apply user dotfiles safely.
5. Re-run the command without breaking the system.

## Current scope

The implemented workflow includes:

- `bootstrap.sh` as the main entrypoint
- inventory profiles for the Deimos desktop and a laptop
- base and shell package installation
- Arch Linux Hyprland packages, plugins, optional workstation features, and
  Flatpak applications
- system and user service configuration through a dedicated systemd role
- chezmoi apply from the local `chezmoi/` source directory
- modular Hyprland, Zsh, tmux, Waybar, Navi, and related user configuration

## Out of scope for now

- generic multi-user framework
- complex role abstractions
- secrets management
- complete desktop provisioning on non-Arch distributions
- destructive system changes
- GRUB automation before VM testing is comfortable
