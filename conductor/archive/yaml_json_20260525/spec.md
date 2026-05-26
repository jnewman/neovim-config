# Spec: Add YAML and JSON Highlighting Support

## Overview

Extend the Neovim config with full YAML and JSON language support: Treesitter-based syntax
highlighting, LSP integration (with SchemaStore-driven schema validation), and yq-based formatting
via conform.nvim. A format keymap will be wired up for these file types.

## Functional Requirements

### Treesitter
- Install `yaml` and `json` parsers (via `:TSInstall` or auto-install config)
- Enable syntax highlighting, indentation, and text objects for both file types

### LSP
- Add `yaml-language-server` to nvim-lspconfig setup
- Add `vscode-json-languageserver` (jsonls) to nvim-lspconfig setup
- Integrate `schemastore.nvim` to provide automatic schema selection for both servers
  - yaml-language-server: `schemastore.yaml.schemas()`
  - jsonls: `schemastore.json.schemas()` with `validate.enable = true`

### Formatters
- Register `yq` as the formatter for `yaml` and `json` filetypes in conform.nvim
- yq must be added to `Brewfile`

### Keymaps
- Add a format keymap (e.g. `<leader>cf`) for YAML and JSON buffers that calls `conform.format()`
  - If a global format keymap already exists, ensure it applies to these filetypes without a new binding

## Non-Functional Requirements

- yaml-language-server and jsonls must be installed via Homebrew and added to `Brewfile`
- schemastore.nvim added as a Nix-managed plugin in `modules/plugins.nix`
- No new global keymaps that conflict with existing bindings

## Acceptance Criteria

- [ ] Opening a `.yaml`/`.yml` file shows Treesitter syntax highlighting and LSP diagnostics
- [ ] Opening a `.json` file shows Treesitter syntax highlighting and LSP diagnostics
- [ ] Schema is auto-detected for known files (e.g. GitHub Actions workflow, docker-compose.yml)
- [ ] `yq` formats YAML and JSON files via conform.nvim (format keymap works)
- [ ] CI lint and test passes

## Out of Scope

- TOML support
- Custom schema registration beyond SchemaStore
- JSON5 or JSONC support
