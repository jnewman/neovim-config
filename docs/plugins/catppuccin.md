# catppuccin-nvim

## Purpose

Provides the Catppuccin colorscheme family (Latte, Frappé, Macchiato, Mocha). Configured as Mocha with deep integrations for treesitter, LSP diagnostics, blink.cmp, gitsigns, lualine, indent-blankline, and which-key.

## Keybindings

| Key | Mode | Action |
|-----|------|--------|
| `<leader>tt` | Normal | Cycle through colorschemes (belafonte-day → tokyonight → cyberdream → …) |

## Config Notes

- `flavour = "mocha"` — dark variant; switch to `"latte"` for light
- LSP underlines use `undercurl` for errors, hints, warnings, and info
- All major plugin integrations are enabled so highlights stay consistent across the UI
