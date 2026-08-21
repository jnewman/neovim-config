# lualine.nvim

## Purpose

A fast, configurable statusline. Displays mode, branch, diff stats, diagnostics, filename, filetype, scroll progress, and cursor position. Derives its palette from the active colorscheme to stay visually consistent.

## Keybindings

None — passive UI element.

## Config Notes

- `theme = "auto"` — derived from the active colorscheme's highlight groups, so
  it follows every theme pair without a bundled lualine palette
- `globalstatus = true` — single statusline shared across all windows (requires Neovim 0.7+)
- `component_separators` and `section_separators` set to powerline-style arrows (requires a Nerd Font)
- `filename path = 1` — shows relative path rather than just the filename, useful in monorepos
