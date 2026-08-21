# django-reborn-again

## Purpose

The night half of the **`emerald`** pair; [django](django.md) is the day half.
A port of Ghostty's "Django Reborn Again" terminal theme — the same accents as
django over a darker background and a softer foreground.

Lives in this repo at `colors/django-reborn-again.lua` and generates its
highlight groups with
[mini.base16](https://github.com/nvim-mini/mini.base16).

## Keybindings

See [theme pairs](../themes.md) — `<leader>tt` cycles pairs, not individual
themes.

## Config Notes

- Background (`#051f14`), foreground (`#dadedc`), visual selection, and six of
  the eight accents come verbatim from Ghostty
- Shares django's two ANSI degeneracies, so three values are adjusted to hold the
  **4.5:1** floor:

  | Slot | Role | Source | Final | Ratio |
  |------|------|--------|-------|-------|
  | `base03` | comments, line numbers | `#4c4c4c` | `#828282` | 2.02 → 4.51 |
  | `base0D` | functions | `#245032` | `#41925b` | 1.87 → 4.53 |
  | `base0F` | delimiters | `#568264` | `#5d8d6c` | 3.94 → 4.53 |

- `base0E` (keywords) borrows ANSI bright red `#ff943b`; the theme's ANSI magenta
  duplicates the foreground
- Ghostty gives this theme a gold `cursor-color` (`#ffcc00`). mini.base16 derives
  the cursor from the palette, so that gold is not represented.
