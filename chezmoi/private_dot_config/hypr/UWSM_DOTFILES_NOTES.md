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
- Avoid UWSM/systemd launching the XDG autostart batch in Hyprland without
  disabling XDG autostart in other desktop environments.

## Service Inventory

The canonical list of persistent systemd user units is
`ansible/roles/hyprland/defaults/main.yml` under
`hyprland_user_services.enable`. The target masks are under
`hyprland_user_targets.mask`; shared targets that must remain available are
under `hyprland_user_targets.unmask`. Keep transient processes started by
`uwsm.start*` in this note instead: they are scopes created on demand, not
service files.

Use package-provided user units by default. A unit in
`~/.config/systemd/user/` with the same name overrides the package unit in
`/usr/lib/systemd/user/`; it is not an additional service.

Current intended persistent units:

| Unit | Origin | Enabled |
| --- | --- | --- |
| `hyprpaper.service` | package | yes |
| `hypridle.service` | package | yes |
| `waybar.service` | package | yes |
| `swaync.service` | package | yes |
| `hyprpolkitagent.service` | package | yes |

## Launch Policy

- Apps and long-lived daemons started by Hyprland config go through
  `lib.uwsm.app`, `lib.uwsm.exec`, or `lib.uwsm.start`.
- Pass an optional unit suffix when a stable UWSM unit name is useful:
  `uwsm.exec("firefox", "firefox")` launches
  `uwsm-app -u hyprland-firefox.scope -- firefox`.
- Session shutdown uses `lib.uwsm.stop()` / `uwsm stop`.
- Only compositor controls and one-shot system controls use raw commands via
  `lib.uwsm.raw` or `lib.uwsm.start_raw`.
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

UWSM's Hyprland-specific XDG autostart target is masked:

```sh
systemctl --user mask wayland-session-xdg-autostart@hyprland.desktop.target
```

This stops UWSM from launching generated XDG autostart units such as KDE
Connect, KAlarm, KGpg, print applet, pamac tray, OpenRGB, Obsidian, etc. in the
Hyprland session. The shared `xdg-desktop-autostart.target` remains unmasked,
so other desktop environments can still use normal XDG autostart.

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
systemctl --user is-enabled waybar hypridle hyprpaper \
  xdg-desktop-autostart.target \
  wayland-session-xdg-autostart@hyprland.desktop.target
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
static
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
~/.config/systemd/user/wayland-session-xdg-autostart@hyprland.desktop.target -> /dev/null
```

Ansible owns packages, user-service enablement, and the XDG-autostart target
mask. The executable definitions are:

```text
ansible/roles/hyprland/defaults/main.yml
ansible/roles/hyprland/tasks/main.yml
ansible/roles/hyprland/tasks/user_services.yml
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
