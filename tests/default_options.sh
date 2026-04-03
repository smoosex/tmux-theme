#!/usr/bin/env bash

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)
# shellcheck disable=SC1091
source "${script_dir}/helpers.sh"

source "${script_dir}/../theme.tmux"

print_option @theme
print_option @theme_switch_key
print_option @theme_menu_selected_style
print_option @theme_pane_active_border_style
printf "\npersisted-theme "
sed -n '1p' "${HOME}/.config/tmux/theme/current_theme.conf"
