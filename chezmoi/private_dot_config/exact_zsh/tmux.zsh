# =============================================================================
# Module: tmux.zsh
# Purpose: Enter the shared local tmux session for each new terminal.
# =============================================================================

# Create the main session, or use it as a template for an independent client.
# Allow a normal terminal window via `bare-terminal`.
# Do not nest tmux sessions or change the behaviour of remote SSH shells.
if (( $+commands[tmux] )) && [[ -o interactive && -z $TMUX && -z $SSH_CONNECTION && -z $DISABLE_TMUX_AUTOSTART ]]; then
  tmux_config="${XDG_CONFIG_HOME:-$HOME/.config}/tmux/tmux.conf"

  if tmux -f "$tmux_config" has-session -t main 2>/dev/null; then
    exec tmux -f "$tmux_config" new-session -t main
  else
    exec tmux -f "$tmux_config" new-session -s main
  fi
fi
