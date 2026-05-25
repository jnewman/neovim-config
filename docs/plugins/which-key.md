# which-key.nvim

## Purpose

Displays a popup showing available keybindings when you pause after pressing a prefix key (e.g., `<leader>`). Makes the keymap discoverable without memorization.

## Keybindings

| Key | Mode | Action |
|-----|------|--------|
| `<leader>?` | Normal | Show all buffer-local keymaps in a popup |

Prefix groups registered (shown as labels in the popup):

| Prefix | Group |
|--------|-------|
| `<leader>c` | Code |
| `<leader>f` | Find |
| `<leader>g` | Git |
| `<leader>gp` | Pull Request |
| `<leader>gr` | Review |
| `<leader>h` | Hunk |
| `<leader>r` | Rename/Refactor |
| `<leader>t` | Theme |

## Config Notes

- `preset = "modern"` — uses the updated which-key v3 UI style
- `delay = 300` — popup appears after 300ms of inactivity on a prefix key
- `icons.mappings = true` — shows icons next to keybinding descriptions where available
