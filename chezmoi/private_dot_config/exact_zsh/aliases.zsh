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

alias source-py="source .venv/bin/activate"
alias unsource="deactivate"
alias zsh-restart="clear; exec zsh"
alias i="paru -S"
# kitty without the tmux
alias bare-kitty='kitty env DISABLE_TMUX_AUTOSTART=1 zsh -l'
