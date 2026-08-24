# noice.nvim

## Purpose

Replaces the command line, messages, and popup menu with a nicer floating UI.
Notifications (`vim.notify`) are routed through [nvim-notify](notify.md) as
popup toasts.

## Keybindings

None added — noice overrides the built-in cmdline/messages/popupmenu UI
directly; `:Noice` opens the message history, `:Noice dismiss` clears
current notifications.

## Config Notes

- `lsp.progress.enabled = false` — LSP progress is shown by
  [fidget.nvim](fidget.md) instead, so the two don't duplicate each other.
- Everything else uses noice's defaults.
- Requires [nui.nvim](nui.md) (hard dependency, no config of its own).
