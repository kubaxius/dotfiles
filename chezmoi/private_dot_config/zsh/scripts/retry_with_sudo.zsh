#!/bin/zsh

# Offer to retry failed commands with sudo in interactive shells.
#
# This is intentionally conservative: zsh cannot reliably know that every
# non-zero exit was caused by missing privileges, because most programs print
# their own error messages directly. Instead, this hook watches failed commands,
# skips obviously unsafe/noisy cases, warns first, and only reruns after an
# explicit confirmation. `sudo` will then ask for the password as usual.
if [[ $- == *i* ]]; then
  __sudo_retry_last_command=""
  __sudo_retry_running=0

  function __sudo_retry_preexec() {
    __sudo_retry_last_command="$1"
  }

  function __sudo_retry_precmd() {
    local exit_status=$?
    local command="$__sudo_retry_last_command"

    [[ -n "$command" ]] || return 0
    (( exit_status != 0 )) || return 0
    (( __sudo_retry_running == 0 )) || return 0

    # Avoid retrying commands that are already privileged, purely shell-local,
    # interactive, destructive in surprising ways, or likely to recurse/noise.
    case "$command" in
      sudo\ *|doas\ *|su\ *|ssh\ *|scp\ *|sftp\ *|man\ *|less\ *|more\ *|vim\ *|nvim\ *|nano\ *|emacs\ *|cd\ *|source\ *|\.\ *|exit|logout|fg|bg|jobs|history|zsh-restart)
        return 0
        ;;
    esac

    printf '\033[33mwarning:\033[0m command exited with status %d. Retry with sudo? [y/N] ' "$exit_status" > /dev/tty

    local reply
    read -r reply < /dev/tty || return 0
    [[ "$reply" == [yY] || "$reply" == [yY][eE][sS] ]] || return 0

    __sudo_retry_running=1
    print -r -- "+ sudo $command"
    eval "sudo $command"
    __sudo_retry_running=0
  }

  autoload -Uz add-zsh-hook
  add-zsh-hook preexec __sudo_retry_preexec
  add-zsh-hook precmd __sudo_retry_precmd
fi