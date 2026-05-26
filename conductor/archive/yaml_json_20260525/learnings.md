# Track Learnings: yaml_json_20260525

Patterns, gotchas, and context discovered during implementation.

## Codebase Patterns (Inherited)

- Lua config uses one file per concern under `lua/config/`; `lua/init.lua` is the sole entry point that requires each module in order
- Nix module at `modules/neovim.nix` owns all plugin declarations via `programs.neovim.plugins`; Lua files are symlinked into `~/.config/nvim/lua/` via `xdg.configFile."nvim/lua"`
- `nix fmt` auto-formats all `.nix` files via the `formatter` output in `flake.nix`

---

## [2026-05-25] - Phase 1 Task 1: Add SchemaStore-nvim to plugins.nix
- **Implemented:** Added `pkgs.vimPlugins.SchemaStore-nvim` to modules/plugins.nix; rebuilt and installed pack
- **Files changed:** modules/plugins.nix
- **Learnings:**
  - Patterns: `pkgs.vimPlugins.SchemaStore-nvim` is the correct Nix attribute name (capital S, capital S, hyphen-nvim)
  - Gotchas: Nix attribute name does not match the plugin's GitHub repo casing exactly — check nixpkgs search before guessing

---

## [2026-05-25] - Phase 1 Task 2: Add LSP servers and yq to Brewfile
- **Implemented:** Added yaml-language-server and yq to Brewfile; ran brew bundle
- **Files changed:** Brewfile
- **Learnings:**
  - Gotchas: `vscode-json-languageserver` (jsonls) has no Homebrew formula — install via `npm install -g vscode-langservers-extracted`
  - Patterns: yq was already installed; brew bundle is idempotent

---

## [2026-05-25] - Phase 2 Task 1: Enable yaml/json Treesitter parsers
- **Implemented:** Added ensure_installed = { "yaml", "json" } to treesitter.lua
- **Files changed:** lua/config/treesitter.lua
- **Learnings:**
  - Gotchas: Discovered pre-existing lualine bug — `theme = "catppuccin"` fails because catppuccin only ships flavour-specific lualine themes (catppuccin-mocha, etc.), not a plain "catppuccin" theme. Fixed by changing to `theme = "auto"`.
  - Patterns: `theme = "auto"` in lualine adapts to the active colorscheme at runtime, which is correct when cycling themes with <leader>tt

---

## [2026-05-25] - Phase 3: LSP Configuration
- **Implemented:** Added yamlls and jsonls using vim.lsp.config (Neovim 0.12 native API)
- **Files changed:** lua/config/lsp.lua
- **Learnings:**
  - Patterns: This config uses `vim.lsp.config` + `vim.lsp.enable` (Neovim 0.10+ built-in API), NOT nvim-lspconfig. New LSP servers must follow this pattern.
  - Patterns: `require("schemastore").yaml.schemas()` / `.json.schemas()` can be called inline in the settings table at module load time — schemastore is always available from the pack.

---

## [2026-05-25] - Phase 4: Formatter Integration
- **Implemented:** Added yq formatters for yaml and json to conform.nvim; added <leader>cf format keymap
- **Files changed:** lua/config/format.lua, lua/config/keymaps.lua
- **Learnings:**
  - Gotchas: conform's built-in yq formatter uses `yq -P -` which outputs YAML regardless of input — requires a custom formatter for JSON files to use `yq -o=json . -`
  - Gotchas: yq v4 has no flag for blank lines between top-level keys — use awk post-processing: `awk 'NR>1 && /^[^ \t]/ && !/^---/ { print "" } { print }'`
  - Patterns: conform custom formatters can use `command = "sh"` + `args = { "-c", "..." }` to pipe through shell commands
