#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

repo_root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
# shellcheck source=/dev/null
source "$repo_root/chezmoi/dot_local/bin/executable_zsh-history-fzf"

test_directory=$(mktemp -d)
trap 'rm -rf -- "$test_directory"' EXIT
history_file="$test_directory/history"

read -r -d '' fixture <<'EOF' || true
: 100:0;echo first
: 101:2;printf 'one\ntwo'
: 102:0;python - <<'PY'\
print("one")\
: 999:0;still part of the command\
\
print("two\\")\
PY
: 103:0;echo first
: 104:7;printf 'tab\tvalue'
: 105:0;
EOF
printf '%s\n' "$fixture" > "$history_file"

parse_history "$history_file"
[[ ${#HISTORY_COMMAND[@]} == 6 ]]
[[ ${HISTORY_COMMAND[0]} == 'echo first' ]]
[[ ${HISTORY_COMMAND[1]} == "printf 'one\\ntwo'" ]]
read -r -d '' multiline_command <<'EOF' || true
python - <<'PY'
print("one")
: 999:0;still part of the command

print("two\\")
PY
EOF
[[ ${HISTORY_COMMAND[2]} == "$multiline_command" ]]
[[ ${HISTORY_COMMAND[4]} == "printf 'tab\\tvalue'" ]]
[[ -z ${HISTORY_COMMAND[5]} ]]

candidate_file="$test_directory/candidates"
write_candidates "$candidate_file"
mapfile -d '' -t candidates < "$candidate_file"
[[ ${#candidates[@]} == 4 ]]
[[ ${candidates[0]} == $'4\t'"printf 'tab\\tvalue'" ]]
[[ ${candidates[1]} == $'3\techo first' ]]

# --with-nth hides the internal index and also makes the displayed command the
# searchable text. Adding --nth=2.. here would search a nonexistent field.
filtered_file="$test_directory/filtered"
fzf --read0 --print0 --filter='tab' --delimiter=$'\t' --with-nth='2..' \
  < "$candidate_file" > "$filtered_file"
mapfile -d '' -t filtered < "$filtered_file"
[[ ${#filtered[@]} == 1 ]]
[[ ${filtered[0]} == $'4\t'"printf 'tab\\tvalue'" ]]

delete_commands "$history_file" 3
parse_history "$history_file"
[[ ${#HISTORY_COMMAND[@]} == 4 ]]
[[ ${HISTORY_COMMAND[0]} == "printf 'one\\ntwo'" ]]
[[ ${HISTORY_COMMAND[1]} == "$multiline_command" ]]
[[ ${HISTORY_COMMAND[2]} == "printf 'tab\\tvalue'" ]]
[[ -z ${HISTORY_COMMAND[3]} ]]

printf 'zsh-history-fzf tests passed\n'
