# Dotfiles Workstation Bootstrap

This repository is the source of truth for the workstation configuration:

- **Ansible** manages system provisioning: packages, services, and privileged
  files.
- **chezmoi** manages user configuration files in `$HOME`.
- **Git** tracks and synchronizes all changes.

The repository is stored in chezmoi's default source directory,
`~/.local/share/chezmoi`. The `.chezmoiroot` file points chezmoi at the
`chezmoi/` subdirectory, so files belonging to Ansible are not interpreted as
home directory entries.

## Repository layout

```text
.
├── bootstrap.sh
├── ansible/
│   ├── inventories/
│   │   ├── deimos/
│   │   │   ├── inventory.yml
│   │   │   └── host_vars/
│   │   │       └── localhost.yml
│   │   └── laptop/
│   │       ├── inventory.yml
│   │       └── host_vars/
│   │           └── localhost.yml
│   ├── playbook.yml
│   ├── requirements.yml
│   └── roles/
│       ├── base/
│       ├── chezmoi/
│       ├── hyprland/
│       ├── shell/
│       └── systemd/
├── chezmoi/
│   ├── dot_zshenv
│   ├── dot_codex/
│   ├── dot_local/
│   └── private_dot_config/
│       ├── hypr/
│       ├── systemd/
│       ├── tmux/
│       ├── waybar/
│       └── exact_zsh/
└── tools/
```

## Daily chezmoi workflows

### Add an existing application configuration

Add a single file:

```bash
chezmoi add ~/.config/kitty/kitty.conf
```

Add an application's entire configuration directory:

```bash
chezmoi add ~/.config/nvim
```

Chezmoi copies the current configuration into the repository. For example,
`~/.config/nvim/init.lua` becomes
`chezmoi/private_dot_config/nvim/init.lua`.

Review and commit the imported files:

```bash
chezmoi managed
git status
git add chezmoi
git commit -m "Add nvim configuration"
```

Do not add secrets such as API tokens or private keys as plain files.

### Edit repository configuration and apply it

Edit files under the `chezmoi/` directory, which is the source of truth:

```bash
nvim chezmoi/private_dot_config/nvim/init.lua
```

Preview and apply the changes to `$HOME`:

```bash
chezmoi diff
chezmoi apply --verbose
```

To preview without changing anything:

```bash
chezmoi apply --dry-run --verbose
```

Changes can also be applied to one target only:

```bash
chezmoi apply ~/.config/nvim/init.lua
```

After verifying the result, commit the source file:

```bash
git add chezmoi
git commit -m "Update nvim configuration"
```

### Import changes made by an application or its GUI

Some applications modify their own files, for example when a setting is
changed through a GUI. First inspect the difference:

```bash
chezmoi diff ~/.config/example-app
```

Copy the current files from `$HOME` back into the repository:

```bash
chezmoi re-add ~/.config/example-app
```

Then review and commit the result:

```bash
git diff
git add chezmoi
git commit -m "Update example-app settings"
```

`chezmoi re-add` is only needed for changes made outside the repository. For
normal manual editing, edit the source under `chezmoi/` and use
`chezmoi apply`.

### Stop managing an application configuration

To remove a configuration from chezmoi while leaving the active files in
`$HOME` untouched:

```bash
chezmoi forget ~/.config/example-app
```

Review and commit the removal:

```bash
git status
git add -A chezmoi
git commit -m "Stop managing example-app configuration"
```

If the active configuration should also be deleted from `$HOME`, use
`chezmoi destroy` instead. Always preview this destructive operation first;
`--recursive` is required for a directory:

```bash
chezmoi destroy --recursive --dry-run --verbose ~/.config/example-app
chezmoi destroy --recursive ~/.config/example-app
```

## Bootstrap a new machine

The intended setup on a new machine is:

1. Clone this repository into `~/.local/share/chezmoi`.
2. Run `./bootstrap.sh`.
3. Let the script install Ansible if necessary.
4. Let Ansible install packages and perform system configuration.
5. Let the playbook run `chezmoi apply` for user configuration.

The bootstrap roles are implemented. On a new Arch Linux machine, run:

```bash
git clone <repository-url> ~/.local/share/chezmoi
cd ~/.local/share/chezmoi
./bootstrap.sh
```

Because `bootstrap.sh` can attempt to install Ansible using `pacman`,
`apt-get`, or `dnf`, a separate manual Ansible installation is usually
unnecessary.

## Current bootstrap command

Run:

```bash
./bootstrap.sh
```

If Ansible is missing, `bootstrap.sh` will try to install it using `pacman`, `apt-get`, or `dnf`.

The script discovers the available profiles under `ansible/inventories/` and
asks which one to use. Press Enter to select Deimos, the default:

```text
Available inventory profiles:
  1) deimos
  2) laptop
Select inventory [1]:
```

For automation, bypass the prompt by setting `ANSIBLE_INVENTORY` to an
inventory file before running `./bootstrap.sh`.

For example, run the laptop profile with:

```bash
ANSIBLE_INVENTORY=ansible/inventories/laptop/inventory.yml ./bootstrap.sh
```

The Ansible shell role installs [Tpack](https://github.com/tmuxpack/tpack) at
`~/.local/share/tmux/plugins/tpm`; chezmoi owns only the tmux configuration.
Tpack stores plugins alongside itself under `~/.local/share/tmux/plugins`,
using stable aliases declared in the ordered configuration fragments under
`chezmoi/private_dot_config/tmux/conf.d`. The main `tmux.conf` loads those
fragments in lexical order.

Plugin updates are manual: reload tmux and press `prefix` + `U`, or run
`~/.local/share/tmux/plugins/tpm/tpack update all`. Tpack itself checks for
verified release updates automatically and can be checked immediately with
`~/.local/share/tmux/plugins/tpm/tpack self-update`.

## Recommended test flow

Use this repo inside a fresh VM first:

1. Install a clean Arch Linux VM.
2. Take a snapshot named `clean-install`.
3. Clone this repo.
4. Run `./bootstrap.sh`.
5. If something breaks, roll back to the snapshot and retry.

## Current status and safety notes

The one-command workflow provisions the selected workstation profile, installs
the configured packages and applications, configures Hyprland plugins and
systemd services, and applies the chezmoi source state. The complete desktop
provisioning path currently targets Arch Linux. The bootstrap script can install
Ansible through `apt-get` or `dnf`, and the base role supports those package
families, but the Hyprland workstation role is intentionally Arch-specific.

Continue testing provisioning changes in a VM before relying on them for a new
machine, especially changes involving boot configuration, storage, or service
state.
