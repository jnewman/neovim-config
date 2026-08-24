# rainbow-delimiters.nvim

## Purpose

Alternates highlight colors across nested delimiters (parens, brackets, braces,
and language-specific pairs like `do`/`end`) using tree-sitter, so nesting
depth is visible at a glance.

## Keybindings

None — purely visual, always on for filetypes with a tree-sitter parser.

## Config Notes

Zero-config: works out of the box once installed (`plugin/rainbow-delimiters.lua`
sets sane defaults and highlight groups automatically), so there's no
`lua/config/rainbow-delimiters.lua` — nothing to call. Highlight colors
(`RainbowDelimiter*`) are linked with `default = true`, so a colorscheme can
override them.
