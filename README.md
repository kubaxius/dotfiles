# Dotfiles Workstation Bootstrap

This repository is the source of truth for a personal Linux workstation:

- **Ansible** manages system provisioning, packages, services, and privileged
  files.
- **chezmoi** manages user configuration files in `$HOME`.
- **Git** tracks and synchronizes all changes.

The repository is stored in chezmoi's default source directory,
`~/.local/share/chezmoi`. The `.chezmoiroot` file points chezmoi at the
`chezmoi/` subdirectory, keeping provisioning files outside the managed home
state.

## Quick start

On a new Arch Linux machine:

```bash
git clone <repository-url> ~/.local/share/chezmoi
cd ~/.local/share/chezmoi
./bootstrap.sh
```

The script discovers the available inventory profiles and prompts for one.
See the [setup guide](docs/setup.md) for profile selection, automation, and the
recommended test flow.

## Documentation

The [documentation index](docs/README.md) covers setup, daily workflows,
project scope, and component-specific configuration.

## Repository layout

```text
.
├── bootstrap.sh          # Main workstation bootstrap command
├── ansible/              # System provisioning and inventory profiles
├── chezmoi/              # Source state for files managed in $HOME
├── docs/                 # Project documentation
├── tests/                # Configuration regression tests
└── tools/                # Repository utilities
```
