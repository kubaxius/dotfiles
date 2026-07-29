# =============================================================================
# Module: options.zsh
# Purpose: Configure general interactive shell options.
# =============================================================================

# Enable useful general shell behavior.
# - autocd: typing a directory name by itself changes into it.
# - beep: ring the terminal bell for certain invalid edits/completion errors.
# - extendedglob: enable more powerful glob patterns and qualifiers.
# - nomatch: raise an error when a glob pattern matches nothing instead of
#   passing the literal pattern through to the command.
# - notify: report completed background jobs immediately instead of waiting for
#   the next prompt.
setopt autocd beep extendedglob nomatch notify
