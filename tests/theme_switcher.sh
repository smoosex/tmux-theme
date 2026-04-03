#!/usr/bin/env bash

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)
plugin_dir=$(cd "${script_dir}/.." &>/dev/null && pwd -P)
# shellcheck disable=SC1091
source "${script_dir}/helpers.sh"

mkdir -p "${HOME}/.config/tmux/theme"
cp "${script_dir}/../themes/rosepine.conf" "${HOME}/.config/tmux/theme/rosepine.conf"
sed -i '' 's/set -gq @thm_bg "#191724"/set -gq @thm_bg "#010203"/' "${HOME}/.config/tmux/theme/rosepine.conf"
cat > "${HOME}/.config/tmux/tmux.conf" <<EOF
source-file ${HOME}/.config/tmux/theme/current_theme.conf
run ${plugin_dir}/theme.tmux
EOF

source "${script_dir}/../theme.tmux"

print_option @theme_switch_key
tmux list-keys -T prefix | grep -F 'theme_menu.sh' | sed -E "s#${plugin_dir}#<plugin>#"
HOME="${HOME}" "${plugin_dir}/scripts/theme_menu.sh" command rosepine | sed -E "s#${plugin_dir}#<plugin>#"
HOME="${HOME}" "${plugin_dir}/scripts/theme_menu.sh" popup-text "tmux-theme: switched to 'rosepine'"
TMUX_THEME_SOCKET_NAME="${SOCKET_NAME}" HOME="${HOME}" "${plugin_dir}/scripts/theme_menu.sh" list | grep -E '^(everforest|one_light|rosepine)\t' | sed 's/\t/ /g'
TMUX_THEME_SOCKET_NAME="${SOCKET_NAME}" HOME="${HOME}" "${plugin_dir}/scripts/theme_menu.sh" switch rosepine
printf "persisted-theme "
sed -n '1p' "${HOME}/.config/tmux/theme/current_theme.conf"
print_option @theme
print_option @_theme_name
print_option @thm_bg

tmux set -g @theme "everforest"
source "${script_dir}/../theme.tmux"
print_option @theme
print_option @_theme_name
print_option @thm_bg

tmux kill-server
TMUX_THEME_SOCKET_NAME="${SOCKET_NAME}" HOME="${HOME}" "${plugin_dir}/scripts/theme_menu.sh" switch one_light
printf "persisted-theme-no-server "
sed -n '1p' "${HOME}/.config/tmux/theme/current_theme.conf"
