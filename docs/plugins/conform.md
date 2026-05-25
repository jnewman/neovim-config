# conform-nvim

## Purpose

Thin formatter integration layer. Runs formatters on save and falls back to the LSP formatter if no dedicated formatter is configured for the current file type.

## Keybindings

None — formatting runs automatically on save.

## Config Notes

- `formatters_by_ft.lua = { "stylua" }` — stylua is the only declared formatter (installed via Homebrew)
- `format_on_save.lsp_fallback = true` — any file type without an explicit formatter entry falls back to the LSP's formatting capability
- `timeout_ms = 500` — format requests that exceed 500ms are abandoned to avoid blocking saves
