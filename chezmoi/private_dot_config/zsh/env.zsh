# =============================================================================
# Module: env.zsh
# Purpose: Configure environment-level shell variables.
# =============================================================================

# Shared fzf UI options reused by custom widgets and fzf-based plugins.
# Keep this list limited to broadly compatible display/layout settings so it can
# be safely reused in more than one place.
typeset -ga FZF_UI_OPTS
FZF_UI_OPTS=(
  --height=40%
  --layout=reverse
  --border
)

# Also expose the same base options to standalone `fzf` invocations.
# Keep this as a plain space-joined string; shell-escaped quoting here would be
# passed through literally and confuse fzf option parsing.
typeset -gx FZF_DEFAULT_OPTS="${(j: :)FZF_UI_OPTS}"

# Ensure user-local executables are discoverable in zsh sessions.
path=("$HOME/bin" "$HOME/.local/bin" $path)
export PATH

# Make LM Studio CLI (`lms`) available without typing its full path.
# Appending keeps system and user-local commands earlier in PATH taking priority.
path+=("$HOME/.lmstudio/bin")
export PATH


# Make pyenv work
export PYENV_ROOT="$HOME/.pyenv"
  [[ -d $PYENV_ROOT/bin ]] && path=("$PYENV_ROOT/bin" $path)
  eval "$(pyenv init - zsh)"

