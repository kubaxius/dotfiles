---
name: navi-command-notes
description: Save commands and interactive command wizards in the user's Navi cheatsheets managed by their chezmoi dotfiles repository. Use when the user asks to write down, note, save, or add a shell command to Navi; create or expand a Navi command wizard; or organize commands in Navi `.cheat` files.
---

# Navi Command Notes

Store requested commands in the user's chezmoi-managed Navi cheatsheets and apply the resulting dotfiles.

## Workflow

1. Work in `/home/kubaxius/.local/share/chezmoi`.
2. Inspect `chezmoi/dot_local/share/navi/exact_cheats/` and any relevant `.cheat` files before editing.
3. Choose the file by command domain, such as `systemd.cheat`, `git.cheat`, or `flatpak.cheat`. Create a lowercase, domain-named `.cheat` file when no suitable file exists. Move an existing related entry instead of duplicating it.
4. Add or update the entry using Navi syntax and the file's established style. Preserve unrelated user changes.
5. Validate the edited files:
   - Run `git diff --check`.
   - Use the installed `navi` to print representative generated commands when interpolation or mappings are involved.
   - Do not execute a recorded command merely to test it when it could mutate state, require privileges, or be destructive.
6. Run `chezmoi apply` from the repository root after validation. Treat this as a required final step, not an optional suggestion.
7. Report the source file changed, what was added, validation performed, and whether `chezmoi apply` succeeded.

## Navi authoring patterns

Use a normal entry for a fixed command:

```sh
% tool, relevant, tags
# Concise description
tool subcommand --flag
```

Use placeholders and suggestion commands for a wizard:

```sh
% tool, relevant, tags
# Concise description
tool <action> '<item>'

$ action: printf '%s\n' first second --- --prevent-extra
$ item: tool list --plain
```

- Put each `$ variable:` definition in the same cheat section as the snippet that consumes it.
- Use `--prevent-extra` for closed choices.
- Use `--- --map "..."` when friendly labels must become flags or other command fragments.
- Refer to earlier variables from later suggestion commands when choices depend on one another.
- Quote interpolated values that may contain spaces, backslashes, glob characters, or systemd-escaped names.
- For browsing tabular output, make the pipeline non-paging and machine-friendly before `fzf`; prefer a custom `fzf --header` with upstream `--no-legend` when footer rows would otherwise be selectable.
- Remember that Navi already uses `fzf` for placeholder suggestions. Pipe the final command to `fzf` only when the user wants to browse or filter command output.

Keep entries useful and concise. Ask for clarification only when the intended command, domain, or wizard choices cannot be inferred safely.
