#!/usr/bin/env bash

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)
plugin_dir=$(cd "${script_dir}/.." &>/dev/null && pwd -P)
# shellcheck disable=SC1091
source "${script_dir}/helpers.sh"

original_home=$HOME
temp_home=$(mktemp -d)
trap 'rm -rf "${temp_home}"; HOME="${original_home}"' EXIT

mkdir -p "${temp_home}/.config/tmux/theme"
cp "${script_dir}/../themes/rosepine.conf" "${temp_home}/.config/tmux/theme/rosepine.conf"
sed -i '' 's/set -gq @thm_bg "#191724"/set -gq @thm_bg "#010203"/' "${temp_home}/.config/tmux/theme/rosepine.conf"

HOME="${temp_home}"
source "${script_dir}/../theme.tmux"

print_option @theme_switch_key
tmux list-keys -T prefix | grep -F 'theme_menu.sh' | sed -E "s#${plugin_dir}#<plugin>#"
HOME="${temp_home}" "${plugin_dir}/scripts/theme_menu.sh" command rosepine | sed -E "s#${plugin_dir}#<plugin>#"
TMUX_THEME_SOCKET_NAME="${SOCKET_NAME}" HOME="${temp_home}" "${plugin_dir}/scripts/theme_menu.sh" list | grep -E '^(everforest|one_light|rosepine)\t' | sed 's/\t/ /g'
TMUX_THEME_SOCKET_NAME="${SOCKET_NAME}" HOME="${temp_home}" "${plugin_dir}/scripts/theme_menu.sh" switch rosepine
print_option @theme
print_option @_theme_name
print_option @thm_bg
