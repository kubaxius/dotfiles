# Hyprland UWSM / Dotfiles Notes

This file records the session-management changes made while debugging
Hypridle screen-off wake issues, Waybar crashes, and UWSM startup behavior.

## Current Intent

- Use the SDDM session named `Hyprland (uwsm-managed)`.
- Let systemd user services supervise:
  - `waybar.service`
  - `hypridle.service`
  - `hyprpaper.service`
- Keep Hypridle turning the screen off after 10 minutes.
- Avoid UWSM/systemd launching the whole XDG autostart batch from Plasma/KDE.

## Launch Policy

- Apps and long-lived daemons started by Hyprland config go through
  `modules.uwsm.app`, `modules.uwsm.exec`, or `modules.uwsm.start`.
- Pass an optional unit suffix when a stable UWSM unit name is useful:
  `uwsm.exec("firefox", "firefox")` launches
  `uwsm-app -u hyprland-firefox.scope -- firefox`.
- Session shutdown uses `modules.uwsm.stop()` / `uwsm stop`.
- Only compositor controls and one-shot system controls use raw commands via
  `modules.uwsm.raw` or `modules.uwsm.start_raw`.
- Launchers need their spawned apps wrapped too:
  `hyprlauncher.conf` sets `desktop_launch_prefix = uwsm app --`, and the
  future rofi command uses `-run-command "uwsm app -- {cmd}"`.

## Local Config Changes

`modules/autostart.lua`

- Removed manual startup of `hypridle`.
- Removed unconditional manual startup of `waybar & hyprpaper`.
- Added a fallback for non-UWSM Hyprland sessions:

```lua
uwsm.start_raw([[test "$DESKTOP_SESSION" = hyprland-uwsm || (waybar & hyprpaper)]])
```

This prevents duplicate Waybar under UWSM, while still giving a bar if the
old non-UWSM Hyprland session is used.

`hypridle.conf`

- Uses Lua dispatcher DPMS commands:

```conf
after_sleep_cmd = hyprctl dispatch 'hl.dsp.dpms({ action = "enable" })'
on-timeout = hyprctl dispatch 'hl.dsp.dpms({ action = "disable" })'
on-resume = hyprctl dispatch 'hl.dsp.dpms({ action = "enable" })'
```

## System/User State To Recreate

Packages needed:

```text
hyprland
hypridle
hyprpaper
waybar
uwsm
```

User services enabled:

```sh
systemctl --user enable waybar.service hypridle.service hyprpaper.service
```

XDG autostart target masked for this user:

```sh
systemctl --user mask xdg-desktop-autostart.target
```

This mask stops UWSM/systemd from launching generated XDG autostart units such
as KDE Connect, KAlarm, KGpg, print applet, pamac tray, OpenRGB, Obsidian, etc.
It is user-wide, so it may affect Plasma autostart behavior for this same user.

## Useful Checks

Confirm UWSM session:

```sh
systemctl --user show-environment | rg 'DESKTOP_SESSION|XDG_CURRENT_DESKTOP|WAYLAND_DISPLAY'
```

Expected:

```text
DESKTOP_SESSION=hyprland-uwsm
XDG_CURRENT_DESKTOP=Hyprland
WAYLAND_DISPLAY=...
```

Confirm services:

```sh
systemctl --user is-active graphical-session.target waybar hypridle hyprpaper
systemctl --user is-enabled waybar hypridle hyprpaper xdg-desktop-autostart.target
```

Expected:

```text
active
active
active
active
enabled
enabled
enabled
masked
```

Confirm one Waybar layer:

```sh
hyprctl layers
```

Look for exactly one `namespace: waybar` entry.

Check logs:

```sh
journalctl --user -u waybar -u hypridle -u hyprpaper -b
journalctl -b -k -g 'amdgpu|drm|REG_WAIT|timeout'
```

## Dotfiles Setup Notes

chezmoi should own files under the home directory, especially:

```text
~/.config/hypr/
~/.config/waybar/
~/.config/systemd/user/xdg-desktop-autostart.target -> /dev/null
```

Ansible should own packages and user service enablement.

Example Ansible tasks:

```yaml
- name: Install Hyprland session packages
  become: true
  ansible.builtin.package:
    name:
      - hyprland
      - hypridle
      - hyprpaper
      - waybar
      - uwsm
    state: present

- name: Enable Hyprland user services
  ansible.builtin.systemd_service:
    name: "{{ item }}"
    enabled: true
    scope: user
  loop:
    - waybar.service
    - hypridle.service
    - hyprpaper.service
  environment:
    XDG_RUNTIME_DIR: "/run/user/{{ ansible_user_uid }}"

- name: Mask XDG autostart for this user
  ansible.builtin.systemd_service:
    name: xdg-desktop-autostart.target
    masked: true
    scope: user
  environment:
    XDG_RUNTIME_DIR: "/run/user/{{ ansible_user_uid }}"
```

Avoid starting `waybar`, `hypridle`, or `hyprpaper` from Ansible provisioning.
They need a real graphical Wayland session; enable them and let UWSM start them
on login.

## Important Caveat

The original black-screen wake issue may still be lower-level AMDGPU/HDMI/USB
behavior. The UWSM/systemd changes mainly make session processes recoverable
and easier to inspect. If the screen still sometimes does not wake, continue
with kernel/AMDGPU/display-link diagnostics rather than assuming Waybar or
Hypridle is the only cause.
