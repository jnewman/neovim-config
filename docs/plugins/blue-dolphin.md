# blue-dolphin

## Purpose

The day half of the **`blue`** pair; [hivacruz](hivacruz.md) is the night half. A
port of Ghostty's "Blue Dolphin" terminal theme — pastel accents over a saturated
teal background.

Blue Dolphin has no Neovim colorscheme, so it lives in this repo at
`colors/blue-dolphin.lua` and generates its highlight groups with
[mini.base16](https://github.com/nvim-mini/mini.base16).

## Keybindings

See [theme pairs](../themes.md) — `<leader>tt` cycles pairs, not individual
themes.

## Config Notes

- Both halves of `blue` are **dark-background** themes; the day slot names the
  pair member, not the luminance
- Background (`#006984`) and foreground come verbatim from Ghostty
- That background is **mid-luminance**, so contrast against it is capped at
  6.26:1 (pure white) — the same squeeze [fairyfloss](fairyfloss.md) has. Accents
  keep their Ghostty hue and are lifted only as far as their floor: 4.5:1 for the
  high-traffic slots, 3:1 for the rest. The palette is pastel by construction

  | Slot | Role | Source | Final | Ratio |
  |------|------|--------|-------|-------|
  | `base03` | comments, line numbers | `#9094a4` | `#d9dbe0` | 2.07 → 4.52 |
  | `base08` | variables, errors | `#ff8288` | `#ff969b` | 2.62 → 3.01 |
  | `base0B` | strings | `#b4e88d` | `#b8e993` | 4.43 → 4.51 |
  | `base0D` | functions | `#82aaff` | `#cbdcff` | 2.73 → 4.54 |
  | `base0F` | delimiters | `#ddb0f6` | `#ecd2fa` | 3.46 → 4.52 |

- The neutral ramp runs *darker* than `base00` rather than lighter, because
  `base00` is already mid-luminance. Ghostty's `selection-background` (`#2baeca`)
  would leave selected text at 2.19:1, so `base02` is a darkened teal instead
  (`base05` on `base02` = 9.33)
