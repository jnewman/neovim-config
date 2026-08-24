# hardtime.nvim

## Purpose

Nudges toward better Vim motions by blocking/hinting on repeated `hjkl`,
arrow keys, and other inefficient habits.

## Keybindings

None added — active from startup by default.

- `:Hardtime toggle` — turn it off/on for the session
- `:Hardtime disable` / `:Hardtime enable` — explicit on/off

## Config Notes

Default config (`require("hardtime").setup()` with no options). The plugin's
built-in `disabled_filetypes` list already excludes this config's UI buffers
(oil, Telescope prompt, Diffview, noice, notify, etc.), so no overrides were
needed.
