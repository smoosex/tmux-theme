#!/usr/bin/env bash

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)
# shellcheck disable=SC1091
source "${script_dir}/helpers.sh"

tmux set -g @theme_pane_status_enabled "yes"

source "${script_dir}/../theme.tmux"

print_option pane-border-format

# Switch the number position to the right
tmux set -g @theme_pane_number_position "right"
source "${script_dir}/../theme.tmux"
print_option pane-border-format

tmux set -g @theme_pane_number_position "left" # reset

# Fill option "all"
tmux set -g @theme_pane_default_fill "all"
source "${script_dir}/../theme.tmux"
print_option pane-border-format

tmux set -g @theme_pane_default_fill "number" # reset

# Fill option "none"
tmux set -g @theme_pane_default_fill "none"
source "${script_dir}/../theme.tmux"
print_option pane-border-format
