# =============================================================================
# Module: scripts.zsh
# Purpose: Load selected startup scripts from $ZDOTDIR/scripts.
# =============================================================================

# Only run these helper scripts for interactive shells.
[[ $- != *i* ]] && return

# Add or remove names here to control which startup scripts load.
for script in \
  neofetch
do
  # shellcheck disable=SC1090
  source "$ZDOTDIR/scripts/$script.zsh"
done
