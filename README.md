# tmux-theme

A general-purpose tmux theme plugin with built-in palettes and support for local custom themes.

<p align="center">
  <img src="./assets/tmux-theme-demo.png" alt="tmux-theme demo"/>
</p>

<p align="center">
  Demo configuration reference: <a href="https://github.com/smoosex/dotfiles">smoosex/dotfiles</a>
</p>

## Built-in themes

- `catppuccin-latte`
- `catppuccin-frappe`
- `catppuccin-macchiato`
- `catppuccin-mocha`
- `bearded-arc`
- `everforest`
- `everforest_light`
- `gruvchad`
- `one_light`
- `rosepine`
- `tundra`

The default theme is `everforest`.

## Installation

Use a Nerd Font if you want the default icons to render correctly.

### Manual

```bash
mkdir -p ~/.config/tmux/plugins/tmux-theme
git clone <repo-url> ~/.config/tmux/plugins/tmux-theme
```

Add this to `~/.tmux.conf`:

```bash
set -g @theme "everforest"
run ~/.config/tmux/plugins/tmux-theme/theme.tmux
```

### TPM

```bash
set -g @plugin '<your-user>/tmux-theme'
set -g @plugin 'tmux-plugins/tpm'

set -g @theme "rosepine"

run '~/.tmux/plugins/tpm/tpm'
```

## External themes

The plugin checks `~/.config/tmux/theme/<name>.conf` before built-in themes.

Example:

```bash
set -g @theme "my-theme"
run ~/.config/tmux/plugins/tmux-theme/theme.tmux
```

If `~/.config/tmux/theme/my-theme.conf` does not exist, the plugin tries the built-in theme with the same name and finally falls back to `everforest`.

External theme files use the same `@thm_*` variables as the built-in files in [`themes/`](/Users/smoose/Documents/Code/mine/tmux-theme/themes).

## Example configuration

```bash
set -g mouse on
set -g default-terminal "tmux-256color"

set -g @theme "catppuccin-frappe"
set -g @theme_window_status_style "rounded"

run ~/.config/tmux/plugins/tmux-theme/theme.tmux

set -g status-left ""
set -g status-right "#{E:@theme_status_application}"
set -agF status-right "#{E:@theme_status_cpu}"
set -ag status-right "#{E:@theme_status_session}"
set -ag status-right "#{E:@theme_status_uptime}"
set -agF status-right "#{E:@theme_status_battery}"
```

## Theme generation

The repository ships with [`scripts/generate_themes.py`](/Users/smoose/Documents/Code/mine/tmux-theme/scripts/generate_themes.py) for development-time imports.

- Theme names and fallback `base16`: `/Users/smoose/Documents/Code/mine/matheme/themes`
- Richer palette source: `/Users/smoose/.local/share/nvim/lazy/base46/lua/base46/themes`

It generates the repository's own `themes/*.conf` files. These source directories are not required at runtime.

## Documentation

- [Getting Started](./docs/tutorials/01-getting-started.md)
- [Custom Status Modules](./docs/tutorials/02-custom-status.md)
- [Troubleshooting](./docs/guides/troubleshooting.md)
- [Configuration Reference](./docs/reference/configuration.md)
- [Status Line Reference](./docs/reference/status-line.md)
