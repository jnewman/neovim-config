# belafonte-day

## Purpose

The day half of the **`earthy`** pair: a port of Ghostty's "Belafonte Day"
terminal theme, so Neovim matches the surrounding terminal.
[melange](melange.md) is the night half. This is the only pair whose day slot is
actually a light-background theme.

Belafonte Day exists only as a terminal palette, so the colorscheme lives in
this repo at `colors/belafonte-day.lua` and generates its highlight groups with
[mini.base16](https://github.com/nvim-mini/mini.base16) — which covers
treesitter, LSP, gitsigns, indent-blankline, telescope, which-key, blink.cmp,
and markview.

## Keybindings

See [theme pairs](../themes.md) — `<leader>tt` cycles pairs, not individual
themes.

## Config Notes

- Applied when the `earthy` pair is active and the OS is in light mode — see
  [theme pairs](../themes.md) for how the day/night switch works
- Background, foreground, visual selection, and ANSI red come verbatim from the
  Ghostty theme. The other accents keep Belafonte's hues but are darkened to
  4:1 contrast against the parchment background; at their terminal lightness
  yellow (1.8:1), cyan (1.8:1), and green (2.5:1) are unreadable as syntax
  colors. Neutral ramp steps Belafonte doesn't define are interpolated.
- Belafonte has six accent hues where base16 wants eight, so keywords and
  numbers share the same warm brown, and its "cyan" is a near-neutral grey.
- `task install` symlinks `colors/` into `~/.config/nvim`, alongside `lua/`
