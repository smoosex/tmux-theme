# Frequently Asked Questions

## Window names are wrong

Change the window text format:

```bash
set -g @theme_window_text "#W"
set -g @theme_window_current_text "#W"
```

## Icons are missing

Use a Nerd Font in your terminal.

## My theme is not changing

Check these in order:

1. Restart tmux completely.
2. Set `@theme` before `run ~/.config/tmux/plugins/tmux-theme/theme.tmux`.
3. Do not use `-o` in your own tmux config for `@theme*` options.
4. If you use an external theme, make sure `~/.config/tmux/theme/<name>.conf` exists.
5. Missing themes fall back to `everforest`.
