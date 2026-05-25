# oil.nvim

## Purpose

A file explorer that presents directories as editable buffers. You navigate and rename files the same way you'd edit text — using normal Vim motions. Saves changes when you write the buffer.

## Keybindings

| Key | Mode | Action |
|-----|------|--------|
| `-` | Normal | Open parent directory in oil |
| `<CR>` | Normal (in oil) | Open file or enter directory |
| `-` | Normal (in oil) | Go up to parent directory |
| `_` | Normal (in oil) | Open current working directory |
| `gs` | Normal (in oil) | Change sort order |
| `g.` | Normal (in oil) | Toggle hidden files |

## Config Notes

- `view_options.show_hidden = true` — hidden files (dotfiles) are visible by default
- Float window configured with `padding = 2` and `max_width = 90`; `max_height = 0` means it expands to fit content
