# gruvbox-dark-hard

## Purpose

The night half of the **`black`** pair; [chalk](chalk.md) is the day half. A port
of Ghostty's "Gruvbox Dark Hard" terminal theme — the near-black gruvbox
background with its warm retro accents.

This is a local port rather than the upstream gruvbox plugin, so it lives in this
repo at `colors/gruvbox-dark-hard.lua` and generates its highlight groups with
[mini.base16](https://github.com/nvim-mini/mini.base16) like the other ports.

## Keybindings

See [theme pairs](../themes.md) — `<leader>tt` cycles pairs, not individual
themes.

## Config Notes

- Background (`#1d2021`), foreground, visual selection, and seven of the eight
  accents come verbatim from Ghostty
- Two values are adjusted to hold the **4.5:1** floor, and one is borrowed from
  gruvbox proper:

  | Slot | Role | Source | Final | Ratio |
  |------|------|--------|-------|-------|
  | `base03` | comments, line numbers | `#665c54` | `#a89984` | 2.02 → 5.90 |
  | `base0F` | delimiters | `#d65d0e` | `#de600f` | 4.24 → 4.52 |
  | `base09` | numbers, constants | — | `#fe8019` | 6.49 |

- Gruvbox's own base16 scheme puts `#665c54` in `base03`, which reads at 2.02:1
  against this background; the theme's own fg4 (ANSI 7) is used instead so
  comments clear the floor without inventing a colour
- Ghostty's 16 slots contain no orange for this theme, so `base09` takes
  gruvbox's canonical `#fe8019`
