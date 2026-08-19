# melange-nvim

## Purpose

A warm, low-contrast colorscheme. Used as the **dark-mode** default theme;
belafonte-day is the light-mode counterpart.

## Keybindings

| Key | Mode | Action |
|-----|------|--------|
| `<leader>tt` | Normal | Cycle to this theme (seventh in the rotation) |

## Config Notes

- Selected automatically in `lua/config/colorscheme.lua` when `'background'` is
  `dark` — see [belafonte-day](belafonte-day.md) for how the light/dark switch works
- Configured via `'background'` alone; melange has no `setup()` function
