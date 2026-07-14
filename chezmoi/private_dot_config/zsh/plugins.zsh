# =============================================================================
# Module: plugins.zsh
# Purpose: Load or configure external zsh plugins and related integrations.
# =============================================================================

# -----------------------------------------------------------------------------
# Plugin manager: Zinit
# Repo: https://github.com/zdharma-continuum/zinit
# Purpose: Install and load the plugin manager used by the rest of this file.
# -----------------------------------------------------------------------------
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# This is here because we loaded compinit before loading zinit.
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit


# -----------------------------------------------------------------------------
# Plugin: zsh-completions
# Repo: https://github.com/zsh-users/zsh-completions
# Purpose: Provide additional completion definitions.
# zinit ice wait lucid
# -----------------------------------------------------------------------------
zinit light zsh-users/zsh-completions


# -----------------------------------------------------------------------------
# Plugin: zsh-autosuggestions
# Repo: https://github.com/zsh-users/zsh-autosuggestions
# Purpose: Show fish-style command suggestions while typing.
# zinit ice wait lucid
# -----------------------------------------------------------------------------
ZSH_AUTOSUGGEST_STRATEGY=(match_prev_cmd history completion)

zinit light zsh-users/zsh-autosuggestions


# -----------------------------------------------------------------------------
# Plugin: spaceship-prompt
# Repo: https://github.com/spaceship-prompt/spaceship-prompt
# Purpose: Provide the active prompt theme.
# Alternative: https://github.com/romkatv/powerlevel10k
# zinit ice depth=1
# -----------------------------------------------------------------------------
zinit light spaceship-prompt/spaceship-prompt


# -----------------------------------------------------------------------------
# Plugin: fzf-tab
# Repo: https://github.com/Aloxaf/fzf-tab
# Purpose: Show an interactive tab-completion list.
# zinit ice wait lucid
# -----------------------------------------------------------------------------
zinit light Aloxaf/fzf-tab

# Reuse the shared base fzf UI options for fzf-tab. We pass them explicitly via
# `fzf-flags` instead of enabling `use-fzf-default-opts`, because the plugin's
# docs warn that some global fzf flags can break completion behavior.
zstyle ':fzf-tab:*' fzf-flags ${FZF_UI_OPTS[@]}


# -----------------------------------------------------------------------------
# Tool: zoxide
# Repo: https://github.com/ajeetdsouza/zoxide
# Purpose: Enable smarter directory jumping using the installed `zoxide`
#          binary.
# -----------------------------------------------------------------------------
if [[ $- == *i* ]] && command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi


# -----------------------------------------------------------------------------
# Plugin: zsh-vi-mode
# Repo: https://github.com/jeffreytse/zsh-vi-mode
# Purpose: Optional vi-style keybindings for zsh.
# Settings: Uncomment and edit the lines below when you want to enable it.
# -----------------------------------------------------------------------------
# zinit ice depth=1
# zinit light jeffreytse/zsh-vi-mode


# -----------------------------------------------------------------------------
# Plugin: zsh-syntax-highlighting
# Repo: https://github.com/zsh-users/zsh-syntax-highlighting
# Purpose: Add syntax highlighting to the command line.
# Settings: Add any `zinit ice ...` lines here, but keep this plugin loading
#           last.
# zinit ice wait lucid
# -----------------------------------------------------------------------------
zinit light zsh-users/zsh-syntax-highlighting