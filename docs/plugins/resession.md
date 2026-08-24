# resession.nvim

## Purpose

Save and restore editor sessions (open buffers, window layout, cwd) by name.

## Keybindings

| Key | Mode | Action |
|-----|------|--------|
| `<leader>ss` | Normal | Save a session |
| `<leader>sl` | Normal | Load a session |
| `<leader>sd` | Normal | Delete a session |

Each prompts for a session name via `vim.ui.select`/`vim.ui.input`. The
`<leader>s` group is registered as "Session" in which-key.

## Config Notes

Default config (`require("resession").setup()` with no options) — no
autosave or auto-load-on-startup, sessions are only saved/loaded on demand.
