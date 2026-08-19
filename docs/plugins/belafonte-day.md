# belafonte-day

## Purpose

The **light-mode** default theme: a port of Ghostty's "Belafonte Day" terminal
theme, so Neovim matches the surrounding terminal. melange is the dark-mode
counterpart.

Belafonte Day exists only as a terminal palette, so the colorscheme lives in
this repo at `colors/belafonte-day.lua` and generates its highlight groups with
[mini.base16](https://github.com/nvim-mini/mini.base16) — which covers
treesitter, LSP, gitsigns, indent-blankline, telescope, which-key, blink.cmp,
and markview.

## Keybindings

| Key | Mode | Action |
|-----|------|--------|
| `<leader>tt` | Normal | Cycle to the next colorscheme (belafonte-day is first in the rotation) |

## Config Notes

- Applied automatically when `'background'` is `light` — see the light/dark
  switch in `lua/config/colorscheme.lua`
- Background, foreground, visual selection, and ANSI red come verbatim from the
  Ghostty theme. The other accents keep Belafonte's hues but are darkened to
  4:1 contrast against the parchment background; at their terminal lightness
  yellow (1.8:1), cyan (1.8:1), and green (2.5:1) are unreadable as syntax
  colors. Neutral ramp steps Belafonte doesn't define are interpolated.
- Belafonte has six accent hues where base16 wants eight, so keywords and
  numbers share the same warm brown, and its "cyan" is a near-neutral grey.
- `task install` symlinks `colors/` into `~/.config/nvim`, alongside `lua/`
