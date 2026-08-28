# chalk

## Purpose

The day half of the **`black`** pair;
[gruvbox-dark-hard](gruvbox-dark-hard.md) is the night half. A port of Ghostty's
"Chalk" terminal theme — a neutral charcoal background with saturated red, blue,
and cyan accents.

Chalk has no Neovim colorscheme, so it lives in this repo at `colors/chalk.lua`
and generates its highlight groups with
[mini.base16](https://github.com/nvim-mini/mini.base16).

## Keybindings

See [theme pairs](../themes.md) — `<leader>tt` cycles pairs, not individual
themes.

## Config Notes

- Both halves of `black` are **dark-background** themes; the day slot names the
  pair member, not the luminance
- Background (`#2b2d2e`), foreground, and six of the eight accents come verbatim
  from Ghostty
- Chalk's `selection-background` is `#e4e8ed`, a near-white that pairs with its
  own `selection-foreground`. mini.base16 keeps `base05` as the Visual
  foreground, so that value is unusable as `base02`; the selection is taken from
  the neutral ramp instead (`base05` on `base02` = 5.91), and `#e4e8ed` is reused
  as `base06`
- Two accents are lifted to hold the **4.5:1** floor, and one is synthesized:

  | Slot | Role | Source | Final | Ratio |
  |------|------|--------|-------|-------|
  | `base03` | comments, line numbers | `#888888` | `#939393` | 3.90 → 4.50 |
  | `base0F` | delimiters | `#bd4f5a` | `#ce7c84` | 2.92 → 4.51 |
  | `base09` | numbers, constants | red + yellow | `#f89751` | 6.28 |

- Chalk has no orange in its 16 slots, so `base09` is mixed from its ANSI red and
  yellow rather than reusing a hue already spoken for
