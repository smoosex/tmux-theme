#!/usr/bin/env bash

PLUGIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEFAULT_THEME="everforest"

tmux source "${PLUGIN_DIR}/theme_options_tmux.conf"

theme_name="$(tmux show-options -gqv "@theme")"
if [[ -z "${theme_name}" ]]; then
  theme_name="${DEFAULT_THEME}"
fi

external_theme="${HOME}/.config/tmux/theme/${theme_name}.conf"
builtin_theme="${PLUGIN_DIR}/themes/${theme_name}.conf"
fallback_theme="${PLUGIN_DIR}/themes/${DEFAULT_THEME}.conf"

resolved_theme="${theme_name}"
resolved_file="${builtin_theme}"

if [[ -f "${external_theme}" ]]; then
  resolved_file="${external_theme}"
elif [[ -f "${builtin_theme}" ]]; then
  resolved_file="${builtin_theme}"
else
  resolved_theme="${DEFAULT_THEME}"
  resolved_file="${fallback_theme}"
  tmux display-message "tmux-theme: theme '${theme_name}' not found, using '${DEFAULT_THEME}'"
fi

tmux set -gq "@_theme_name" "${resolved_theme}"
tmux set -gq "@_theme_file" "${resolved_file}"
tmux source "${resolved_file}"
tmux source "${PLUGIN_DIR}/theme_tmux.conf"
