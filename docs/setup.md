# Setup and testing

## Bootstrap a new machine

The intended setup is:

1. Clone this repository into `~/.local/share/chezmoi`.
2. Run `./bootstrap.sh`.
3. Let the script install Ansible if necessary.
4. Let Ansible install packages and perform system configuration.
5. Let the playbook run `chezmoi apply` for user configuration.

On a new Arch Linux machine, run:

```bash
git clone <repository-url> ~/.local/share/chezmoi
cd ~/.local/share/chezmoi
./bootstrap.sh
```

If Ansible is missing, `bootstrap.sh` attempts to install it using `pacman`,
`apt-get`, or `dnf`.

## Select an inventory profile

The script discovers the available profiles under `ansible/inventories/` and
asks which one to use. Press Enter to select Deimos, the default:

```text
Available inventory profiles:
  1) deimos
  2) laptop
Select inventory [1]:
```

For automation, bypass the prompt by setting `ANSIBLE_INVENTORY` to an
inventory file before running `./bootstrap.sh`. For example:

```bash
ANSIBLE_INVENTORY=ansible/inventories/laptop/inventory.yml ./bootstrap.sh
```

## Tmux plugin management

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

Use this repository inside a fresh VM first:

1. Install a clean Arch Linux VM.
2. Take a snapshot named `clean-install`.
3. Clone this repository.
4. Run `./bootstrap.sh`.
5. If something breaks, roll back to the snapshot and retry.

## Current status and safety notes

The one-command workflow provisions the selected workstation profile, installs
the configured packages and applications, configures Hyprland plugins and
systemd services, and applies the chezmoi source state. Complete desktop
provisioning currently targets Arch Linux. The bootstrap script can install
Ansible through `apt-get` or `dnf`, and the base role supports those package
families, but the Hyprland workstation role is intentionally Arch-specific.

Continue testing provisioning changes in a VM before relying on them for a new
machine, especially changes involving boot configuration, storage, or service
state.
