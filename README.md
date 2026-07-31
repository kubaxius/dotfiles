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
│   └── roles/
│       ├── base/
│       ├── chezmoi/
│       ├── hyprland/
│       └── shell/
├── chezmoi/
│   ├── dot_zshrc
│   ├── dot_zshenv
│   └── private_dot_config/
│       └── zsh/
└── system/
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

Once the bootstrap roles are implemented, the process should be:

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

The playbook also clones [Tpack](https://github.com/tmuxpack/tpack) to
`~/.tmux/plugins/tpm`, which is Tpack's TPM-compatible Git-clone location.
This checkout is idempotent: a first run clones Tpack and later runs update its
`main` branch. Add Tpack-managed plugins as `set -g @plugin
'owner/repository'` lines before the Tpack `run` line in
`chezmoi/private_dot_config/tmux/tmux.conf`; reload tmux and press `prefix` +
`I` to install them.

## Recommended test flow

Use this repo inside a fresh VM first:

1. Install a clean Arch Linux VM.
2. Take a snapshot named `clean-install`.
3. Clone this repo.
4. Run `./bootstrap.sh`.
5. If something breaks, roll back to the snapshot and retry.

## Current status and safety notes

This repository is still a minimal bootstrap lab. The playbook references the
`base` and `chezmoi` roles, but those roles are not currently present. As a
result, the documented one-command bootstrap is the target workflow, not yet a
working fresh-machine installation.

Do not add destructive system tasks until they have been tested in a VM.
