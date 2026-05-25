# indent-blankline.nvim

## Purpose

Adds visual indent guides (thin vertical lines) and highlights the current scope's indent level. Makes deeply nested code easier to follow.

## Keybindings

None — passive visual enhancement.

## Config Notes

- `scope.enabled = true` / `scope.show_start = true` — underlines the opening line of the current scope
- `scope.show_end = false` — end-of-scope underline is hidden to reduce visual noise
- Disabled for UI-heavy filetypes: `help`, `terminal`, `lazy`, `mason`, `NvimTree`, `Trouble`, `TelescopePrompt`
