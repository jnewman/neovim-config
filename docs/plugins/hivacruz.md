# hivacruz

## Purpose

The night half of the **`blue`** pair; [blue-dolphin](blue-dolphin.md) is the day
half. A port of Ghostty's "Hivacruz" terminal theme — an Atelier Sulphurpool
palette over a dark navy background.

Hivacruz has no Neovim colorscheme, so it lives in this repo at
`colors/hivacruz.lua` and generates its highlight groups with
[mini.base16](https://github.com/nvim-mini/mini.base16).

## Keybindings

See [theme pairs](../themes.md) — `<leader>tt` cycles pairs, not individual
themes.

## Config Notes

- Background (`#132638`), foreground, visual selection, and six of the eight
  accents come verbatim from Ghostty
- Ghostty's ANSI 11 and 12 are greys rather than a bright yellow and blue, so
  `base03` takes ANSI 12 (`#898ea4`, 4.75:1) as its neutral and the accents come
  from the normal-intensity half of the palette
- Two accents are lifted to hold the **4.5:1** floor:

  | Slot | Role | Source | Final | Ratio |
  |------|------|--------|-------|-------|
  | `base0D` | functions | `#3d8fd1` | `#3f90d2` | 4.44 → 4.50 |
  | `base0F` | delimiters | `#9c637a` | `#ad7e91` | 3.29 → 4.53 |
