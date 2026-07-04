# telescope-nvim

## Purpose

A fuzzy finder UI for files, grep results, buffers, and more. Used as the picker backend for octo.nvim (PR/issue selection). Access via `:Telescope` commands or through octo's UI.

## Keybindings

Configured under the `<leader>f` "Find" group (see `keymaps.lua`). Handlers
require `telescope.builtin` lazily so keymap setup doesn't depend on telescope
being loaded first.

| Key | Mode | Action |
|-----|------|--------|
| `<leader>ff` | Normal | Find files (fuzzy) |
| `<leader>fg` | Normal | Grep across the project (live grep) |
| `<leader>fb` | Normal | Find / switch open buffers |
| `<leader>fh` | Normal | Find help tags |

You can also invoke any picker directly via `:Telescope <builtin>` (e.g.
`:Telescope find_files`), or reach telescope through octo.nvim's picker UI.

## Config Notes

- Uses default configuration — no `telescope.setup()` call in this config
- Wired as the picker for octo.nvim (`picker = "telescope"` in `octo.lua`)
- plenary.nvim is a required dependency (utility library)
