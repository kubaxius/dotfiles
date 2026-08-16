# =============================================================================
# Module: aliases.zsh
# Purpose: Define reusable command aliases for common shell shortcuts.
# =============================================================================

# Route interactive `cd` through zoxide once its functions are available.
# Fallback to the builtin if zoxide is not loaded yet for any reason.
if [[ $- == *i* ]]; then
  function cd() {
    if (( $+functions[__zoxide_z] )); then
      __zoxide_z "$@"
    else
      builtin cd -- "$@"
    fi
  }
fi

# ZSH #
alias zsh-restart="clear; exec zsh"
alias sudo='sudo ' # this makes aliases work for sudo


# PYTHON #
alias source-py="source .venv/bin/activate"
alias unsource="deactivate"

# PACKAGE MANAGEMENT #
alias i="paru -S" # install
alias is="paru --color always -S --interactive" # search and install
alias ui="paru -R" # uninstall
alias uif="paru -Rns" # uninstall full (settings, dependencies)
alias update="paru -Syu" # update all

# FILE MANAGEMENT #
alias tp="trash-put"
alias rmr="rm -rI" # remove recursively, but ask

# Create files and directories in one command.
# A trailing slash means “directory”; otherwise, “file”.
mk() {
  local target

  for target in "$@"; do
    if [[ "$target" == */ ]]; then
      mkdir -p -- "$target"
    else
      mkdir -p -- "${target:h}"
      touch -- "$target"
    fi
  done
}


alias lsl='ls -lhA --color=auto' # table, human-readable and all files
alias ls='ls --color=auto' # make ls colored
alias l='eza --icons=auto --group-directories-first' # simple list with icons, dirs first
alias ll='eza -lah --icons=auto --group-directories-first --git --header' # table, all files, human readable, icons dirs first
alias lt='eza --tree --level=2 --icons=auto --group-directories-first' # directory tree

# kitty without the tmux
alias bare-terminal='terminal env DISABLE_TMUX_AUTOSTART=1 zsh -l'
