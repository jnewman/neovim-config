# Comment.nvim

## Purpose

Adds motions for toggling line and block comments. Supports `gcc`/`gbc` in Normal mode and `gc`/`gb` operators in Visual mode, matching the feel of built-in Vim motions.

## Keybindings

| Key | Mode | Action |
|-----|------|--------|
| `gcc` | Normal | Toggle line comment |
| `gbc` | Normal | Toggle block comment |
| `gc` | Visual | Toggle line comment on selection |
| `gb` | Visual | Toggle block comment on selection |
| `gcO` | Normal | Add comment on line above |
| `gco` | Normal | Add comment on line below |
| `gcA` | Normal | Add comment at end of line |

## Config Notes

- `padding = true` — inserts a space between the comment marker and text
- `sticky = true` — cursor stays on the same character after toggling
- `mappings.extra = true` — enables the `gcO`, `gco`, `gcA` extra mappings
