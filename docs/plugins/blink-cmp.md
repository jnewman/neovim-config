# blink.cmp

## Purpose

A fast, extensible completion engine. Replaces nvim-cmp with lower latency and a built-in fuzzy matcher. Sources LSP completions, buffer words, and file paths.

## Keybindings

| Key | Action |
|-----|--------|
| `<Tab>` / `<S-Tab>` | Next / previous completion item |
| `<CR>` | Accept selected item |
| `<C-e>` | Dismiss completion menu |
| `<C-Space>` | Show completion menu manually |
| `<C-d>` | Scroll documentation down |
| `<C-u>` | Scroll documentation up |

## Config Notes

- `fuzzy.implementation = "lua"` — the Nix build produces a native fuzzy binary for Linux; the Lua fallback is used on the macOS host since we don't run Nix natively
- `auto_brackets.enabled = false` — bracket insertion is delegated to nvim-autopairs to avoid conflicts
- `auto_show = true` with `auto_show_delay_ms = 200` — docs pop up automatically after a short delay
- `treesitter = { "lsp" }` — LSP items render with treesitter-aware highlighting in the menu
