# Scope

## Purpose

This repository is a personal workstation bootstrap lab.

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

## MVP

The first version should stay small:

- `bootstrap.sh` as the main entrypoint
- local Ansible playbook for `localhost`
- base package installation
- chezmoi apply from the local `chezmoi/` source directory
- simple zsh dotfiles as placeholders

## Out of scope for now

- generic multi-user framework
- complex role abstractions
- secrets management
- full cross-distro support beyond basic package-manager examples
- destructive system changes
- GRUB automation before VM testing is comfortable
