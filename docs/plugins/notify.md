# nvim-notify

## Purpose

Popup toast notifications. Not called directly — [noice.nvim](noice.md) takes
over `vim.notify()` and renders its "notify" view through this plugin.

## Keybindings

None.

## Config Notes

- `background_colour` is a function returning the active theme's background
  (`require("config.colorscheme").background`), captured before
  [transparency](../themes.md#config-notes) clears `Normal`. The default
  (`NotifyBackground` → `Normal`) has no bg when transparent, which made
  nvim-notify warn and fade popups through `#000000`.
- Otherwise default config.
