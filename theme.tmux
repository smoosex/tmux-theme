#!/usr/bin/env bash

set -Eeuo pipefail

PLUGIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEFAULT_THEME="everforest"
PERSISTED_THEME_FILE="${HOME}/.config/tmux/theme/current_theme.conf"

tmux_cmd() {
  if declare -F tmux >/dev/null && [[ -z "${TMUX_THEME_SOCKET_NAME:-}" ]]; then
    tmux "$@"
    return
  fi

  if [[ -n "${TMUX_THEME_SOCKET_NAME:-}" ]]; then
    command tmux -L "${TMUX_THEME_SOCKET_NAME}" -f /dev/null "$@"
    return
  fi

  command tmux "$@"
}

tmux_cmd source-file "${PLUGIN_DIR}/theme_options_tmux.conf"

persisted_theme=""
if [[ -f "${PERSISTED_THEME_FILE}" ]]; then
  persisted_theme="$(sed -n '1p' "${PERSISTED_THEME_FILE}" | tr -d '\r')"
fi

theme_name="${persisted_theme}"
if [[ -z "${theme_name}" ]]; then
  theme_name="$(tmux_cmd show-options -gqv "@theme")"
fi
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
  tmux_cmd display-message "tmux-theme: theme '${theme_name}' not found, using '${DEFAULT_THEME}'"
fi

previous_switch_key="$(tmux_cmd show-options -gqv "@_theme_switch_key")"
theme_switch_key="$(tmux_cmd show-options -gqv "@theme_switch_key")"

if [[ -n "${previous_switch_key}" ]] && [[ "${previous_switch_key}" != "${theme_switch_key}" ]]; then
  tmux_cmd unbind-key "${previous_switch_key}" 2>/dev/null || true
fi

if [[ -n "${theme_switch_key}" ]]; then
  tmux_cmd bind-key "${theme_switch_key}" run-shell "\"${PLUGIN_DIR}/scripts/theme_menu.sh\" open"
fi

tmux_cmd set -gq "@_theme_switch_key" "${theme_switch_key}"
tmux_cmd set -gq "@_theme_name" "${resolved_theme}"
tmux_cmd set -gq "@_theme_file" "${resolved_file}"
tmux_cmd source-file "${resolved_file}"
tmux_cmd source-file "${PLUGIN_DIR}/theme_tmux.conf"
