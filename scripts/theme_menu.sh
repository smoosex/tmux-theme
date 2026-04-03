#!/usr/bin/env bash

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
DEFAULT_THEME="everforest"

tmux_cmd() {
  if [[ -n "${TMUX_THEME_SOCKET_NAME:-}" ]]; then
    command tmux -L "${TMUX_THEME_SOCKET_NAME}" -f /dev/null "$@"
    return
  fi

  command tmux "$@"
}

default_persisted_theme_file() {
  printf '%s\n' "${HOME}/.config/tmux/theme/current_theme.conf"
}

default_reload_config_file() {
  printf '%s\n' "${HOME}/.config/tmux/tmux.conf"
}

tmux_running() {
  tmux_cmd list-sessions >/dev/null 2>&1
}

persisted_theme_file() {
  local file

  if tmux_running; then
    file="$(tmux_cmd show-options -gqv "@theme_persisted_file")"
  fi
  if [[ -z "${file:-}" ]]; then
    file="$(default_persisted_theme_file)"
  fi

  printf '%s\n' "${file}"
}

reload_config_file() {
  local file

  if tmux_running; then
    file="$(tmux_cmd show-options -gqv "@theme_reload_config_file")"
  fi
  if [[ -z "${file:-}" ]]; then
    file="$(default_reload_config_file)"
  fi

  printf '%s\n' "${file}"
}

theme_records() {
  local external_dir builtin_dir

  external_dir="${HOME}/.config/tmux/theme"
  builtin_dir="${PLUGIN_DIR}/themes"

  {
    if [[ -d "${external_dir}" ]]; then
      while IFS= read -r file; do
        file_name="$(basename "${file}")"
        printf "%s\t0\tlocal\n" "${file_name%.conf}"
      done < <(find "${external_dir}" -maxdepth 1 -type f -name "*.conf" | sort)
    fi

    while IFS= read -r file; do
      file_name="$(basename "${file}")"
      printf "%s\t1\tbuilt-in\n" "${file_name%.conf}"
    done < <(find "${builtin_dir}" -maxdepth 1 -type f -name "*.conf" | sort)
  } | sort -t $'\t' -k1,1 -k2,2n | awk -F '\t' '!seen[$1]++ { print $1 "\t" $3 }'
}

current_theme() {
  local name

  if tmux_running; then
    name="$(tmux_cmd show-options -gqv "@_theme_name")"
    if [[ -z "${name}" ]]; then
      name="$(tmux_cmd show-options -gqv "@theme")"
    fi
  fi
  if [[ -z "${name:-}" ]]; then
    name="$(sed -n "s/^set -g @theme ['\"]\\([^'\"]*\\)['\"]$/\\1/p" "$(persisted_theme_file)" 2>/dev/null | head -n 1)"
  fi
  if [[ -z "${name:-}" ]]; then
    name="$(sed -n '1p' "$(persisted_theme_file)" 2>/dev/null | tr -d '\r')"
  fi
  if [[ -z "${name}" ]]; then
    name="${DEFAULT_THEME}"
  fi

  printf "%s\n" "${name}"
}

list_themes() {
  theme_records
}

persist_theme() {
  local theme_name persisted_dir persisted_file

  theme_name="${1:?missing theme name}"
  persisted_file="$(persisted_theme_file)"
  persisted_dir="$(dirname "${persisted_file}")"
  mkdir -p "${persisted_dir}"
  printf "set -g @theme '%s'\n" "${theme_name}" > "${persisted_file}"
}

reload_tmux_config() {
  local config_file

  if ! tmux_running; then
    return
  fi

  config_file="$(reload_config_file)"
  tmux_cmd source-file "${config_file}"
}

popup_text() {
  local message

  message="${1:?missing message}"
  printf '%s\n' "${message}"
}

show_popup() {
  local message

  message="${1:?missing message}"
  if [[ -z "$(tmux_cmd list-clients 2>/dev/null)" ]]; then
    return
  fi
  tmux_cmd display-popup -E -w 44 -h 3 -x C -y C -T "tmux-theme" \
    -e "TMUX_THEME_POPUP_MESSAGE=${message}" \
    sh -c 'printf "%s\n" "$TMUX_THEME_POPUP_MESSAGE"; sleep 1'
}

switch_theme() {
  local theme_name

  theme_name="${1:?missing theme name}"
  persist_theme "${theme_name}"
  reload_tmux_config
  show_popup "$(popup_text "tmux-theme: switched to '${theme_name}'")"
}

menu_command() {
  local theme_name shell_command

  theme_name="${1:?missing theme name}"
  printf -v shell_command '%q %q %q' "${SCRIPT_DIR}/theme_menu.sh" "switch" "${theme_name}"
  printf 'run-shell "%s"\n' "${shell_command}"
}

open_menu() {
  local active_theme title label command
  local -a menu_args

  active_theme="$(current_theme)"
  title="tmux-theme: ${active_theme}"
  menu_args=()

  while IFS=$'\t' read -r theme_name theme_source; do
    label="${theme_name}"
    if [[ "${theme_name}" == "${active_theme}" ]]; then
      label="* ${label}"
    fi
    label="${label} (${theme_source})"
    command="$(menu_command "${theme_name}")"
    menu_args+=("${label}" "" "${command}")
  done < <(theme_records)

  if [[ "${#menu_args[@]}" -eq 0 ]]; then
    show_popup "$(popup_text "tmux-theme: no themes found")"
    return
  fi

  tmux_cmd display-menu -T "${title}" -x C -y C "${menu_args[@]}"
}

main() {
  local action

  action="${1:-open}"

  case "${action}" in
    open)
      open_menu
      ;;
    list)
      list_themes
      ;;
    switch)
      switch_theme "${2:-}"
      ;;
    command)
      menu_command "${2:-}"
      ;;
    popup-text)
      popup_text "${2:-}"
      ;;
    persist)
      persist_theme "${2:-}"
      ;;
    *)
      printf "Unknown action: %s\n" "${action}" >&2
      exit 1
      ;;
  esac
}

main "$@"
