#!/usr/bin/env bash

# Unsets (removes) any styling options that will contaminate
# subsequent test runs.
function reset() {
  tmux set -gu @theme_window_current_left_separator
  tmux set -gu @theme_window_current_middle_separator
  tmux set -gu @theme_window_current_right_separator
  tmux set -gu @theme_window_status_style
}

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)
# shellcheck disable=SC1091
source "${script_dir}/helpers.sh"

source "${script_dir}/../theme.tmux"

print_option window-status-format
print_option window-status-current-format

# Test the rounded style
reset
tmux set -g @theme_window_status_style "rounded"
source "${script_dir}/../theme.tmux"

print_option window-status-format
print_option window-status-current-format

# Test the basic style with the number on the right
reset
tmux set -g @theme_window_number_position "right"
source "${script_dir}/../theme.tmux"

print_option window-status-format
print_option window-status-current-format
