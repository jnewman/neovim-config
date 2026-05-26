# Codebase Patterns

Reusable patterns discovered during development. Read this before starting new work.

## Code Conventions
- Lua config uses one file per concern under `lua/config/`; `lua/init.lua` is the sole entry point that requires each module in order (from: nix_foundation_20260429, 2026-04-29)
- Catppuccin `flavour = "auto"` respects `vim.o.background` — dark → Mocha, light → Latte. Toggle with `<leader>tt` via `vim.o.background` flip (from: nix_foundation_20260429, 2026-04-29)
- Use `theme = "auto"` in lualine when multiple colorschemes are cycled — lualine reads `vim.g.colors_name` at runtime; catppuccin only ships flavour-specific themes (`catppuccin-mocha` etc.), not a plain `catppuccin` theme (from: yaml_json_20260525, 2026-05-25)
- All new LSP servers use `vim.lsp.config` + `vim.lsp.enable` (Neovim 0.10+ native API) — do NOT add nvim-lspconfig; the existing `lua/config/lsp.lua` pattern must be followed (from: yaml_json_20260525, 2026-05-25)
- conform custom formatters that need shell pipelines use `command = "sh"`, `args = { "-c", "..." }`, `stdin = true` — useful when a formatter needs post-processing (e.g. yq | awk) (from: yaml_json_20260525, 2026-05-25)

## Architecture
- Nix module at `modules/neovim.nix` owns all plugin declarations via `programs.neovim.plugins`; Lua files are symlinked into `~/.config/nvim/lua/` via `xdg.configFile."nvim/lua"` (from: nix_foundation_20260429, 2026-04-29)
- `nix fmt` auto-formats all `.nix` files via the `formatter` output in `flake.nix` (nixfmt-rfc-style); no separate config file needed (from: nix_foundation_20260429, 2026-04-29)

## Gotchas
- `vscode-json-languageserver` (jsonls) has no Homebrew formula — install via `npm install -g vscode-langservers-extracted` (from: yaml_json_20260525, 2026-05-25)
- yq v4 has no flag for blank lines between top-level YAML keys — post-process with `awk 'NR>1 && /^[^ \t]/ && !/^---/ { print "" } { print }'` (from: yaml_json_20260525, 2026-05-25)
- conform's built-in `yq` formatter uses `yq -P -` which always outputs YAML — define a separate `yq_json` formatter with `args = { "-o=json", ".", "-" }` for JSON files (from: yaml_json_20260525, 2026-05-25)

## Testing
<!-- Patterns will be added as tracks are completed -->

---
Last refreshed: 2026-05-25
