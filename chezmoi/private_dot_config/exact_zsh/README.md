# Zsh Config

- [Zsh Config](#zsh-config)
  - [Layout](#layout)
  - [How the modular loader works](#how-the-modular-loader-works)
  - [`scripts.zsh` and startup helpers](#scriptszsh-and-startup-helpers)
  - [Editing guidelines](#editing-guidelines)
  - [Using Zinit in this setup](#using-zinit-in-this-setup)
    - [Loading a normal plugin](#loading-a-normal-plugin)
    - [Loading an Oh My Zsh plugin or snippet](#loading-an-oh-my-zsh-plugin-or-snippet)
    - [Loading a Prezto snippet](#loading-a-prezto-snippet)
  - [Resources](#resources)
    - [Core docs](#core-docs)
    - [Plugin and theme ecosystems](#plugin-and-theme-ecosystems)
    - [Useful projects to browse](#useful-projects-to-browse)
    - [General shell inspiration](#general-shell-inspiration)

This directory contains a modular zsh setup intended to be managed as dotfiles.
In the repo, it lives under `stow/zsh/` because it is a Stow-managed home
package. The top-level `.zshenv` points zsh at `~/.config/zsh`, where the
actual interactive loader and configuration modules live.

## Layout

```text
stow/zsh/
├── .zshenv
└── .config/zsh/
    ├── .zshrc
    ├── env.zsh
    ├── options.zsh
    ├── history.zsh
    ├── aliases.zsh
    ├── keybinds.zsh
    ├── completion.zsh
    ├── plugins.zsh
    ├── prompt.zsh
    ├── scripts.zsh
    └── scripts/
        └── *.zsh
```

## How the modular loader works

The top-level `.zshenv` sets:

```zsh
export ZDOTDIR="$HOME/.config/zsh"
```

Then `$ZDOTDIR/.zshrc` sources each module in a fixed order:

1. `env.zsh`
2. `options.zsh`
3. `history.zsh`
4. `aliases.zsh`
5. `keybinds.zsh`
6. `completion.zsh`
7. `plugins.zsh`
8. `prompt.zsh`
9. `scripts.zsh`

That order matters.

- `env.zsh` is for environment variables and path setup.
- `options.zsh` is for general shell behavior (`setopt`, globbing, etc.).
- `history.zsh` is for command history storage, synchronization, and cleanup.
- `aliases.zsh` is for command shortcuts and shell wrapper functions.
- `keybinds.zsh` is for interactive editing behavior.
- `completion.zsh` prepares completion before plugin-specific additions.
- `plugins.zsh` loads plugin managers, plugins, and external integrations.
- `prompt.zsh` configures the prompt after the rest of the shell is ready.
- `scripts.zsh` is a loader for small startup scripts stored in
  `.config/zsh/scripts/*.zsh`.

Because each concern lives in its own file, it is easier to:

- find where a behavior comes from,
- change one area without touching unrelated config,
- disable features temporarily,
- keep git diffs small and readable.

## `scripts.zsh` and startup helpers

`scripts.zsh` is intentionally just a dispatcher. It only runs for interactive
shells and then sources every `*.zsh` file inside `scripts/`.

That makes it a good place for things like:

- startup banners,
- `neofetch` / `fastfetch`,
- one-off interactive helpers,
- machine-specific niceties you do not want mixed into core shell behavior.

If something is part of how zsh behaves globally, it usually belongs in one of
the main modules instead of `scripts/`.

## Editing guidelines

Some simple conventions keep this layout predictable:

- Put behavior in the narrowest matching module.
- Keep `.zshrc` as a loader, not a dumping ground.
- Prefer shell functions over aliases when arguments or fallback behavior matter.
- Guard interactive-only behavior with checks like `[[ $- == *i* ]]`.
- Keep experimental or host-specific changes isolated where possible.

## Using Zinit in this setup

This config uses **Zinit** as its plugin manager in `.config/zsh/plugins.zsh`.
If you want a short refresher on syntax or features, start with:

- Zinit wiki: <https://zdharma-continuum.github.io/zinit/wiki/>
- Zinit README: <https://github.com/zdharma-continuum/zinit?tab=readme-ov-file>

The most common pattern is:

```zsh
# Optional load options go first.
zinit ice wait lucid
zinit light zsh-users/zsh-autosuggestions
```

Useful reminders:

- `zinit light <owner/repo>` loads a normal GitHub plugin.
- `zinit ice ...` sets options for the **next** plugin or snippet only.
- Keep plugin-specific settings directly above the matching `zinit` line.
- If a plugin needs to load last, document that and leave it near the end of
  `plugins.zsh`.

### Loading a normal plugin

```zsh
zinit light Aloxaf/fzf-tab
```

### Loading an Oh My Zsh plugin or snippet

Zinit can also pull pieces directly from **Oh My Zsh** without installing OMZ
itself.

```zsh
# Oh My Zsh plugin
zinit snippet OMZP::git

# Oh My Zsh library snippet
zinit snippet OMZL::history.zsh

# Oh My Zsh theme snippet
zinit snippet OMZT::robbyrussell
```

### Loading a Prezto snippet

Zinit can also load pieces from **Prezto**:

```zsh
# Prezto module init script
zinit snippet PZT::modules/environment/init.zsh

# Another example
zinit snippet PZT::modules/history/init.zsh
```

For this repo, a good rule of thumb is:

- use `zinit light` for standalone plugins,
- use `zinit snippet ...` when you only want a specific OMZ/Prezto component,
- add comments above each entry so it is obvious what the plugin/snippet is for.

## Resources

### Core docs

- Zsh documentation: <https://zsh.sourceforge.io/Doc/>
- Arch Wiki: Zsh: <https://wiki.archlinux.org/title/Zsh>
- Arch Wiki: Command-line shell: <https://wiki.archlinux.org/title/Command-line_shell>

### Plugin and theme ecosystems

- Oh My Zsh: <https://ohmyz.sh/>
- OMZ plugins: <https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins>
- OMZ themes: <https://github.com/ohmyzsh/ohmyzsh/wiki/Themes>
- Awesome Zsh Plugins: <https://github.com/unixorn/awesome-zsh-plugins>
- GitHub topic: zsh-plugin: <https://github.com/topics/zsh-plugin>
- GitHub topic: zsh-theme: <https://github.com/topics/zsh-theme>

### Useful projects to browse

- zsh-users org: <https://github.com/zsh-users>
- Zinit: <https://github.com/zdharma-continuum/zinit>
- Antidote: <https://github.com/mattmc3/antidote>
- powerlevel10k: <https://github.com/romkatv/powerlevel10k>
- starship: <https://github.com/starship/starship>
- fzf-tab: <https://github.com/Aloxaf/fzf-tab>
- zoxide: <https://github.com/ajeetdsouza/zoxide>
- atuin: <https://github.com/atuinsh/atuin>
- direnv: <https://github.com/direnv/direnv>

### General shell inspiration

These are more specific to shell setup and zsh tuning than to the repo as a
whole:

- Shell startup benchmarking ideas:

  ```bash
  time zsh -i -c exit
  zsh -f
  ```

For broader dotfiles inspiration, see the repo root `README.md`.
