#!/usr/bin/env bash

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)
# shellcheck disable=SC1091
source "${script_dir}/helpers.sh"

source "${script_dir}/../theme.tmux"

print_option @theme_status_application | grep -q "@thm_" &&
  echo "@theme_status_application did not expand all colors"

print_option @theme_status_application | sed -E 's/(bash|fish|zsh)/<application>/'
