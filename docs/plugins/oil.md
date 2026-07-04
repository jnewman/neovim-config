# oil.nvim

## Purpose

A file explorer that presents directories as editable buffers. You navigate and rename files the same way you'd edit text — using normal Vim motions. Saves changes when you write the buffer.

## Keybindings

| Key | Mode | Action |
|-----|------|--------|
| `<leader>e` | Normal | Toggle Oil in a ~25% left pane (buffer stays alive when hidden) |
| `-` | Normal | Open parent directory in oil |
| `<CR>` | Normal (in oil) | Directory: navigate into it. File: open in the main window (see below) |
| `-` | Normal (in oil) | Go up to parent directory |
| `_` | Normal (in oil) | Open current working directory |
| `gs` | Normal (in oil) | Change sort order |
| `g.` | Normal (in oil) | Toggle hidden files |

## Config Notes

- `view_options.show_hidden = true` — hidden files (dotfiles) are visible by default
- Float window configured with `padding = 2` and `max_width = 90`; `max_height = 0` means it expands to fit content
- `<CR>` is remapped to `open_in_main` (`oil.lua`): selecting a file opens it in the
  first real (non-floating, non-Oil) window instead of replacing the Oil pane, so the
  left explorer stays put. If no other window exists it splits one off to the right.
  Directories still navigate within the pane as usual.
