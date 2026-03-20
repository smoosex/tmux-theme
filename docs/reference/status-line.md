## Built-in Status Modules

The plugin exposes status segments as tmux options named `@theme_status_<module>`.

```sh
set -g status-left ""
set -g status-right "#{E:@theme_status_application}#{E:@theme_status_session}"
```

## Per-module overrides

```sh
set -g @theme_[module_name]_icon "icon"
set -g @theme_[module_name]_color "color"
set -g @theme_[module_name]_text "text"
set -g @theme_status_[module_name]_text_bg "#{@thm_surface_0}"
set -g @theme_status_[module_name]_text_fg "#{@thm_fg}"
```

To remove a value, set it to an empty string:

```sh
set -g @theme_date_time_icon ""
```

## Load order

Load `theme.tmux` before composing `status-left` or `status-right`.

```bash
run '~/.config/tmux/plugins/tmux-theme/theme.tmux'

set -g status-left "#{E:@theme_status_session}"
set -g status-right "#{E:@theme_status_cpu}"
```

## Module examples

### Battery

```sh
run ~/.config/tmux/plugins/tmux-theme/theme.tmux
set -agF status-right "#{E:@theme_status_battery}"
```

### CPU

```sh
run ~/.config/tmux/plugins/tmux-theme/theme.tmux
set -agF status-right "#{E:@theme_status_cpu}"
```

### Weather

```sh
run ~/.config/tmux/plugins/tmux-theme/theme.tmux
set -agF status-right "#{E:@theme_status_weather}"
```

### Clima

```sh
run ~/.config/tmux/plugins/tmux-theme/theme.tmux
set -agF status-right "#{E:@theme_status_clima}"
```

### Load

```sh
run ~/.config/tmux/plugins/tmux-theme/theme.tmux
set -agF status-right "#{E:@theme_status_load}"
```

### Gitmux

```sh
run ~/.config/tmux/plugins/tmux-theme/theme.tmux
set -agF status-right "#{@theme_status_gitmux}"
```

Sample `~/.gitmux.conf` colors:

```yaml
tmux:
  styles:
    clear: "#[fg=#{@thm_fg}]"
    state: "#[fg=#{@thm_red},bold]"
    branch: "#[fg=#{@thm_fg},bold]"
    remote: "#[fg=#{@thm_teal}]"
    divergence: "#[fg=#{@thm_fg}]"
    staged: "#[fg=#{@thm_green},bold]"
    conflict: "#[fg=#{@thm_red},bold]"
    modified: "#[fg=#{@thm_yellow},bold]"
    untracked: "#[fg=#{@thm_mauve},bold]"
    stashed: "#[fg=#{@thm_blue},bold]"
    clean: "#[fg=#{@thm_rosewater},bold]"
    insertions: "#[fg=#{@thm_green}]"
    deletions: "#[fg=#{@thm_red}]"
```

### Pomodoro Plus

```sh
run ~/.config/tmux/plugins/tmux-theme/theme.tmux
set -agF status-right "#{E:@theme_status_pomodoro_plus}"
```

### Kube

```sh
set -g @theme_kube_context_color "#{@thm_red}"
set -g @theme_kube_namespace_color "#{@thm_sky}"

run ~/.config/tmux/plugins/tmux-theme/theme.tmux
set -agF status-right "#{E:@theme_status_kube}"
```
