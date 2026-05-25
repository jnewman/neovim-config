# flash.nvim

## Purpose

Jump to any visible location by typing a short character sequence. Highlights matches as you type and adds a label to jump directly to any of them. Works in normal, visual, and operator-pending modes.

## Keybindings

| Key | Mode | Action |
|-----|------|--------|
| `s` | Normal / Visual / Operator | Flash jump — type chars, press label to jump |
| `S` | Normal / Visual / Operator | Flash treesitter — select and jump to a treesitter node |
| `r` | Operator | Remote flash — apply an operator on a remote location without moving |
| `R` | Operator / Visual | Treesitter search across the buffer |

## Config Notes

- `modes.search.enabled = false` — flash is not triggered inside `/` search; keeps standard search unmodified
- The `s` binding replaces the built-in `s` (substitute character) — use `cl` if you need that behavior
