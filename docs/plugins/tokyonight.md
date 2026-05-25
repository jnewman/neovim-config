# tokyonight-nvim

## Purpose

A deep blue/purple colorscheme inspired by Tokyo at night. Included as an alternative to Catppuccin in the theme cycling rotation.

## Keybindings

| Key | Mode | Action |
|-----|------|--------|
| `<leader>tt` | Normal | Cycle to this theme (second in rotation) |

## Config Notes

- `style = "night"` — the darkest Tokyo Night variant; other options: `"storm"`, `"moon"`, `"day"`
- `terminal_colors = true` — sets terminal ANSI colors to match the theme
- Activated via the theme cycler in `colorscheme.lua`; not set as the default
