# django-smooth

## Purpose

The day half of the **`emerald`** pair;
[django-reborn-again](django-reborn-again.md) is the night half. A port of
Ghostty's "Django Smooth" terminal theme — Django's orange, yellow, and green
accents over a lighter, softer green background.

Django Smooth has no Neovim colorscheme, so it lives in this repo at
`colors/django-smooth.lua` and generates its highlight groups with
[mini.base16](https://github.com/nvim-mini/mini.base16).

## Keybindings

See [theme pairs](../themes.md) — `<leader>tt` cycles pairs, not individual
themes.

## Config Notes

- Both halves of `emerald` are **dark-background** themes; the day slot names the
  pair member, not the luminance
- Background (`#245032`), foreground, visual selection, and five of the eight
  accents come verbatim from Ghostty
- Django Smooth inherits Django's two degenerate ANSI slots, so four values are
  adjusted to hold the **4.5:1** floor:

  | Slot | Role | Source | Final | Ratio |
  |------|------|--------|-------|-------|
  | `base03` | comments, line numbers | `#989898` | `#b5b5b5` | 3.21 → 4.51 |
  | `base0B` | strings | `#41a83e` | `#6ec96b` | 3.04 → 4.51 |
  | `base0D` | functions | `#989898` | `#5fd9a0` | substituted |
  | `base0F` | delimiters | — | `#9bbda5` | 4.50 |

- ANSI blue is the neutral grey `#989898`, which collides with `base03`'s role,
  so `base0D` (functions) takes a mint from the theme's own green family
- ANSI magenta is plain `#f8f8f8` — the same white as the foreground — so
  `base0E` (keywords) borrows ANSI bright red `#ff943b`, as in the night half
