# django

## Purpose

The day half of the **`emerald`** pair;
[django-reborn-again](django-reborn-again.md) is the night half. A port of
Ghostty's "Django" terminal theme — a dark green background with orange, yellow,
and green accents.

Django has no Neovim colorscheme, so it lives in this repo at
`colors/django.lua` and generates its highlight groups with
[mini.base16](https://github.com/nvim-mini/mini.base16).

## Keybindings

See [theme pairs](../themes.md) — `<leader>tt` cycles pairs, not individual
themes.

## Config Notes

- Both halves of `emerald` are **dark-background** themes; the day slot names the
  pair member, not the luminance
- Background (`#0b2f20`), foreground, visual selection, and six of the eight
  accents come verbatim from Ghostty
- Django's ANSI palette is degenerate in two places, so three values are adjusted
  to hold the **4.5:1** floor:

  | Slot | Role | Source | Final | Ratio |
  |------|------|--------|-------|-------|
  | `base03` | comments, line numbers | `#585858` | `#8f8f8f` | 2.05 → 4.50 |
  | `base0D` | functions | `#315d3f` | `#549f6b` | 1.92 → 4.54 |
  | `base0F` | delimiters | `#568264` | `#679b77` | 3.31 → 4.53 |

- Django's ANSI magenta is plain `#f8f8f8` — the same white as the foreground —
  so `base0E` (keywords) borrows ANSI bright red `#ff943b` instead, keeping
  keywords distinct from every green in the theme.
