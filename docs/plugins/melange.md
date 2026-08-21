# melange-nvim

## Purpose

A warm, low-contrast colorscheme. The night half of the **`earthy`** pair;
[belafonte-day](belafonte-day.md) is the day half.

## Keybindings

See [theme pairs](../themes.md) — `<leader>tt` cycles pairs, not individual
themes.

## Config Notes

- Selected when the `earthy` pair is active and the OS is in dark mode — see
  [theme pairs](../themes.md) for how the day/night switch works
- Configured via `'background'` alone; melange has no `setup()` function.
  `lua/config/colorscheme.lua` assigns `'background'` before switching, so
  melange always renders its dark variant in this pair.
- Mirrors the Ghostty "Melange Dark" theme
