# Daily chezmoi workflows

The files under `chezmoi/` are the source of truth for user configuration
deployed into `$HOME`.

## Add an existing application configuration

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

## Edit repository configuration and apply it

Edit files under the `chezmoi/` directory:

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

## Import changes made by an application or its GUI

Some applications modify their own files when a setting is changed through a
GUI. First inspect the difference:

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

## Stop managing an application configuration

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
