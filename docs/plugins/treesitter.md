# nvim-treesitter

## Purpose

Provides accurate, fast syntax highlighting and indentation by parsing source files into an AST. Required by several other plugins (flash.nvim treesitter mode, ibl scope detection, blink.cmp menu rendering).

## Keybindings

None configured — treesitter works passively in the background.

After install, run `:TSInstall <language>` to add parsers for additional languages.

## Config Notes

- `highlight.enable = true` — replaces Vim's regex-based highlighting
- `indent.enable = true` — enables treesitter-aware indentation
- Parsers are installed manually via `:TSInstall` rather than declared in the Nix config, since the host Neovim compiles them natively
