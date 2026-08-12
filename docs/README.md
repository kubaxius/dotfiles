# Documentation

This directory is the central home for human-facing project documentation.
Start with setup for a new workstation or use the component guides when
changing a specific part of the configuration.

## Project

- [Setup and testing](setup.md) — bootstrap a workstation, select an inventory,
  and validate provisioning changes.
- [Daily chezmoi workflows](chezmoi-workflows.md) — add, edit, import, and stop
  managing home-directory configuration.
- [Project scope](scope.md) — goals, current capabilities, and deliberate
  exclusions.

## Components

- [Zsh configuration](components/zsh.md) — module layout, loading order, editing
  conventions, and Zinit usage.
- [Navi cheatsheet syntax](components/navi-cheatsheets.md) — local reference for
  commands, variables, extensions, and aliases.
- [Hyprland and UWSM](components/hyprland-uwsm.md) — session ownership, service
  policy, diagnostics, and recovery notes.

The `SKILL.md` files under `chezmoi/dot_codex/skills/` remain next to the
configuration that consumes them; they are operational definitions rather than
general project documentation.
