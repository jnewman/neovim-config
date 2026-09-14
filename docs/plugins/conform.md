# conform-nvim

## Purpose

Thin formatter integration layer. Runs formatters on save and falls back to the LSP formatter if no dedicated formatter is configured for the current file type.

## Keybindings

| Key | Mode | Action |
|-----|------|--------|
| `<leader>cf` | Normal | Format the current buffer (async, LSP fallback) |

Formatting also runs automatically on save; the keymap is for on-demand formatting.

## Config Notes

- Formatters are declared per filetype in `lua/config/format.lua` (stylua, ruff,
  prettier, gofmt, rustfmt, …) and run natively off PATH — every one is bundled
  into the editor by the flake (`modules/lsp-tools.nix`)
- `format_on_save.lsp_fallback = true` — any file type without an explicit formatter entry falls back to the LSP's formatting capability
- `timeout_ms = 10000` — format requests that exceed 10s are abandoned to avoid blocking saves
