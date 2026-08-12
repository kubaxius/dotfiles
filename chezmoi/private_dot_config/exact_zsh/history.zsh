# =============================================================================
# Module: history.zsh
# Purpose: Configure zsh command history storage, synchronization, and cleanup.
# =============================================================================

# Store command history in this file.
HISTFILE="$HOME/.local/share/zsh/history"

# Ensure the history directory and file exist before zsh tries to write them.
[[ -d "${HISTFILE:h}" ]] || mkdir -p -- "${HISTFILE:h}"
[[ -e "$HISTFILE" ]] || : >> "$HISTFILE"

# Keep up to 10,000 history entries in memory for the current shell session.
HISTSIZE=10000

# shellcheck disable=SC2034  # SAVEHIST is consumed by zsh history handling.
# Save up to 10,000 history entries to the history file on disk.
SAVEHIST=10000

# Keep history synchronized across multiple open shells.
# - appendhistory: append instead of overwriting the history file on exit.
# - inc_append_history: write each command to disk as soon as it runs.
# - sharehistory: import commands from other shells into this session.
# - extended_history: record timestamps alongside commands.
# - hist_* cleanup options: keep history tidier without reordering it in the
#   destructive ways that break autosuggestion strategies more severely.
setopt appendhistory inc_append_history sharehistory extended_history
setopt hist_ignore_dups hist_ignore_space hist_reduce_blanks hist_save_no_dups

# Let a ZLE widget suppress a command explicitly.  This complements
# HIST_IGNORE_SPACE for commands whose leading whitespace may be lost while
# editing or pasting.
typeset -gi ZSH_SKIP_NEXT_HISTORY=0

zshaddhistory() {
  # ZLE widgets can accept an empty buffer even though there is no useful
  # command to remember. Explicitly reject empty and whitespace-only entries.
  if [[ -z ${1//[[:space:]]/} ]]; then
    return 1
  fi

  if (( ZSH_SKIP_NEXT_HISTORY )); then
    ZSH_SKIP_NEXT_HISTORY=0
    return 1
  fi
  return 0
}
