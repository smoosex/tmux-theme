# tmux-theme

一个通用的 tmux 主题插件，内置多套主题，并支持加载本地自定义主题。

<p align="center">
  <img src="./assets/tmux-theme-demo.png" alt="tmux-theme 演示图"/>
</p>

<p align="center">
  图中配置参考：<a href="https://github.com/smoosex/dotfiles">smoosex/dotfiles</a>
</p>

## 内置主题

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

默认主题为 `everforest`。

## 安装

如果你想正常显示默认图标，请在终端中使用 Nerd Font。

### 手动安装

```bash
mkdir -p ~/.config/tmux/plugins/tmux-theme
git clone <repo-url> ~/.config/tmux/plugins/tmux-theme
```

把下面的配置加到 `~/.tmux.conf`：

```bash
set -g @theme "everforest"
set -g @theme_switch_key "T"
run ~/.config/tmux/plugins/tmux-theme/theme.tmux
```

### 使用 TPM

```bash
set -g @plugin '<your-user>/tmux-theme'
set -g @plugin 'tmux-plugins/tpm'

set -g @theme "rosepine"

run '~/.tmux/plugins/tpm/tpm'
```

## 外部主题

插件会优先检查 `~/.config/tmux/theme/<name>.conf`，然后才会使用仓库内置主题。

示例：

```bash
set -g @theme "my-theme"
run ~/.config/tmux/plugins/tmux-theme/theme.tmux
```

如果 `~/.config/tmux/theme/my-theme.conf` 不存在，插件会继续尝试同名内置主题；如果还找不到，就回退到 `everforest`。

外部主题文件使用和内置主题相同的 `@thm_*` 变量格式，可以参考 [`themes/`](/Users/smoose/Documents/Code/mine/tmux-theme/themes) 目录中的文件。

## 主题切换器

按 `prefix + T` 就能调出内置主题切换菜单。

```bash
set -g @theme_switch_key "T"
```

如果你不想要这个快捷键，把它设为空字符串就行。

## 配置示例

```bash
set -g mouse on
set -g default-terminal "tmux-256color"

set -g @theme "catppuccin-frappe"
set -g @theme_switch_key "T"
set -g @theme_window_status_style "rounded"

run ~/.config/tmux/plugins/tmux-theme/theme.tmux

set -g status-left ""
set -g status-right "#{E:@theme_status_application}"
set -agF status-right "#{E:@theme_status_cpu}"
set -ag status-right "#{E:@theme_status_session}"
set -ag status-right "#{E:@theme_status_uptime}"
set -agF status-right "#{E:@theme_status_battery}"
```

## 主题生成

仓库内提供了 [`scripts/generate_themes.py`](/Users/smoose/Documents/Code/mine/tmux-theme/scripts/generate_themes.py)，用于开发阶段导入主题。

- 主题名与 `base16` 兜底来源：`/Users/smoose/Documents/Code/mine/matheme/themes`
- 更丰富的调色板来源：`/Users/smoose/.local/share/nvim/lazy/base46/lua/base46/themes`

这个脚本会生成仓库自己的 `themes/*.conf` 文件，运行时并不依赖这些源目录。

## 文档

- [快速开始](./docs/tutorials/01-getting-started.md)
- [自定义状态栏模块](./docs/tutorials/02-custom-status.md)
- [故障排查](./docs/guides/troubleshooting.md)
- [配置参考](./docs/reference/configuration.md)
- [状态栏参考](./docs/reference/status-line.md)
