#!/usr/bin/env bash

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)
# shellcheck disable=SC1091
source "${script_dir}/helpers.sh"

original_home=$HOME
temp_home=$(mktemp -d)
trap 'rm -rf "${temp_home}"; HOME="${original_home}"' EXIT

mkdir -p "${temp_home}/.config/tmux/theme"
cp "${script_dir}/../themes/rosepine.conf" "${temp_home}/.config/tmux/theme/rosepine.conf"
sed -i '' 's/set -gq @thm_bg "#191724"/set -gq @thm_bg "#010203"/' "${temp_home}/.config/tmux/theme/rosepine.conf"

HOME="${temp_home}"
tmux set -g @theme "rosepine"
source "${script_dir}/../theme.tmux"
print_option @_theme_name
print_option @thm_bg

HOME="${original_home}"
tmux set -g @theme "one_light"
source "${script_dir}/../theme.tmux"
print_option @_theme_name
print_option @thm_bg
print_option @thm_fg

tmux set -g @theme "missing-theme"
source "${script_dir}/../theme.tmux"
print_option @_theme_name
print_option @thm_bg
