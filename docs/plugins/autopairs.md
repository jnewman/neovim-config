# nvim-autopairs

## Purpose

Automatically closes brackets, parentheses, and quotes as you type. Uses treesitter to understand context so it doesn't insert closing characters inside strings or comments where they'd be wrong.

## Keybindings

None — works automatically as you type.

## Config Notes

- `check_ts = true` — uses treesitter to determine whether to auto-close (e.g., no auto-close inside a Lua string node)
- `ts_config.lua = { "string", "source" }` — treesitter node types where autopairs is disabled for Lua files
- `disable_filetype = { "TelescopePrompt" }` — disabled in the telescope input bar to avoid interference
- Auto-bracket insertion after completion accept is disabled in blink.cmp (`auto_brackets.enabled = false`) and handled here instead
