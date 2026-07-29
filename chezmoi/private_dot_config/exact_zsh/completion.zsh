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

# Keep the generated completion dump out of the managed Zsh configuration.
zcompdump_dir="$HOME/.cache/zsh"
mkdir -p -- "$zcompdump_dir"

# Initialize completion using the cached registry, then avoid leaking the
# temporary path variable into the interactive shell.
compinit -d "$zcompdump_dir/zcompdump"
unset zcompdump_dir

# Register the completion definition provided by the tldr client. The client
# can only list pages in its local cache, so refresh the complete page archive
# quietly in the background when it is missing or more than a week old.
if command -v tldr >/dev/null 2>&1; then
  tldr_cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/tldr"
  tldr_update_stamp="$tldr_cache_dir/.last-completion-update"
  tldr_update_lock="$tldr_cache_dir/.completion-update-lock"

  mkdir -p -- "$tldr_cache_dir"
  if [[ ! -e "$tldr_update_stamp" ]] ||
    [[ -n "$(find "$tldr_update_stamp" -mtime +6 -print -quit 2>/dev/null)" ]]
  then
    if mkdir -- "$tldr_update_lock" 2>/dev/null; then
      (
        command tldr --update >/dev/null 2>&1
        tldr_command_count="$(command tldr --list 2>/dev/null | wc -w)"
        if (( tldr_command_count > 100 )); then
          touch -- "$tldr_update_stamp"
        fi
        rmdir -- "$tldr_update_lock"
      ) &!
    fi
  fi

  tldr_completion="$(command tldr --print-completion zsh 2>/dev/null)" &&
    eval "$tldr_completion"
  unset tldr_cache_dir tldr_update_stamp tldr_update_lock tldr_completion
fi
