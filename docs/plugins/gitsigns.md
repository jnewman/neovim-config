# gitsigns-nvim

## Purpose

Shows git diff signs (added, changed, removed lines) in the sign column. Provides hunk-level staging, resetting, previewing, and blame — all without leaving Neovim.

## Keybindings

| Key | Mode | Action |
|-----|------|--------|
| `]h` | Normal | Jump to next hunk |
| `[h` | Normal | Jump to previous hunk |
| `<leader>hs` | Normal / Visual | Stage hunk (or selected lines) |
| `<leader>hr` | Normal / Visual | Reset hunk (or selected lines) |
| `<leader>hS` | Normal | Stage entire buffer |
| `<leader>hu` | Normal | Undo last stage |
| `<leader>hp` | Normal | Preview hunk inline |
| `<leader>hb` | Normal | Show full blame for current line |
| `<leader>hd` | Normal | Open diff for current file |
| `ih` | Operator / Visual | Text object — select the current hunk |

## Config Notes

- All keymaps are buffer-local (set in `on_attach`) so they only apply in buffers tracked by git
- `blame_line({ full = true })` — shows the complete commit message in the blame popup, not just the summary line
