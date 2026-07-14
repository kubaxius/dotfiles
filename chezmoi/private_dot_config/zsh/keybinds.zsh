# =============================================================================
# Module: keybinds.zsh
# Purpose: Configure command-line editor key bindings for the interactive shell.
# =============================================================================

# Use Emacs-style key bindings in the command line editor (instead of Vi-style).
bindkey -e

# If fzf is installed, replace the default Ctrl+R reverse search with a fuzzy
# history picker that shows many matches at once and lets you narrow them down
# interactively.
if command -v fzf >/dev/null 2>&1; then
  fzf-history-widget() {
    local selected

    selected=$(
      fc -rl 1 |
        sed 's/^[[:space:]]*[0-9]\+[[:space:]]*//' |
        awk '!seen[$0]++' |
        fzf \
          ${FZF_UI_OPTS[@]} \
          --prompt='History> ' \
          --query="$LBUFFER" \
          --scheme=history
    ) || return

    BUFFER="$selected"
    CURSOR=$#BUFFER
    zle reset-prompt
  }
  zle -N fzf-history-widget
  bindkey '^R' fzf-history-widget
fi

# Make common navigation/editing keys work across terminal emulators.
# Prefer the terminal's terminfo entries, then add widely used fallbacks.
for seq in "${terminfo[khome]}" '^[[H' '^[OH'; do
  [[ -n "$seq" ]] && bindkey "$seq" beginning-of-line
done

for seq in "${terminfo[kend]}" '^[[F' '^[OF'; do
  [[ -n "$seq" ]] && bindkey "$seq" end-of-line
done

for seq in "${terminfo[kdch1]}" '^[[3~'; do
  [[ -n "$seq" ]] && bindkey "$seq" delete-char
done

# Use Up/Down for plain line/history navigation. History search is handled by
# Ctrl+R above, which avoids multiline history entries interfering with prefix
# search state during normal arrow-key navigation.
for seq in "${terminfo[kcuu1]}" '^[[A' '^[OA'; do
  [[ -n "$seq" ]] && bindkey "$seq" up-line-or-history
done

for seq in "${terminfo[kcud1]}" '^[[B' '^[OB'; do
  [[ -n "$seq" ]] && bindkey "$seq" down-line-or-history
done

# Move by whole words when the terminal sends Ctrl+Arrow escape sequences.
# Different emulators use different codes, so bind a few common variants.
for seq in "${terminfo[kLFT5]}" '^[[1;5D' '^[[5D'; do
  [[ -n "$seq" ]] && bindkey "$seq" backward-word
done

for seq in "${terminfo[kRIT5]}" '^[[1;5C' '^[[5C'; do
  [[ -n "$seq" ]] && bindkey "$seq" forward-word
done

# Delete the next word when the terminal sends Ctrl+Delete.
# Ctrl+Delete is not standardized, so cover the most common sequences.
for seq in '^[[3;5~' '^[[3^' '^[[3;5u'; do
  [[ -n "$seq" ]] && bindkey "$seq" kill-word
done

# Delete the previous word when the terminal distinguishes Ctrl+Backspace from
# plain Backspace. We intentionally avoid binding '^H' or '^?' directly because
# many terminals use those for normal Backspace.
for seq in '^[[127;5u' '^[^H' '^[^?'; do
  [[ -n "$seq" ]] && bindkey "$seq" backward-kill-word
done

# Konsole commonly sends Ctrl+Backspace as ^H while plain Backspace remains ^?
# (per terminfo). In that case, ^H is safe to treat as word-delete.
if [[ "${terminfo[kbs]}" != $'^H' ]]; then
  bindkey '^H' backward-kill-word
fi
