# nvim-treesitter

## Purpose

Provides accurate, fast syntax highlighting and indentation by parsing source files into an AST. Required by several other plugins (flash.nvim treesitter mode, ibl scope detection, blink.cmp menu rendering).

## Keybindings

None configured — treesitter works passively in the background.

## Config Notes

nixpkgs ships nvim-treesitter's **`main` branch**, whose `setup()` only configures
`install_dir`; the classic `highlight`/`indent`/`ensure_installed` options are
ignored. Highlighting and indentation are therefore driven by Neovim core in
`lua/config/treesitter.lua`:

- Parsers and their queries are **prebuilt by Nix** and placed on the runtimepath
  (`modules/treesitter-parsers.nix`) — there is no `:TSInstall` and no compiler at
  runtime. The bundled language set is defined there; keep it in sync with the
  filetypes you want highlighted.
- A `FileType` autocmd enables highlighting via `vim.treesitter.start()` and wires
  `indentexpr` to `require('nvim-treesitter').indentexpr()`. A filetype with no
  bundled parser silently keeps regex syntax.
- Filetype→language exceptions are registered explicitly: `typescriptreact`→`tsx`,
  `terraform`/`terraform-vars`→`hcl`.
- `scripts/ts-smoke.sh` verifies (headless, no compiler on PATH) that parsers load
  and highlighting activates.
