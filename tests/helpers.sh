#!/usr/bin/env bash

# Returns the value of given tmux option.
# First argument is the option name, e.g. @theme.
#
# Usage: `get_option @theme`
# Would return: `everforest`
#
# The option is given as a format string.
get_option() {
  local option
  option=$1

  tmux display-message -p "#{${option}}"
}

# Prints the given tmux option to stdout.
# First argument is the option name, e.g. @theme.
#
# Usage: `print_option @theme`
# Would print: `@theme everforest`
#
# The option is given as a format string.
print_option() {
  local option
  option=$1

  printf "\n%s " "${option}"
  get_option "$option"
}
