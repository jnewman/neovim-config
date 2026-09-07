# bufferline.nvim

## Purpose

A tab-style bar across the top listing open buffers, with LSP diagnostic
counts per buffer and a filetype icon per tab (via `nvim-web-devicons`).

## Keybindings

| Key | Mode | Action |
|-----|------|--------|
| `<S-h>` | Normal | Previous buffer |
| `<S-l>` | Normal | Next buffer |
| `<leader>bp` | Normal | Pick a buffer (jump by label) |
| `<leader>bd` | Normal | Delete (close) the current buffer |
| `<leader>bo` | Normal | Close all other buffers |

The `<leader>b` group is registered as "Buffer" in which-key.

## Config Notes

- `show_buffer_icons` is `true` (needs `nvim-web-devicons`, added for this).
  `show_buffer_close_icons` and `show_close_icon` stay `false` to match the
  icon-free look used elsewhere (lualine, incline).
- `diagnostics = "nvim_lsp"` shows an error/warning count badge per buffer.
