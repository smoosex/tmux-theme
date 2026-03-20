#!/usr/bin/env bash

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
DEFAULT_THEME="everforest"
PERSISTED_THEME_FILE="${HOME}/.config/tmux/theme/current_theme.conf"

tmux_cmd() {
  if [[ -n "${TMUX_THEME_SOCKET_NAME:-}" ]]; then
    command tmux -L "${TMUX_THEME_SOCKET_NAME}" -f /dev/null "$@"
    return
  fi

  command tmux "$@"
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

  name="$(tmux_cmd show-options -gqv "@_theme_name")"
  if [[ -z "${name}" ]]; then
    name="$(tmux_cmd show-options -gqv "@theme")"
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
  local theme_name persisted_dir

  theme_name="${1:?missing theme name}"
  persisted_dir="$(dirname "${PERSISTED_THEME_FILE}")"
  mkdir -p "${persisted_dir}"
  printf '%s\n' "${theme_name}" > "${PERSISTED_THEME_FILE}"
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
  tmux_cmd set -gq @theme "${theme_name}"
  TMUX_THEME_SOCKET_NAME="${TMUX_THEME_SOCKET_NAME:-}" "${PLUGIN_DIR}/theme.tmux"
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
