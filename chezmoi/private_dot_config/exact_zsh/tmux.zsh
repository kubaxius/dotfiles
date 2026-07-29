# =============================================================================
# Module: tmux.zsh
# Purpose: Enter the shared local tmux session for each new terminal.
# =============================================================================

# Reuse the main session, but allow a normal Kitty window via `bare-kitty`.
# Do not nest tmux sessions or change the behaviour of remote SSH shells.
if (( $+commands[tmux] )) && [[ -o interactive && -z $TMUX && -z $SSH_CONNECTION && -z $DISABLE_TMUX_AUTOSTART ]]; then
  exec tmux new-session -A -s main
fi
