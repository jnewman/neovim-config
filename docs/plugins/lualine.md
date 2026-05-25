# lualine.nvim

## Purpose

A fast, configurable statusline. Displays mode, branch, diff stats, diagnostics, filename, filetype, scroll progress, and cursor position. Uses the Catppuccin theme by default to stay visually consistent.

## Keybindings

None — passive UI element.

## Config Notes

- `theme = "catppuccin"` — matches the default colorscheme; updates automatically when the theme is cycled
- `globalstatus = true` — single statusline shared across all windows (requires Neovim 0.7+)
- `component_separators` and `section_separators` set to powerline-style arrows (requires a Nerd Font)
- `filename path = 1` — shows relative path rather than just the filename, useful in monorepos
