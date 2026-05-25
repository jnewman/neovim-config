# diffview-nvim

## Purpose

A side-by-side diff viewer and git history browser. Lets you review working tree changes and browse file or branch history with a familiar diff layout — all inside Neovim.

## Keybindings

| Key | Mode | Action |
|-----|------|--------|
| `<leader>gd` | Normal | Open diff view (working tree vs. HEAD) |
| `<leader>gh` | Normal | Browse git history for the current file |
| `<leader>gH` | Normal | Browse full branch git history |
| `<leader>gc` | Normal | Close diffview panel |

## Config Notes

- Uses default `diffview.setup()` — no custom options configured
- Navigate between changed files in the file panel with `<Tab>` / `<S-Tab>` (diffview defaults)
- Use `<leader>gc` to close; `:DiffviewClose` also works
