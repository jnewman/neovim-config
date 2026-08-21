# fairyfloss

## Purpose

The day half of the **`cyber`** pair; [tokyonight](tokyonight.md) Moon is the
night half. A port of Ghostty's "Fairyfloss" terminal theme — a soft purple
background with mint, gold, and pink pastel accents.

Fairyfloss has no maintained Neovim colorscheme, so it lives in this repo at
`colors/fairyfloss.lua` and generates its highlight groups with
[mini.base16](https://github.com/nvim-mini/mini.base16) — which covers
treesitter, LSP, gitsigns, indent-blankline, telescope, which-key, blink.cmp,
and markview.

## Keybindings

See [theme pairs](../themes.md) — `<leader>tt` cycles pairs, not individual
themes.

## Config Notes

- Despite the day slot this is a **dark-background** theme (`#5a5475`)
- Background, foreground, and visual selection come verbatim from Ghostty
- That mid-tone purple caps contrast at **7.10:1** against pure white, so a flat
  4.5:1 floor would wash the palette to pastel and collapse ANSI red onto ANSI
  magenta. The floor is split by how much text a slot paints: **4.5:1** for the
  high-traffic roles (comments, line numbers, strings, functions, delimiters)
  and **3:1** for the accents.
- Only three values needed lifting; the rest are Fairyfloss's own syntax colors:

  | Slot | Role | Source | Final | Ratio |
  |------|------|--------|-------|-------|
  | `base03` | comments, line numbers | `#8077a8` | `#cfccde` | 1.73 → 4.51 |
  | `base08` | variables, errors | `#f92672` | `#fc81ad` | 1.87 → 3.00 |
  | `base0F` | delimiters | `#6090cb` | `#bcd0e9` | 2.15 → 4.51 |

- `base03` also drives `LineNr`, `SignColumn`, `StatusLineNC`, and `TabLine`, so
  it stays a neutral. Fairyfloss's signature gold comment is restored by an
  explicit `Comment` override (`#f3cb00`, 4.51:1) after `setup()`.
