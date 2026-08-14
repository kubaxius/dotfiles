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
alias rmr="rm -rI" # remove recursively, but ask

# kitty without the tmux
alias bare-terminal='terminal env DISABLE_TMUX_AUTOSTART=1 zsh -l'
