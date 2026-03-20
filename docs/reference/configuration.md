## Configuration Reference

### Top-level option

| Option | Effect |
| --- | --- |
| `@theme` | Selects the active theme. Built-ins include `catppuccin-latte`, `catppuccin-frappe`, `catppuccin-macchiato`, `catppuccin-mocha`, `bearded-arc`, `everforest`, `everforest_light`, `gruvchad`, `one_light`, `rosepine`, and `tundra`. |
| `@theme_switch_key` | Prefix key used to open the theme switcher menu. Set it to `""` to disable the binding. |

External themes live in `~/.config/tmux/theme/<name>.conf`. External files win over built-ins with the same name.
The theme switcher persists the last selected theme in `~/.config/tmux/theme/current_theme.conf`; that file is read before `@theme` on startup.

### Status line

| Option | Effect |
| --- | --- |
| `@theme_status_background` | Background for the status line. |

- `default` uses the active theme background
- `none` makes the bar transparent
- any other value can be a hex color or a tmux format such as `#{@thm_surface_0}`

### Window style

| Option | Effect |
| --- | --- |
| `basic` | Simple blocks |
| `rounded` | Rounded separators |
| `slanted` | Slanted separators |
| `custom` | Use your own separators |
| `none` | Disable the plugin's window styling |

```bash
set -g @theme_window_status_style "custom"
set -g @theme_window_left_separator ""
set -g @theme_window_middle_separator ""
set -g @theme_window_right_separator ""
```

### Defaults

```bash
set -g @theme "everforest"
set -g @theme_switch_key "T"

set -g @theme_menu_selected_style "fg=#{@thm_fg},bold,bg=#{@thm_overlay_0}"

set -g @theme_pane_status_enabled "no"
set -g @theme_pane_border_status "off"
set -g @theme_pane_border_style "fg=#{@thm_overlay_0}"
set -g @theme_pane_active_border_style "##{?pane_in_mode,fg=#{@thm_lavender},##{?pane_synchronized,fg=#{@thm_mauve},fg=#{@thm_lavender}}}"
set -g @theme_pane_left_separator "█"
set -g @theme_pane_middle_separator "█"
set -g @theme_pane_right_separator "█"
set -g @theme_pane_color "#{@thm_green}"
set -g @theme_pane_background_color "#{@thm_surface_0}"
set -g @theme_pane_default_text "##{b:pane_current_path}"
set -g @theme_pane_default_fill "number"
set -g @theme_pane_number_position "left"

set -g @theme_window_status_style "basic"
set -g @theme_window_text_color "#{@thm_surface_0}"
set -g @theme_window_number_color "#{@thm_overlay_2}"
set -g @theme_window_text " #T"
set -g @theme_window_number "#I"
set -g @theme_window_current_text_color "#{@thm_surface_1}"
set -g @theme_window_current_number_color "#{@thm_mauve}"
set -g @theme_window_current_text " #T"
set -g @theme_window_current_number "#I"
set -g @theme_window_number_position "left"
set -g @theme_window_flags "none"
set -g @theme_window_flags_icon_last " 󰖰"
set -g @theme_window_flags_icon_current " 󰖯"
set -g @theme_window_flags_icon_zoom " 󰁌"
set -g @theme_window_flags_icon_mark " 󰃀"
set -g @theme_window_flags_icon_silent " 󰂛"
set -g @theme_window_flags_icon_activity " 󱅫"
set -g @theme_window_flags_icon_bell " 󰂞"
set -g @theme_window_flags_icon_format "##{?window_activity_flag,#{E:@theme_window_flags_icon_activity},}##{?window_bell_flag,#{E:@theme_window_flags_icon_bell},}##{?window_silence_flag,#{E:@theme_window_flags_icon_silent},}##{?window_active,#{E:@theme_window_flags_icon_current},}##{?window_last_flag,#{E:@theme_window_flags_icon_last},}##{?window_marked_flag,#{E:@theme_window_flags_icon_mark},}##{?window_zoomed_flag,#{E:@theme_window_flags_icon_zoom},} "

set -g @theme_status_left_separator ""
set -g @theme_status_middle_separator ""
set -g @theme_status_right_separator " "
set -g @theme_status_connect_separator "yes"
set -g @theme_status_module_text_bg "#{@thm_surface_0}"
```
