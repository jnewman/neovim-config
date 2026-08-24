# bufferline.nvim

## Purpose

A tab-style bar across the top listing open buffers, with LSP diagnostic
counts per buffer. Text-only — no `nvim-web-devicons` is installed, so file
icons are disabled rather than left broken.

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

- `show_buffer_icons`, `show_buffer_close_icons`, `show_close_icon` are all
  `false` to match the icon-free look used elsewhere (lualine, incline).
- `diagnostics = "nvim_lsp"` shows an error/warning count badge per buffer.
