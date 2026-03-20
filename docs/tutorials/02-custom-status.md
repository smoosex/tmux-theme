# User Defined Status Line Modules

You can append raw tmux segments directly:

```sh
set -agF status-right "#[fg=#{@thm_crust},bg=#{@thm_teal}] ##H "
```

Or build a module with the same structure as the built-in modules:

```sh
%hidden MODULE_NAME="my_custom_module"

set -g "@theme_${MODULE_NAME}_icon" " "
set -gF "@theme_${MODULE_NAME}_color" "#{E:@thm_pink}"
set -g "@theme_${MODULE_NAME}_text" "#{pane_current_command}"

source "~/.config/tmux/plugins/tmux-theme/utils/status_module.conf"

set -g status-right "#{E:@theme_status_application}#{E:@theme_status_my_custom_module}"
```

Load `theme.tmux` before using the helper so the theme colors and module defaults already exist.
