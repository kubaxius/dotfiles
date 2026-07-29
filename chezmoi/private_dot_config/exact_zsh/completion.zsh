# =============================================================================
# Module: completion.zsh
# Purpose: Configure shell completion behavior and initialize zsh completion.
# =============================================================================

# Configure completion to expand patterns first, then complete matches, then include ignored ones.
zstyle ':completion:*' completer _expand _complete _ignored

# Match completion candidates case-insensitively.
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# When there are multiple matches, show an interactive completion menu.
zstyle ':completion:*' menu select

# Show completion results grouped by category with readable section headers.
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
zstyle ':completion:*:warnings' format '%F{red}-- no matches found --%f'
zstyle ':completion:*:messages' format '%F{magenta}-- %d --%f'

# Reuse LS_COLORS so files, directories, symlinks, etc. are colorized in the
# completion list when the terminal supports it.
if [[ -n "${LS_COLORS:-}" ]]; then
  zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
fi

# Keep the compinstall metadata pointing to the main zsh startup file.
# If you ever wanted to regenerate these settings.
zstyle :compinstall filename "$ZDOTDIR/.zshrc"

# Load user-provided completion functions before compinit builds its dump.
# `$fpath` is where zsh looks for autoloadable functions, including custom
# completion definitions such as `_some-command` stored in `~/.zfunc`.
fpath=("$HOME/.zfunc" $fpath)

# Make the completion initializer function available for loading.
# `-U` keeps aliases from being expanded while the function is loaded, which is
# the recommended behavior for zsh's bundled completion functions.
autoload -Uz compinit

# Initialize zsh's completion system using the configured styles and `$fpath`.
compinit
