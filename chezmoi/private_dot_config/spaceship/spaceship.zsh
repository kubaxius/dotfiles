# Keep the prompt intentionally minimal. Sections not listed here are disabled.
SPACESHIP_PROMPT_ORDER=(
  time
  user
  host
  dir
  git
  line_sep
  char
)

# Display time
SPACESHIP_TIME_SHOW=true
SPACESHIP_TIME_FORMAT='%D{%H:%M:%S}'
SPACESHIP_TIME_PREFIX='┌─['
SPACESHIP_TIME_SUFFIX=']'
SPACESHIP_TIME_COLOR='#FFBF00'

# Display username always
SPACESHIP_USER_SHOW=always
SPACESHIP_USER_PREFIX='─['
SPACESHIP_USER_SUFFIX=']─'
SPACESHIP_USER_COLOR='#FFBF00'
SPACESHIP_USER_COLOR_ROOT='#FFBF00'

# Display hostname always so the current PC name is visible
SPACESHIP_HOST_SHOW=always
SPACESHIP_HOST_PREFIX='─['
SPACESHIP_HOST_SUFFIX=']'
SPACESHIP_HOST_COLOR='#FFBF00'
SPACESHIP_HOST_COLOR_SSH='#FFBF00'

# Do not truncate path in repos
SPACESHIP_DIR_TRUNC_REPO=false
SPACESHIP_DIR_TRUNC=0
SPACESHIP_DIR_PREFIX='─['
SPACESHIP_DIR_SUFFIX=']'
SPACESHIP_DIR_COLOR='#FFBF00'

# Append Git details only while inside a repository.
SPACESHIP_GIT_SHOW=true
SPACESHIP_GIT_PREFIX='─['
SPACESHIP_GIT_SUFFIX=']─󰄯'
SPACESHIP_GIT_BRANCH_COLOR='#FFBF00'
SPACESHIP_GIT_STATUS_PREFIX=' '
SPACESHIP_GIT_STATUS_SUFFIX=''
SPACESHIP_GIT_STATUS_COLOR='#FFBF00'
SPACESHIP_GIT_COMMIT_COLOR='#FFBF00'

# Put the command on a second line.
SPACESHIP_PROMPT_ADD_NEWLINE=false
SPACESHIP_PROMPT_SEPARATE_LINE=true
SPACESHIP_PROMPT_FIRST_PREFIX_SHOW=true
SPACESHIP_CHAR_SYMBOL='└'
SPACESHIP_CHAR_SUFFIX=' '
SPACESHIP_CHAR_COLOR_SUCCESS='#FFBF00'
SPACESHIP_CHAR_COLOR_FAILURE='#FFBF00'
SPACESHIP_CHAR_COLOR_SECONDARY='#FFBF00'

# Render decorations in white and values in their configured color, without
# Spaceship's hard-coded bold escapes.
spaceship::section::render() {
  local section_data=("${(@s:·|·:)1}")
  local prefix="${section_data[3]}"
  local suffix="${section_data[4]}"
  local symbol="${section_data[5]}"
  local content="${section_data[6]}"

  [[ -z $content && -z $symbol ]] && return

  local result='%{%F{white}%}'

  if [[ ("$_spaceship_prompt_opened" == true || "$_spaceship_rprompt_opened" == true) &&
        "$SPACESHIP_PROMPT_PREFIXES_SHOW" == true ]]; then
    result+="$prefix"
  fi

  _spaceship_prompt_opened=true
  _spaceship_rprompt_opened=true
  result+="$symbol"
  result+="%{%F{${section_data[2]}}%}$content%{%F{white}%}"

  [[ "$SPACESHIP_PROMPT_SUFFIXES_SHOW" == true ]] && result+="$suffix"
  result+='%{%f%}'

  echo -n "$result"
}