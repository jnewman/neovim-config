# cyberdream-nvim

## Purpose

A neon cyberpunk colorscheme with high-contrast colors. Set as the **default**
colorscheme because it matches the Ghostty "Cyberpunk" theme: its neon accents
(green `#00fbac`/`#21f6bc`, pink, cyan) are the same palette, and the background
is overridden to Ghostty's purple base.

## Keybindings

| Key | Mode | Action |
|-----|------|--------|
| `<leader>tt` | Normal | Cycle themes (cyberdream also appears in the rotation) |

## Config Notes

- `italic_comments = true` — comments rendered in italics
- `borderless_telescope = false` — keeps telescope borders visible for clarity
- `theme.colors.bg = "#332a57"` (with `bg_alt = "#3d3266"`) — overrides the default
  near-black background to match the Ghostty "Cyberpunk" theme's purple base
- Set as the default via `vim.cmd.colorscheme("cyberdream")` in `colorscheme.lua`
