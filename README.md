# Dotfiles Workstation Bootstrap Lab

This is a minimal test repository for building a personal Linux workstation
bootstrap workflow.

The intended architecture is:

- **Ansible** manages system provisioning: packages, services, privileged files.
- **chezmoi** manages user dotfiles in `$HOME`.

## Repository layout

```text
.
├── bootstrap.sh
├── ansible/
│   ├── inventory.yml
│   ├── playbook.yml
│   ├── group_vars/
│   │   └── localhost.yml
│   └── roles/
│       ├── base/
│       └── chezmoi/
├── chezmoi/
│   ├── dot_zshrc
│   ├── dot_zshenv
│   └── dot_config/
│       └── zsh/
└── system/
```

## Quick start

Run:

```bash
./bootstrap.sh
```

If Ansible is missing, `bootstrap.sh` will try to install it using `pacman`, `apt-get`, or `dnf`.

The script runs:

```bash
ansible-playbook --inventory ansible/inventory.yml --ask-become-pass ansible/playbook.yml
```

## Recommended test flow

Use this repo inside a fresh VM first:

1. Install a clean Arch Linux VM.
2. Take a snapshot named `clean-install`.
3. Clone this repo.
4. Run `./bootstrap.sh`.
5. If something breaks, roll back to the snapshot and retry.

## Safety notes

This is intentionally minimal. The current playbook installs only base packages
and applies placeholder chezmoi dotfiles.

Do not add destructive system tasks until they have been tested in a VM.
