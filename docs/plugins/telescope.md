# telescope-nvim

## Purpose

A fuzzy finder UI for files, grep results, buffers, and more. Used as the picker backend for octo.nvim (PR/issue selection). Access via `:Telescope` commands or through octo's UI.

## Keybindings

No keymaps are explicitly configured. Use `:Telescope` commands or access through octo.nvim's picker UI.

Common built-in commands:
- `:Telescope find_files` — fuzzy find files
- `:Telescope live_grep` — grep across the project
- `:Telescope buffers` — switch between open buffers

## Config Notes

- Uses default configuration — no `telescope.setup()` call in this config
- Wired as the picker for octo.nvim (`picker = "telescope"` in `octo.lua`)
- plenary.nvim is a required dependency (utility library)
